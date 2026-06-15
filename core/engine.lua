--- doprog.core.engine
---
--- The progression state machine. Each `tick()`:
---   1. bail if not in game,
---   2. run death recovery if needed (highest priority),
---   3. ask the registry for the next actionable quest,
---   4. peek the active step; if a safety gate is up and the step is NOT combat,
---      stop moving and WAIT (we never walk the crew into danger),
---   5. otherwise execute the step and publish the resulting directive.
---
--- The engine OWNS the StepContext — the dependency-injection bundle every step
--- and quest receives. Nothing in the domain layer requires a service directly;
--- they only ever touch what the engine threads through here.

---@class doprog.Engine
---@field private _mq doprog.MqAdapter
---@field private _nav doprog.NavService
---@field private _safety doprog.SafetyService
---@field private _eqbc doprog.EqbcService
---@field private _registry doprog.QuestRegistry
---@field private _log doprog.Logger
---@field private _ctx doprog.StepContext
---@field private _state doprog.EngineState
local Engine = {}
Engine.__index = Engine

---@class doprog.Engine.Deps
---@field mq doprog.MqAdapter
---@field nav doprog.NavService
---@field travel doprog.TravelService
---@field safety doprog.SafetyService
---@field eqbc doprog.EqbcService
---@field task doprog.TaskService
---@field mech doprog.MechanicsWatcher
---@field registry doprog.QuestRegistry
---@field logger doprog.LoggerFactory

---@param deps doprog.Engine.Deps
---@return doprog.Engine
function Engine.new(deps)
    assert(deps and deps.mq and deps.registry, 'Engine requires deps.mq and deps.registry')
    local log = deps.logger:forModule('Engine')
    ---@type doprog.StepContext
    local ctx = {
        mq = deps.mq,
        nav = deps.nav,
        travel = deps.travel,
        safety = deps.safety,
        eqbc = deps.eqbc,
        task = deps.task,
        mech = deps.mech,
        log = deps.logger:forModule('Step'),
    }
    return setmetatable({
        _mq = deps.mq,
        _nav = deps.nav,
        _safety = deps.safety,
        _eqbc = deps.eqbc,
        _registry = deps.registry,
        _log = log,
        _ctx = ctx,
        _state = {
            directive = 'IDLE', target = nil, zone = '', questName = nil,
            stepDesc = nil, reason = 'init', complete = false,
        },
    }, Engine)
end

--- Update and return the published state.
---@private
---@param directive doprog.Directive
---@param target doprog.SpawnQuery?
---@param questName string?
---@param stepDesc string?
---@param reason string?
---@param complete? boolean
---@return doprog.EngineState
function Engine:_set(directive, target, questName, stepDesc, reason, complete)
    local s = self._state
    if s.directive ~= directive or s.reason ~= reason then
        self._log:Debug('-> %s (%s)', directive, reason or '')
    end
    s.directive = directive
    s.target = target
    s.zone = self._mq:zoneShortName()
    s.questName = questName
    s.stepDesc = stepDesc
    s.reason = reason
    s.complete = complete or false
    return s
end

--- Advance the state machine one frame.
---@return doprog.EngineState
function Engine:tick()
    -- Process emote events so combat positioning mechanics can react this frame.
    self._ctx.mech:poll()

    if not self._mq:inGame() then
        return self:_set('IDLE', nil, nil, nil, 'not in game')
    end

    -- Death recovery preempts everything.
    if not self._safety:handleRecovery() then
        self._nav:stop()
        return self:_set('WAIT', nil, nil, nil, 'recovering')
    end

    local quest = self._registry:nextActionable(self._ctx)
    if not quest then
        local done = self._registry:isComplete(self._ctx)
        return self:_set('IDLE', nil, nil, nil,
            done and 'progression complete' or 'no startable quest (prereqs pending)', done)
    end

    local step = quest:activeStep(self._ctx)
    if not step then
        return self:_set('WAIT', nil, quest.name, nil, 'awaiting next quest')
    end

    -- Safety gate: hold movement unless the active step is combat (the host is
    -- expected to be fighting then anyway).
    local gate = self._safety:assess()
    if gate ~= 'clear' and step.kind ~= 'combat' then
        self._nav:stop()
        return self:_set('WAIT', nil, quest.name, step.desc, 'safety: ' .. gate)
    end

    -- Keep the crew tethered while we move.
    if step.kind == 'travel' then
        self._eqbc:followLead()
    end

    local result = quest:tick(self._ctx)
    -- A "done" travel/handin result still publishes its directive for this frame;
    -- the next tick will pick up the following step.
    return self:_set(result.directive, result.target, quest.name, step.desc, result.reason)
end

--- Current published state without advancing.
---@return doprog.EngineState
function Engine:snapshot()
    return self._state
end

return Engine
