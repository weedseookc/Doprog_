--- doprog.services.nav_service
---
--- In-zone movement via MQ2Nav, with stuck detection and recovery. This is the
--- low-level "walk to a point in the current zone" primitive; inter-zone routing
--- is TravelService's job and is layered on top of this.
---
--- Contract: `to(dest)` is called every tick toward the same destination. It
--- returns `true` exactly once the player has arrived (nav no longer active and
--- we are within `arrivalRadius`). Until then it ensures nav is running, and if
--- the character stops making progress it nudges/re-paths.

---@class doprog.NavService : doprog.INavService
---@field private _mq doprog.MqAdapter
---@field private _log doprog.Logger
---@field private _arrivalRadius number
---@field private _stuckSeconds number
---@field private _lastLoc doprog.Vec3?
---@field private _lastProgressAt number
---@field private _unstickTries integer
local NavService = {}
NavService.__index = NavService

---@class doprog.NavService.Deps
---@field mq doprog.MqAdapter
---@field logger doprog.LoggerFactory
---@field arrivalRadius? number   # default 15 units
---@field stuckSeconds? number    # default 5s without progress => stuck

---@param deps doprog.NavService.Deps
---@return doprog.NavService
function NavService.new(deps)
    assert(deps and deps.mq, 'NavService requires deps.mq')
    return setmetatable({
        _mq = deps.mq,
        _log = deps.logger:forModule('Nav'),
        _arrivalRadius = deps.arrivalRadius or 15,
        _stuckSeconds = deps.stuckSeconds or 5,
        _lastLoc = nil,
        _lastProgressAt = os.clock(),
        _unstickTries = 0,
    }, NavService)
end

---@private
---@param a doprog.Vec3
---@param b doprog.Vec3
---@return number
local function dist3(a, b)
    local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

--- Reset stuck bookkeeping. Call when switching to a new destination.
function NavService:reset()
    self._lastLoc = nil
    self._lastProgressAt = os.clock()
    self._unstickTries = 0
end

---@return boolean
function NavService:isActive()
    return self._mq:navActive()
end

function NavService:stop()
    -- Issued unconditionally: /nav stop is harmless when not navigating and we
    -- want a guaranteed halt when a safety gate trips mid-path.
    self._mq:cmd('/nav stop')
end

--- Detect lack of forward progress and try to recover. Returns true if a
--- recovery action was taken this tick.
---@private
---@return boolean
function NavService:_handleStuck()
    local here = self._mq:loc()
    if self._lastLoc and dist3(here, self._lastLoc) > 2 then
        self._lastProgressAt = os.clock()
        self._unstickTries = 0
    end
    self._lastLoc = here

    if os.clock() - self._lastProgressAt < self._stuckSeconds then
        return false
    end

    self._unstickTries = self._unstickTries + 1
    self._log:Warn('stuck (try %d), re-pathing', self._unstickTries)
    self._mq:cmd('/nav stop')
    self._mq:delay(200)
    -- A short manual nudge breaks most geometry hangs before we re-issue nav.
    self._mq:cmd('/keypress back hold')
    self._mq:delay(300)
    self._mq:cmd('/keypress back')
    self._lastProgressAt = os.clock()
    return true
end

--- Walk toward `dest`. Returns true once arrived.
---@param dest doprog.Vec3|doprog.SpawnQuery
---@return boolean
function NavService:to(dest)
    -- Arrival check first: if nav has finished and we are close enough, done.
    if not self:isActive() then
        if dest.x and dest.y and dest.z then
            ---@cast dest doprog.Vec3
            if dist3(self._mq:loc(), dest) <= self._arrivalRadius then
                self._log:Debug('arrived at destination')
                self:reset()
                return true
            end
        else
            -- Spawn-query destinations: arrival is "nav stopped and target is near".
            ---@cast dest doprog.SpawnQuery
            local id = self._mq:findSpawn(dest)
            if id then
                self._log:Debug('arrived near spawn %d', id)
                self:reset()
                return true
            end
        end

        -- Not arrived and nav idle: (re)issue, but only if a path exists.
        if not self._mq:navPathExists(dest) then
            self._log:Warn('no nav path to destination; holding')
            return false
        end
        self._log:Info('issuing /nav to destination')
        self._mq:navTo(dest)
        self._lastProgressAt = os.clock()
        return false
    end

    self:_handleStuck()
    return false
end

return NavService
