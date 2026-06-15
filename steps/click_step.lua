--- doprog.steps.click_step
---
--- Interact with the world: click a clicky object, zone-in portal, or run any
--- raw slash command at a location (e.g. `/click left item`, `/say enter`).
--- Optionally navigates to a point/NPC first. Completion is either a configured
--- predicate or, by default, a zone change (the common "click to zone in" case).

local Step = require('doprog.steps.step')

---@class doprog.ClickStep : doprog.Step
---@field private _action string
---@field private _npc doprog.SpawnQuery?
---@field private _loc doprog.Vec3?
---@field private _condition (fun(ctx: doprog.StepContext): boolean)?
---@field private _zoneBefore string?
---@field private _clickedAt number
local ClickStep = Step.extend({})
ClickStep.__index = ClickStep

---@param opts doprog.Step.Opts # requires .action; optional .loc/.npc/.condition
---@return doprog.ClickStep
function ClickStep.new(opts)
    assert(opts and opts.action, 'ClickStep requires opts.action')
    local self = Step.new('click', opts) ---@cast self doprog.ClickStep
    self._action = opts.action
    self._npc = opts.npc
    self._loc = opts.loc
    self._condition = opts.condition
    self._zoneBefore = nil
    self._clickedAt = 0
    return setmetatable(self, ClickStep)
end

---@param ctx doprog.StepContext
---@return boolean
function ClickStep:isComplete(ctx)
    if self._condition then return self._condition(ctx) end
    if self._zoneBefore == nil then return false end
    -- Default completion: the zone changed after we clicked.
    return ctx.mq:zoneShortName() ~= self._zoneBefore and self._clickedAt > 0
end

---@param ctx doprog.StepContext
---@return doprog.StepResult
function ClickStep:execute(ctx)
    local zr = self:ensureZone(ctx)
    if zr then return zr end

    if self:isComplete(ctx) then
        return Step.done('TRAVEL')
    end

    local dest = self._npc or self._loc
    if dest and not ctx.nav:to(dest) then
        return Step.running('TRAVEL', 'to clicky for ' .. self.desc)
    end

    if os.clock() - self._clickedAt > 3 then
        self._zoneBefore = ctx.mq:zoneShortName()
        ctx.log:Info('clicking: %s', self.desc)
        ctx.mq:cmd(self._action)
        self._clickedAt = os.clock()
    end
    return Step.running('TRAVEL', self.desc)
end

return ClickStep
