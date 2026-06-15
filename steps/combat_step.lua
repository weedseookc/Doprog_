--- doprog.steps.combat_step
---
--- THE handoff. doprog does not fight. This step is the seam where the host
--- combat system (RGMercs / KissAssist / custom) takes over. When a kill is
--- required, this step:
---
---   1. ensures we are in the right zone and (optionally) navs to the camp,
---   2. acquires a valid target spawn,
---   3. advertises directive == "NEED_COMBAT" with that target,
---   4. WAITS — returning a "running" result every tick — until the task
---      objective ticks over (or, if no objective is configured, until no more
---      matching spawns remain).
---
--- The combat system observes `State:shouldEngage()` / `State.target` and does
--- the actual killing. doprog never issues an attack command.

local Step = require('doprog.steps.step')

---@class doprog.CombatStep : doprog.Step
---@field private _target doprog.SpawnQuery
---@field private _taskName string?
---@field private _objective integer?
---@field private _camp doprog.Vec3?
local CombatStep = Step.extend({})
CombatStep.__index = CombatStep

---@param opts doprog.Step.Opts # requires .target; .taskName/.objective drive completion
---@return doprog.CombatStep
function CombatStep.new(opts)
    assert(opts and opts.target, 'CombatStep requires opts.target')
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
    -- No task wiring: complete once no matching spawn remains.
    return ctx.mq:findSpawn(self._target) == nil
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

    local id = ctx.mq:findSpawn(self._target)
    if not id then
        -- Nothing to fight right now (respawn/repop). Wait, don't advance.
        return Step.running('WAIT', 'awaiting spawn for ' .. self.desc)
    end

    -- Hand the target to the combat system and wait. We surface it via the
    -- result's `target` field; the engine copies it onto the State facade.
    local result = Step.running('NEED_COMBAT', self.desc)
    result.target = { id = id, name = self._target.name }
    return result
end

return CombatStep
