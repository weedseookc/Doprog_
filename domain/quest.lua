--- doprog.domain.quest
---
--- A quest is an ordered list of Steps plus prerequisite gating and a notion of
--- "done". The engine drives the active quest by calling `tick(ctx)` each frame;
--- the quest walks its steps, skipping ones already satisfied in-game (so a
--- partially-finished task picked up mid-progression resumes correctly).

local Step = require('doprog.steps.step')

---@class doprog.Quest
---@field name string
---@field type doprog.QuestType
---@field zone string
---@field steps doprog.Step[]
---@field prereq doprog.Prereq?
---@field protected _index integer
---@field protected _doneWhen (fun(ctx: doprog.StepContext): boolean)?
---@field protected _completionTask string?
local Quest = {}
Quest.__index = Quest

---@param opts doprog.Quest.Opts
---@return doprog.Quest
function Quest.new(opts)
    assert(opts and opts.name and opts.steps, 'Quest requires name and steps')
    return setmetatable({
        name = opts.name,
        type = opts.type or 'task',
        zone = opts.zone,
        steps = opts.steps,
        prereq = opts.prereq,
        _index = 1,
        _doneWhen = opts.doneWhen,
        _completionTask = opts.completionTask,
    }, Quest)
end

--- For subclasses (Mission) to inherit from Quest.
---@param sub table
---@return table
function Quest.extend(sub)
    return setmetatable(sub, { __index = Quest })
end

--- Whether prerequisites are met and the quest may begin.
---@param ctx doprog.StepContext
---@return boolean
function Quest:canStart(ctx)
    if not self.prereq then return true end
    for _, task in ipairs(self.prereq.tasks or {}) do
        if not ctx.task:isComplete(task) then return false end
    end
    if self.prereq.fn and not self.prereq.fn(ctx) then return false end
    return true
end

--- Whether the whole quest is finished.
---@param ctx doprog.StepContext
---@return boolean
function Quest:isComplete(ctx)
    if self._completionTask and ctx.task:isComplete(self._completionTask) then
        return true
    end
    if self._doneWhen and self._doneWhen(ctx) then
        return true
    end
    return self._index > #self.steps
end

--- Reset progress so the quest can be replayed/re-evaluated from the top.
function Quest:reset()
    self._index = 1
end

--- Index of the step currently being worked (clamped), for UI/logging.
---@return integer
function Quest:currentStepIndex()
    return math.min(self._index, #self.steps)
end

--- Fast-forward over already-satisfied leading steps and return the step that
--- is currently active (or nil if the quest is complete). Pure observation: it
--- never executes a step, so the engine can safely peek the step kind before
--- deciding whether it is safe to act this tick.
---@param ctx doprog.StepContext
---@return doprog.Step?
function Quest:activeStep(ctx)
    while self._index <= #self.steps and self.steps[self._index]:isComplete(ctx) do
        self._index = self._index + 1
    end
    return self.steps[self._index]
end

--- Advance one tick. Executes the active step, advancing the cursor when a step
--- reports done.
---@param ctx doprog.StepContext
---@return doprog.StepResult
function Quest:tick(ctx)
    local step = self:activeStep(ctx)
    if not step then
        return Step.done('IDLE')
    end

    local result = step:execute(ctx)
    if result.status == 'done' then
        self._index = self._index + 1
    elseif result.status == 'failed' then
        -- Surface failure but stay put; the engine decides whether to halt/retry.
        ctx.log:Error('quest "%s" step "%s" failed: %s', self.name, step.desc, result.reason or '?')
    end
    return result
end

return Quest
