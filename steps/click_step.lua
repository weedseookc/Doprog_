--- doprog.steps.click_step
---
--- Interact with the world: click a clicky object, zone-in portal, say a phrase
--- to a porter NPC, or run any raw slash command at a location (e.g.
--- `/click left item`, `/say karana`). Optionally navigates to a point/NPC first.
--- Completion is, in priority order: a configured predicate; else if
--- `completeAfter` is set, that many ms after firing (porter teleports within the
--- same zone, where no zone change is observable); else a zone change (the common
--- "click to zone in" case).

local Step = require('doprog.steps.step')

---@class doprog.ClickStep : doprog.Step
---@field private _action string
---@field private _npc doprog.SpawnQuery?
---@field private _loc doprog.Vec3?
---@field private _condition (fun(ctx: doprog.StepContext): boolean)?
---@field private _completeAfter number?
---@field private _zoneBefore string?
---@field private _clickedAt number
local ClickStep = Step.extend({})
ClickStep.__index = ClickStep

---@param opts doprog.Step.Opts # requires .action; optional .loc/.npc/.condition/.completeAfter
---@return doprog.ClickStep
function ClickStep.new(opts)
    assert(opts and opts.action, 'ClickStep requires opts.action')
    local self = Step.new('click', opts) ---@cast self doprog.ClickStep
    self._action = opts.action
    self._npc = opts.npc
    self._loc = opts.loc
    self._condition = opts.condition
    self._completeAfter = opts.completeAfter and (opts.completeAfter / 1000) or nil
    self._zoneBefore = nil
    self._clickedAt = -math.huge -- so the first click fires immediately
    return setmetatable(self, ClickStep)
end

---@param ctx doprog.StepContext
---@return boolean
function ClickStep:isComplete(ctx)
    if self._condition then return self._condition(ctx) end
    if self._clickedAt == -math.huge then return false end -- not clicked yet
    if self._completeAfter then
        return (os.clock() - self._clickedAt) >= self._completeAfter
    end
    if self._zoneBefore == nil then return false end
    -- Default completion: the zone changed after we clicked.
    return ctx.mq:zoneShortName() ~= self._zoneBefore
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
        -- Target the NPC first: EQ dialogue (/say keywords, hails) only registers
        -- against a targeted NPC in range, so this is what makes say-to-NPC,
        -- porter, and turn-in-style click steps actually fire.
        if self._npc then
            local id = ctx.mq:findSpawn(self._npc)
            if id then ctx.mq:target(id) end
        end
        ctx.log:Info('clicking: %s', self.desc)
        ctx.mq:cmd(self._action)
        self._clickedAt = os.clock()
    end
    return Step.running('TRAVEL', self.desc)
end

return ClickStep
