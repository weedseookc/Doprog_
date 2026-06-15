--- doprog.steps.handin_step
---
--- Complete an objective at an NPC: navigate, target, and (if items are given)
--- trade the required items, then confirm. Completion is read from task state
--- where a task is wired, otherwise from a single successful hand-in.

local Step = require('doprog.steps.step')

---@class doprog.HandinStep : doprog.Step
---@field private _npc doprog.SpawnQuery
---@field private _items string[]
---@field private _taskName string?
---@field private _objective integer?
---@field private _handedAt number
local HandinStep = Step.extend({})
HandinStep.__index = HandinStep

---@param opts doprog.Step.Opts|{ items?: string[] } # requires .npc
---@return doprog.HandinStep
function HandinStep.new(opts)
    assert(opts and opts.npc, 'HandinStep requires opts.npc')
    local self = Step.new('handin', opts) ---@cast self doprog.HandinStep
    self._npc = opts.npc
    self._items = opts.items or {}
    self._taskName = opts.taskName
    self._objective = opts.objective
    self._handedAt = -math.huge -- so the first hand-in attempt fires immediately
    return setmetatable(self, HandinStep)
end

---@param ctx doprog.StepContext
---@return boolean
function HandinStep:isComplete(ctx)
    if self._taskName and self._objective then
        return ctx.task:objectiveDone(self._taskName, self._objective)
    end
    if self._taskName then
        return ctx.task:isComplete(self._taskName)
    end
    -- No task wiring: consider done a moment after we executed the hand-in.
    return self._handedAt > 0 and (os.clock() - self._handedAt) > 2
end

---@private
---@param ctx doprog.StepContext
function HandinStep:_handIn(ctx)
    ctx.mq:cmd('/target id ' .. tostring(ctx.mq:findSpawn(self._npc) or 0))
    ctx.mq:delay(300)
    if #self._items > 0 then
        for _, item in ipairs(self._items) do
            ctx.mq:cmdf('/itemnotify "%s" leftmouseup', item)
            ctx.mq:delay(200)
            ctx.mq:cmd('/click left target')
            ctx.mq:delay(200)
        end
        ctx.mq:cmd('/notify GiveWnd GVW_Give_Button leftmouseup')
    else
        ctx.mq:cmd('/say Hail')
    end
    self._handedAt = os.clock()
end

---@param ctx doprog.StepContext
---@return doprog.StepResult
function HandinStep:execute(ctx)
    local zr = self:ensureZone(ctx)
    if zr then return zr end

    if self:isComplete(ctx) then
        return Step.done('TURN_IN')
    end

    ctx.eqbc:holdCrew()
    if not ctx.nav:to(self._npc) then
        return Step.running('TRAVEL', 'to hand-in for ' .. self.desc)
    end

    if os.clock() - self._handedAt > 3 then
        ctx.log:Info('handing in: %s', self.desc)
        self:_handIn(ctx)
    end
    return Step.running('TURN_IN', self.desc)
end

return HandinStep
