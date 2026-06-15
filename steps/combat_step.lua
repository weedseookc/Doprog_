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
---
--- POSITIONING: pass `mechanics` (doprog.Mechanic[]) and doprog will, while the
--- fight is handed off, react to emotes by moving the lead — fleeing an AE/boulder
--- (computed escape vector from the live spawn), breaking line-of-sight on a gaze,
--- or dragging the mob to a brazier/aura spot. Damage stays the host's job; the
--- movement is doprog's.

local Step = require('doprog.steps.step')

local ENGAGE_RANGE = 50 -- units; within this we hand off, beyond it we close in
local DEFAULT_EMOTE_WINDOW = 8 -- seconds an emote stays "active"
local DEFAULT_FLEE = 40 -- units

---@class doprog.CombatStep : doprog.Step
---@field private _target doprog.SpawnQuery|(fun(ctx: doprog.StepContext): doprog.SpawnQuery?)|nil
---@field private _taskName string?
---@field private _objective integer?
---@field private _camp doprog.Vec3?
---@field private _engageRange number
---@field private _untilItem string?
---@field private _untilCount integer
---@field private _mechanics doprog.Mechanic[]?
local CombatStep = Step.extend({})
CombatStep.__index = CombatStep

---@param opts doprog.Step.Opts # needs `target` OR (`taskName` [+ `objective`]) OR `untilItem`
---@return doprog.CombatStep
function CombatStep.new(opts)
    assert(opts and (opts.target or opts.taskName or opts.untilItem),
        'CombatStep requires a target spawn, a taskName, or untilItem to track completion')
    local self = Step.new('combat', opts) ---@cast self doprog.CombatStep
    self._target = opts.target
    self._taskName = opts.taskName
    self._objective = opts.objective
    self._camp = opts.loc
    self._engageRange = opts.engageRange or ENGAGE_RANGE
    self._untilItem = opts.untilItem
    self._untilCount = opts.untilCount or 1
    self._mechanics = opts.mechanics
    return setmetatable(self, CombatStep)
end

---@param ctx doprog.StepContext
---@return boolean
function CombatStep:isComplete(ctx)
    -- Farming completion: kill until we hold enough of an item (gathering tasks).
    if self._untilItem then
        return ctx.mq:itemCount(self._untilItem) >= self._untilCount
    end
    if self._taskName and self._objective then
        return ctx.task:objectiveDone(self._taskName, self._objective)
    end
    if self._taskName then
        return ctx.task:isComplete(self._taskName)
    end
    -- Targeted (static or dynamic resolver): done when nothing is left to kill.
    -- A dynamic resolver may return `false` to mean "not solved yet, keep
    -- waiting" (distinct from nil = nothing left, which is complete).
    if self._target then
        local q = self:_resolveTarget(ctx)
        if q == false then return false end
        return q == nil or ctx.mq:findSpawn(q) == nil
    end
    return false
end

--- Resolve the target query for this frame (supports a dynamic resolver function
--- so a step can pick "the next boss in solved kill order").
---@private
---@param ctx doprog.StepContext
---@return doprog.SpawnQuery?
function CombatStep:_resolveTarget(ctx)
    local t = self._target
    if type(t) == 'function' then return t(ctx) end
    return t
end

--- Execute positioning mechanics for this frame. Damage is the host's; movement
--- is ours. Returns true if doprog issued a reposition (so callers know the lead
--- is moving on purpose this tick).
---@private
---@param ctx doprog.StepContext
---@return boolean
function CombatStep:_handleMechanics(ctx)
    if not self._mechanics then return false end
    -- Arm emote watchers once.
    for _, m in ipairs(self._mechanics) do
        if m.emote then ctx.mech:arm(m.emote) end
    end
    local acted = false
    for _, m in ipairs(self._mechanics) do
        local active = (not m.emote) or ctx.mech:firedWithin(m.emote, m.window or DEFAULT_EMOTE_WINDOW)
        if active and self:_reposition(ctx, m) then
            acted = true
        end
    end
    return acted
end

--- Perform a single mechanic's movement. `flee` works immediately (escape vector
--- from the live spawn); loc-based reactions need the loc calibrated in-game.
---@private
---@param ctx doprog.StepContext
---@param m doprog.Mechanic
---@return boolean
function CombatStep:_reposition(ctx, m)
    if m.react == 'flee' then
        local id = m.spawn and ctx.mq:findSpawn(m.spawn) or ctx.mq:targetId()
        if not id or id == 0 then return false end
        local here, there = ctx.mq:loc(), ctx.mq:spawnLoc(id)
        local dx, dy = here.x - there.x, here.y - there.y
        local len = math.sqrt(dx * dx + dy * dy)
        if len < 1 then dx, dy, len = 1, 0, 1 end
        local dist = m.distance or DEFAULT_FLEE
        ctx.log:Debug('mechanic flee: %s', m.desc)
        ctx.mq:navTo({ x = here.x + dx / len * dist, y = here.y + dy / len * dist })
        return true
    end
    -- moveTo / hide / aura / drag: nav the lead to the spot (mob follows for drag).
    if m.loc then
        ctx.log:Debug('mechanic %s: %s', m.react, m.desc)
        ctx.mq:navTo(m.loc)
        return true
    end
    return false
end

--- Drive a nameable target: select, close distance, target, hand off.
---@private
---@param ctx doprog.StepContext
---@return doprog.StepResult
function CombatStep:_driveTarget(ctx)
    local query = self:_resolveTarget(ctx)
    if query == false then
        -- Resolver is still working it out (e.g. clue order not solved yet).
        return Step.running('WAIT', 'solving the next target for ' .. self.desc)
    end
    if not query then
        return Step.done('TRAVEL')
    end
    local id, name = ctx.mq:findSpawnFiltered(query)
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

    -- In range: hand off. Positioning mechanics (flee/hide/drag) may move the
    -- lead this frame; otherwise stop nav so the host can fight in place.
    if not self:_handleMechanics(ctx) and ctx.nav:isActive() then
        ctx.nav:stop()
    end
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
    self:_handleMechanics(ctx)
    return Step.running('NEED_COMBAT', self.desc)
end

return CombatStep
