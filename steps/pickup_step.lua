--- doprog.steps.pickup_step
---
--- Acquire a task from a giver NPC. Navs to the giver, hails to open the offer,
--- and accepts the task window. Completion is observed from task state, not from
--- "we clicked" — so a missed accept simply retries next tick.
---
--- Note: task-offer UI handling varies slightly by server/build. The accept is
--- funnelled through one place (`_accept`) for easy tuning.

local Step = require('doprog.steps.step')

---@class doprog.PickupStep : doprog.Step
---@field private _npc doprog.SpawnQuery
---@field private _taskName string
---@field private _request string?
---@field private _hailedAt number
local PickupStep = Step.extend({})
PickupStep.__index = PickupStep

---@param opts doprog.Step.Opts # requires .npc and .taskName; .request = offer phrase
---@return doprog.PickupStep
function PickupStep.new(opts)
    assert(opts and opts.npc and opts.taskName, 'PickupStep requires opts.npc and opts.taskName')
    local self = Step.new('pickup', opts) ---@cast self doprog.PickupStep
    self._npc = opts.npc
    self._taskName = opts.taskName
    self._request = opts.request
    self._hailedAt = -math.huge -- so the first attempt fires immediately
    return setmetatable(self, PickupStep)
end

---@param ctx doprog.StepContext
---@return boolean
function PickupStep:isComplete(ctx)
    return ctx.task:has(self._taskName)
end

---@private
---@param ctx doprog.StepContext
function PickupStep:_accept(ctx)
    -- Target + hail to trigger dialogue, say the offer phrase (most TBL tasks are
    -- offered by saying a keyword), then accept the shared/solo task window.
    ctx.mq:cmd('/target id ' .. tostring(ctx.mq:findSpawn(self._npc) or 0))
    ctx.mq:delay(300)
    ctx.mq:cmd('/say Hail')
    ctx.mq:delay(500)
    if self._request then
        ctx.mq:cmdf('/say %s', self._request)
        ctx.mq:delay(500)
    end
    ctx.mq:cmd('/notify TaskSelectWnd TSEL_AcceptButton leftmouseup')
    self._hailedAt = os.clock()
end

---@param ctx doprog.StepContext
---@return doprog.StepResult
function PickupStep:execute(ctx)
    local zr = self:ensureZone(ctx)
    if zr then return zr end

    if self:isComplete(ctx) then
        return Step.done('PICKUP')
    end

    ctx.eqbc:holdCrew()
    if not ctx.nav:to(self._npc) then
        return Step.running('TRAVEL', 'to giver for ' .. self.desc)
    end

    -- Throttle hail attempts so we don't spam the offer window.
    if os.clock() - self._hailedAt > 3 then
        ctx.log:Info('requesting task: %s', self._taskName)
        self:_accept(ctx)
    end
    return Step.running('PICKUP', 'accepting ' .. self._taskName)
end

return PickupStep
