--- doprog.steps.step
---
--- Abstract base for all progression steps. A Step is a single unit of
--- "do/observe one thing" in a quest: walk somewhere, grab a task, hand in,
--- fight, loot, click, or wait. The engine calls `execute(ctx)` every tick and
--- reads the returned `StepResult` to drive the directive state machine, and
--- uses `isComplete(ctx)` to decide when to advance to the next step.
---
--- Subclasses override `execute`/`isComplete`. The base provides result helpers
--- and the shared "make sure we're in the right zone first" preamble via
--- `ensureZone`, which every concrete step uses.

---@class doprog.Step
---@field kind doprog.StepKind
---@field desc string
---@field zone string?
local Step = {}
Step.__index = Step

---@param kind doprog.StepKind
---@param opts doprog.Step.Opts
---@return doprog.Step
function Step.new(kind, opts)
    opts = opts or {}
    return setmetatable({
        kind = kind,
        desc = opts.desc or kind,
        zone = opts.zone,
    }, Step)
end

--- Helper so subclasses can inherit: `setmetatable(Sub, { __index = Step })`.
---@param sub table
---@return table
function Step.extend(sub)
    return setmetatable(sub, { __index = Step })
end

-------------------------------------------------------------------------------
-- Result constructors (keep StepResult shape consistent everywhere)
-------------------------------------------------------------------------------

---@param directive doprog.Directive
---@param reason? string
---@return doprog.StepResult
function Step.running(directive, reason)
    return { status = 'running', directive = directive, reason = reason }
end

---@param directive? doprog.Directive
---@return doprog.StepResult
function Step.done(directive)
    return { status = 'done', directive = directive or 'IDLE' }
end

---@param directive doprog.Directive
---@param reason? string
---@return doprog.StepResult
function Step.blocked(directive, reason)
    return { status = 'blocked', directive = directive, reason = reason }
end

---@param reason string
---@return doprog.StepResult
function Step.failed(reason)
    return { status = 'failed', directive = 'IDLE', reason = reason }
end

-------------------------------------------------------------------------------
-- Shared behaviour
-------------------------------------------------------------------------------

--- Ensure we are in this step's zone, routing there if not. Returns nil when in
--- zone (proceed), or a "TRAVEL" running result when still en route.
---@param ctx doprog.StepContext
---@return doprog.StepResult?
function Step:ensureZone(ctx)
    if not self.zone then return nil end
    if ctx.mq:zoneShortName() == self.zone then return nil end
    ctx.travel:toZone(self.zone)
    return Step.running('TRAVEL', 'traveling to ' .. self.zone)
end

-------------------------------------------------------------------------------
-- Abstract surface
-------------------------------------------------------------------------------

--- Advance this step one tick.
---@param _ctx doprog.StepContext
---@return doprog.StepResult
function Step:execute(_ctx)
    error('Step:execute is abstract (' .. self.kind .. ')')
end

--- Whether this step is satisfied (and the engine may advance).
---@param _ctx doprog.StepContext
---@return boolean
function Step:isComplete(_ctx)
    error('Step:isComplete is abstract (' .. self.kind .. ')')
end

return Step
