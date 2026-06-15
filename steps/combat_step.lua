--- doprog.steps.combat_step
---
--- THE handoff. doprog does not fight. This step is the seam where the host
--- combat system (RGMercs / KissAssist / custom) takes over.
---
--- TBL task objectives are usually "defeat N of <faction> in <area>" rather than
--- a single named mob, so a CombatStep has two flavours:
---
---   * TARGETED — `target` is a SpawnQuery for a specific mob (named boss, a
---     particular spawn). doprog resolves it and surfaces its id.
---   * AREA/OBJECTIVE-DRIVEN — no `target`; doprog advertises NEED_COMBAT with no
---     specific spawn and lets the host pick what to kill, while watching the
---     task objective counter to know when the step is done.
---
--- Either way doprog only advertises and waits; it never issues an attack.
--- Completion is read from the task objective (or, for targeted kills without a
--- task, from the target no longer existing).

local Step = require('doprog.steps.step')

---@class doprog.CombatStep : doprog.Step
---@field private _target doprog.SpawnQuery?
---@field private _taskName string?
---@field private _objective integer?
---@field private _camp doprog.Vec3?
local CombatStep = Step.extend({})
CombatStep.__index = CombatStep

---@param opts doprog.Step.Opts # needs `target` OR (`taskName` [+ `objective`])
---@return doprog.CombatStep
function CombatStep.new(opts)
    assert(opts and (opts.target or opts.taskName),
        'CombatStep requires a target spawn or a taskName to track completion')
    local self = Step.new('combat', opts) ---@cast self doprog.CombatStep
    self._target = opts.target
    self._taskName = opts.taskName
    self._objective = opts.objective
    self._camp = opts.loc
    return setmetatable(self, CombatStep)
end

---@param ctx doprog.StepContext
---@return boolean
function CombatStep:isComplete(ctx)
    if self._taskName and self._objective then
        return ctx.task:objectiveDone(self._taskName, self._objective)
    end
    if self._taskName then
        return ctx.task:isComplete(self._taskName)
    end
    -- Targeted kill with no task wiring: done once no matching spawn remains.
    return self._target ~= nil and ctx.mq:findSpawn(self._target) == nil
end

---@param ctx doprog.StepContext
---@return doprog.StepResult
function CombatStep:execute(ctx)
    local zr = self:ensureZone(ctx)
    if zr then return zr end

    if self:isComplete(ctx) then
        ctx.log:Info('combat objective satisfied: %s', self.desc)
        return Step.done('TRAVEL')
    end

    -- Optionally move to the camp/pull spot before handing off.
    if self._camp and not ctx.nav:to(self._camp) then
        return Step.running('TRAVEL', 'moving to camp for ' .. self.desc)
    end

    local result = Step.running('NEED_COMBAT', self.desc)
    if self._target then
        local id = ctx.mq:findSpawn(self._target)
        if not id then
            -- Specific target not up (respawn/repop). Wait, don't advance.
            return Step.running('WAIT', 'awaiting spawn for ' .. self.desc)
        end
        result.target = { id = id, name = self._target.name }
    end
    -- Area/objective-driven: target stays nil and the host selects what to kill.
    return result
end

return CombatStep
