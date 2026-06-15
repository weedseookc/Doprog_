--- doprog.steps.travel_step
---
--- Move the party to a location. Routes across zones if needed (via ensureZone),
--- then navs to the point. Pure movement — never engages.

local Step = require('doprog.steps.step')

---@class doprog.TravelStep : doprog.Step
---@field private _loc doprog.Vec3
local TravelStep = Step.extend({})
TravelStep.__index = TravelStep

---@param opts doprog.Step.Opts # requires .loc and .zone
---@return doprog.TravelStep
function TravelStep.new(opts)
    assert(opts and opts.loc, 'TravelStep requires opts.loc')
    local self = Step.new('travel', opts) ---@cast self doprog.TravelStep
    self._loc = opts.loc
    return setmetatable(self, TravelStep)
end

---@param ctx doprog.StepContext
---@return doprog.StepResult
function TravelStep:execute(ctx)
    local zr = self:ensureZone(ctx)
    if zr then return zr end
    if ctx.nav:to(self._loc) then
        return Step.done('TRAVEL')
    end
    return Step.running('TRAVEL', self.desc)
end

---@param ctx doprog.StepContext
---@return boolean
function TravelStep:isComplete(ctx)
    -- Cheap pre-check used to skip; precise arrival is decided in execute.
    return self.zone ~= nil and ctx.mq:zoneShortName() == self.zone and not ctx.mq:isMoving()
        and ctx.nav:to(self._loc)
end

return TravelStep
