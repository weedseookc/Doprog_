--- doprog.steps.combat_step
---
--- THE handoff — but doprog does the *target selection*, because it is the only
--- thing that knows the quest rules. A combat tool left to its own devices will
--- happily grind mephits that don't count, or never leave the quest giver. So
--- this step:
---
---   1. picks a VALID target via the SpawnQuery (inclusion by name/npc/radius,
---      with `exclude` substrings to skip mobs that don't count),
---   2. navigates the lead to it if it is out of range (going "deep into the
---      zone" as needed) — host holds because shouldEngage() is false while we
---      travel,
---   3. /targets it and advertises NEED_COMBAT so the host kills the *right* mob,
---   4. watches the task objective counter and advances when it ticks over.
---
--- For objectives with no nameable target (pure "defeat N in this area"), pass no
--- `target` and an optional `loc` camp; doprog moves to the camp and advertises
--- NEED_COMBAT with no specific spawn, letting the host pick among local mobs.
--- doprog still never issues an attack.

local Step = require('doprog.steps.step')

local ENGAGE_RANGE = 50 -- units; within this we hand off, beyond it we close in

---@class doprog.CombatStep : doprog.Step
---@field private _target doprog.SpawnQuery?
---@field private _taskName string?
---@field private _objective integer?
---@field private _camp doprog.Vec3?
---@field private _engageRange number
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
    self._engageRange = opts.engageRange or ENGAGE_RANGE
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
    return self._target ~= nil and ctx.mq:findSpawn(self._target) == nil
end

--- Drive a nameable target: select, close distance, target, hand off.
---@private
---@param ctx doprog.StepContext
---@return doprog.StepResult
function CombatStep:_driveTarget(ctx)
    local id, name = ctx.mq:findSpawnFiltered(self._target)
    if not id then
        -- No valid target in range. Move to the camp to look, else wait.
        if self._camp and not ctx.nav:to(self._camp) then
            ctx.eqbc:followLead()
            return Step.running('TRAVEL', 'moving to find targets for ' .. self.desc)
        end
        return Step.running('WAIT', 'no valid target yet for ' .. self.desc)
    end

    -- doprog owns targeting: lock the correct mob so the host attacks it.
    ctx.mq:target(id)

    local dist = ctx.mq:spawnDistance(id)
    if dist > self._engageRange then
        -- Close the distance ourselves; host holds (shouldEngage is false).
        ctx.eqbc:followLead()
        ctx.mq:navTo({ id = id })
        return Step.running('TRAVEL', ('closing on %s for %s'):format(name or 'target', self.desc))
    end

    if ctx.nav:isActive() then ctx.nav:stop() end
    local result = Step.running('NEED_COMBAT', self.desc)
    result.target = { id = id, name = name }
    return result
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

    if self._target then
        return self:_driveTarget(ctx)
    end

    -- Area/objective-driven with no nameable target: optionally camp, then let
    -- the host select among local mobs while we watch the objective.
    if self._camp and not ctx.nav:to(self._camp) then
        ctx.eqbc:followLead()
        return Step.running('TRAVEL', 'moving to camp for ' .. self.desc)
    end
    return Step.running('NEED_COMBAT', self.desc)
end

return CombatStep
