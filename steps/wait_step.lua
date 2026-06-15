--- doprog.steps.wait_step
---
--- Block progression until a predicate is satisfied: a mission-request lockout
--- expiring, the crew finishing a zone-in, an event flag, etc. Advertises
--- directive == "WAIT" so the host system knows nothing should be engaged.

local Step = require('doprog.steps.step')

---@class doprog.WaitStep : doprog.Step
---@field private _condition fun(ctx: doprog.StepContext): boolean
local WaitStep = Step.extend({})
WaitStep.__index = WaitStep

---@param opts doprog.Step.Opts # requires .condition
---@return doprog.WaitStep
function WaitStep.new(opts)
    assert(opts and opts.condition, 'WaitStep requires opts.condition')
    local self = Step.new('wait', opts) ---@cast self doprog.WaitStep
    self._condition = opts.condition
    return setmetatable(self, WaitStep)
end

---@param ctx doprog.StepContext
---@return boolean
function WaitStep:isComplete(ctx)
    return self._condition(ctx)
end

---@param ctx doprog.StepContext
---@return doprog.StepResult
function WaitStep:execute(ctx)
    if self:isComplete(ctx) then
        return Step.done('WAIT')
    end
    return Step.running('WAIT', self.desc)
end

return WaitStep
