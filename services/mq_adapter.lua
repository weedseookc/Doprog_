--- doprog.services.mq_adapter
---
--- The single seam between doprog and MacroQuest. Every TLO read and slash
--- command the framework issues goes through here. Nothing else in the codebase
--- touches the global `mq` table directly. That keeps the rest of the framework
--- testable: the composition root injects the real `mq`, while the test suite
--- injects `tests/mock_mq.lua`.
---
--- All TLO reads are wrapped in `pcall` and coerced to safe defaults. In-game
--- the chains always resolve, but defensive reads keep a half-loaded zone or a
--- mid-zone transition from throwing inside a hot loop.

---@class doprog.MqAdapter : doprog.IMqAdapter
---@field private _mq table          # the injected `mq` table
---@field private _log doprog.Logger
local MqAdapter = {}
MqAdapter.__index = MqAdapter

---@class doprog.MqAdapter.Deps
---@field mq table                   # real `mq` or a mock
---@field logger doprog.LoggerFactory

---@param deps doprog.MqAdapter.Deps
---@return doprog.MqAdapter
function MqAdapter.new(deps)
    assert(deps and deps.mq, 'MqAdapter requires deps.mq')
    assert(deps.logger, 'MqAdapter requires deps.logger')
    return setmetatable({
        _mq = deps.mq,
        _log = deps.logger:forModule('Mq'),
    }, MqAdapter)
end

-------------------------------------------------------------------------------
-- Internal helpers
-------------------------------------------------------------------------------

--- Safely evaluate a TLO accessor `fn`, returning `default` on any error/nil.
---@generic T
---@param fn fun(): T
---@param default T
---@return T
local function safe(fn, default)
    local ok, value = pcall(fn)
    if not ok or value == nil then return default end
    return value
end

--- Build an MQ2Nav destination argument from a Vec3 or SpawnQuery.
---@private
---@param dest doprog.Vec3|doprog.SpawnQuery
---@return string
function MqAdapter:_navArg(dest)
    if dest.id then return ('id %d'):format(dest.id) end
    if dest.x and dest.y then
        if dest.z then
            -- locxyz takes X Y Z order (distinct from EQ /loc which is Y X).
            return ('locxyz %.2f %.2f %.2f'):format(dest.x, dest.y, dest.z)
        end
        -- No Z (e.g. from a player /loc): 2D nav; the mesh resolves Z. /nav loc
        -- takes EQ Y X order.
        return ('loc %.2f %.2f'):format(dest.y, dest.x)
    end
    if dest.name then
        local id = self:findSpawn(dest)
        if id then return ('id %d'):format(id) end
        return ('spawn %s'):format(dest.name)
    end
    error('navArg: destination has neither id, coords, nor name')
end

--- Build a spawn search string from a SpawnQuery.
---@private
---@param q doprog.SpawnQuery
---@return string
function MqAdapter:_spawnSearch(q)
    local parts = {}
    if q.npc then parts[#parts + 1] = 'npc' end
    if q.body then parts[#parts + 1] = ('body "%s"'):format(q.body) end
    if q.radius then parts[#parts + 1] = ('radius %d'):format(q.radius) end
    if q.name then parts[#parts + 1] = q.name end
    return table.concat(parts, ' ')
end

-------------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------------

---@param command string
function MqAdapter:cmd(command)
    self._log:Trace('cmd: %s', command)
    self._mq.cmd(command)
end

---@param fmt string
function MqAdapter:cmdf(fmt, ...)
    self._log:Trace('cmdf: ' .. fmt, ...)
    self._mq.cmdf(fmt, ...)
end

---@param ms integer|string
---@param condition? fun(): boolean
function MqAdapter:delay(ms, condition)
    if condition then self._mq.delay(ms, condition) else self._mq.delay(ms) end
end

-------------------------------------------------------------------------------
-- Character / world reads
-------------------------------------------------------------------------------

---@return string
function MqAdapter:zoneShortName()
    return safe(function() return self._mq.TLO.Zone.ShortName() end, '')
end

---@return boolean
function MqAdapter:inGame()
    return safe(function() return self._mq.TLO.EverQuest.GameState() end, 'CHARSELECT') == 'INGAME'
end

---@return string
function MqAdapter:myName()
    return safe(function() return self._mq.TLO.Me.CleanName() end, '')
end

---@return boolean
function MqAdapter:isMoving()
    return safe(function() return self._mq.TLO.Me.Moving() end, false)
end

---@return boolean
function MqAdapter:inCombat()
    return safe(function() return self._mq.TLO.Me.CombatState() end, 'ACTIVE') == 'COMBAT'
end

---@return number
function MqAdapter:pctHps()
    return safe(function() return self._mq.TLO.Me.PctHPs() end, 100)
end

---@return boolean
function MqAdapter:isDead()
    -- A dead character hovers over the corpse until rezzed or returned to bind.
    return safe(function() return self._mq.TLO.Me.Hovering() end, false)
end

---@return integer
function MqAdapter:xtargets()
    return safe(function() return self._mq.TLO.Me.XTarget() end, 0)
end

---@return doprog.Vec3
function MqAdapter:loc()
    return {
        y = safe(function() return self._mq.TLO.Me.Y() end, 0),
        x = safe(function() return self._mq.TLO.Me.X() end, 0),
        z = safe(function() return self._mq.TLO.Me.Z() end, 0),
        heading = safe(function() return self._mq.TLO.Me.Heading.Degrees() end, 0),
    }
end

---@param query doprog.SpawnQuery
---@return integer?
function MqAdapter:findSpawn(query)
    if query.id then return query.id end
    local search = self:_spawnSearch(query)
    local id = safe(function() return self._mq.TLO.Spawn(search).ID() end, 0)
    if id and id > 0 then return id end
    return nil
end

---@param name string
---@param excludes string[]
---@return boolean
local function isExcluded(name, excludes)
    local lower = name:lower()
    for _, bad in ipairs(excludes) do
        if lower:find(bad:lower(), 1, true) then return true end
    end
    return false
end

--- Find the nearest spawn matching `query`, skipping any whose name contains an
--- `exclude` substring. This is how doprog targets the *right* mob for a quest
--- (e.g. "deep in the zone, but not mephits or air elementals") instead of
--- leaving the combat tool to guess. Returns id and name, or nil.
---@param query doprog.SpawnQuery
---@return integer?, string?
function MqAdapter:findSpawnFiltered(query)
    if query.id then return query.id, query.name end
    if not query.exclude or #query.exclude == 0 then
        local id = self:findSpawn(query)
        if id then
            local nm = safe(function() return self._mq.TLO.Spawn(id).Name() end, query.name)
            return id, nm
        end
        return nil
    end
    local search = self:_spawnSearch(query)
    local scan = query.scan or 25
    for i = 1, scan do
        local spawn = self._mq.TLO.NearestSpawn(i, search)
        local id = safe(function() return spawn.ID() end, 0)
        if not id or id <= 0 then break end
        local nm = safe(function() return spawn.Name() end, '')
        if nm ~= '' and not isExcluded(nm, query.exclude) then
            return id, nm
        end
    end
    return nil
end

--- Distance (3D) from the player to a spawn id, or a large number if unknown.
---@param id integer
---@return number
function MqAdapter:spawnDistance(id)
    return safe(function() return self._mq.TLO.Spawn(id).Distance3D() end, 1e9)
end

--- Model height of a spawn (used to rank mob "size" for clue puzzles), 0 if unknown.
---@param id integer
---@return number
function MqAdapter:spawnHeight(id)
    return safe(function() return self._mq.TLO.Spawn(id).Height() end, 0)
end

--- Number of spawns matching a search string (e.g. counting portals per element).
---@param search string
---@return integer
function MqAdapter:spawnCount(search)
    return safe(function() return self._mq.TLO.SpawnCount(search)() end, 0)
end

--- Target a spawn by id.
---@param id integer
function MqAdapter:target(id)
    self:cmdf('/target id %d', id)
end

---@return integer
function MqAdapter:targetId()
    return safe(function() return self._mq.TLO.Target.ID() end, 0)
end

-------------------------------------------------------------------------------
-- Navigation
-------------------------------------------------------------------------------

---@return boolean
function MqAdapter:navActive()
    return safe(function() return self._mq.TLO.Navigation.Active() end, false)
end

---@param dest doprog.Vec3|doprog.SpawnQuery
---@return boolean
function MqAdapter:navPathExists(dest)
    local arg = self:_navArg(dest)
    return safe(function() return self._mq.TLO.Navigation.PathExists(arg)() end, false)
end

--- Issue `/nav` toward a destination. Separate from PathExists so callers can
--- gate movement on reachability first.
---@param dest doprog.Vec3|doprog.SpawnQuery
function MqAdapter:navTo(dest)
    self:cmdf('/nav %s', self:_navArg(dest))
end

-------------------------------------------------------------------------------
-- Tasks / plugins
-------------------------------------------------------------------------------

---@param taskName string
---@return boolean
function MqAdapter:taskExists(taskName)
    local id = safe(function() return self._mq.TLO.Task(taskName).ID() end, 0)
    return id and id > 0 or false
end

--- Raw status string for objective `index` of `taskName` ("Done", "Open", ...).
---@param taskName string
---@param index integer
---@return string?
function MqAdapter:taskObjectiveStatus(taskName, index)
    return safe(function() return self._mq.TLO.Task(taskName).Objective(index).Status() end, nil)
end

---@param pluginName string
---@return boolean
function MqAdapter:pluginLoaded(pluginName)
    return safe(function() return self._mq.TLO.Plugin(pluginName).IsLoaded() end, false)
end

--- How many of `itemName` the character is carrying (inventory + bank-excluded).
---@param itemName string
---@return integer
function MqAdapter:itemCount(itemName)
    return safe(function() return self._mq.TLO.FindItemCount('=' .. itemName)() end, 0)
end

--- 3D world location of a spawn id (for flee-vector math), zeros if unknown.
---@param id integer
---@return doprog.Vec3
function MqAdapter:spawnLoc(id)
    return {
        y = safe(function() return self._mq.TLO.Spawn(id).Y() end, 0),
        x = safe(function() return self._mq.TLO.Spawn(id).X() end, 0),
        z = safe(function() return self._mq.TLO.Spawn(id).Z() end, 0),
    }
end

--- Register an MQ text event (emote watcher). No-op if the binding is absent.
---@param name string
---@param pattern string
---@param callback fun(line: string, ...: any)
function MqAdapter:registerEvent(name, pattern, callback)
    if self._mq.event then self._mq.event(name, pattern, callback) end
end

--- Process queued events/emotes.
function MqAdapter:doEvents()
    if self._mq.doevents then self._mq.doevents() end
end

return MqAdapter
