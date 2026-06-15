--- doprog.steps.loot_step
---
--- Acquire a required drop. doprog advertises directive == "LOOT" and issues a
--- best-effort loot of nearby corpses; most crews already run an autoloot tool,
--- so this is intentionally light. Completion is by inventory count of `item`.

local Step = require('doprog.steps.step')

---@class doprog.LootStep : doprog.Step
---@field private _item string
---@field private _count integer
local LootStep = Step.extend({})
LootStep.__index = LootStep

---@param opts doprog.Step.Opts # requires .item
---@return doprog.LootStep
function LootStep.new(opts)
    assert(opts and opts.item, 'LootStep requires opts.item')
    local self = Step.new('loot', opts) ---@cast self doprog.LootStep
    self._item = opts.item
    self._count = opts.count or 1
    return setmetatable(self, LootStep)
end

---@param ctx doprog.StepContext
---@return boolean
function LootStep:isComplete(ctx)
    return ctx.mq:itemCount(self._item) >= self._count
end

---@param ctx doprog.StepContext
---@return doprog.StepResult
function LootStep:execute(ctx)
    local zr = self:ensureZone(ctx)
    if zr then return zr end

    if self:isComplete(ctx) then
        return Step.done('LOOT')
    end
    -- Best-effort: loot the nearest corpse. Crews with autoloot will satisfy the
    -- count passively; we just keep advertising LOOT so combat stays paused.
    ctx.mq:cmd('/loot')
    ctx.mq:delay(500)
    return Step.running('LOOT', ('need %dx %s'):format(self._count, self._item))
end

return LootStep
