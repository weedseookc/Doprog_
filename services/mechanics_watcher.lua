--- doprog.services.mechanics_watcher
---
--- Watches MQ emote/text events so doprog can react to fight mechanics with
--- POSITIONING (the part of combat that is movement, which is doprog's job — not
--- damage, which stays with the host). A CombatStep arms the emote substrings it
--- cares about; this service registers one MQ event per substring and timestamps
--- the last time each fired. `firedWithin` lets the step decide whether a
--- reaction (flee/move/hide) is currently active.

---@class doprog.MechanicsWatcher : doprog.IMechanicsWatcher
---@field private _mq doprog.MqAdapter
---@field private _log doprog.Logger
---@field private _seen table<string, number>   # emote substring -> os.clock() last seen
---@field private _armed table<string, boolean>
---@field private _count integer
local MechanicsWatcher = {}
MechanicsWatcher.__index = MechanicsWatcher

---@class doprog.MechanicsWatcher.Deps
---@field mq doprog.MqAdapter
---@field logger doprog.LoggerFactory

---@param deps doprog.MechanicsWatcher.Deps
---@return doprog.MechanicsWatcher
function MechanicsWatcher.new(deps)
    assert(deps and deps.mq, 'MechanicsWatcher requires deps.mq')
    return setmetatable({
        _mq = deps.mq,
        _log = deps.logger:forModule('Mechanics'),
        _seen = {},
        _armed = {},
        _count = 0,
    }, MechanicsWatcher)
end

--- Register an MQ event for `emoteSubstring` (idempotent). The pattern wraps the
--- substring in `#*#` wildcards so it matches anywhere on the emote line.
---@param emoteSubstring string
function MechanicsWatcher:arm(emoteSubstring)
    if self._armed[emoteSubstring] then return end
    self._armed[emoteSubstring] = true
    self._count = self._count + 1
    local seen = self._seen
    self._log:Debug('arming emote: %s', emoteSubstring)
    self._mq:registerEvent('doprog_mech_' .. self._count, ('#*#%s#*#'):format(emoteSubstring),
        function() seen[emoteSubstring] = os.clock() end)
end

--- True if `emoteSubstring` fired within the last `seconds`.
---@param emoteSubstring string
---@param seconds number
---@return boolean
function MechanicsWatcher:firedWithin(emoteSubstring, seconds)
    local t = self._seen[emoteSubstring]
    return t ~= nil and (os.clock() - t) <= seconds
end

--- Process the event queue (called once per engine tick).
function MechanicsWatcher:poll()
    self._mq:doEvents()
end

return MechanicsWatcher
