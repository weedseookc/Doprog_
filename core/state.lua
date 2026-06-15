--- doprog.core.state
---
--- The public read facade — this is "doprog as state within other combat
--- systems". A host combat loop holds this object, calls `tick()` once per
--- frame, and reads the accessors to decide what to do. doprog drives travel,
--- targeting and safety; the host owns combat and simply asks:
---
---     if state:shouldEngage() then myCombat:assistOn(state:target()) end
---
--- Every accessor reflects the most recent tick's snapshot.

---@class doprog.State
---@field private _engine doprog.Engine
local State = {}
State.__index = State

---@param engine doprog.Engine
---@return doprog.State
function State.new(engine)
    return setmetatable({ _engine = engine }, State)
end

--- Advance the engine one frame and return the fresh snapshot.
---@return doprog.EngineState
function State:tick()
    return self._engine:tick()
end

--- The current directive without advancing.
---@return doprog.Directive
function State:directive()
    return self._engine:snapshot().directive
end

--- True when the host combat system should be engaging `target()`.
---@return boolean
function State:shouldEngage()
    return self._engine:snapshot().directive == 'NEED_COMBAT'
end

--- The spawn the host should kill (nil unless a kill is required this frame).
---@return doprog.SpawnQuery?
function State:target()
    return self._engine:snapshot().target
end

--- True while doprog is moving the party between objectives/zones.
---@return boolean
function State:isTraveling()
    return self._engine:snapshot().directive == 'TRAVEL'
end

--- True when nothing is gating us (not waiting/recovering).
---@return boolean
function State:isSafe()
    local d = self._engine:snapshot().directive
    return d ~= 'WAIT'
end

--- True when all configured progression is finished.
---@return boolean
function State:isComplete()
    return self._engine:snapshot().complete
end

--- Full snapshot for UI/diagnostics: { directive, zone, questName, stepDesc, ... }.
---@return doprog.EngineState
function State:current()
    return self._engine:snapshot()
end

return State
