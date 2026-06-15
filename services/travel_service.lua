--- doprog.services.travel_service
---
--- Inter-zone routing. Given a target zone, it finds a path through the zone
--- connection graph (BFS over `data/zones.lua`), then executes one hop at a
--- time: nav to the connection point (or run the portal action), wait for the
--- zone to actually change, and advance. In-zone walking is delegated to
--- NavService so all the stuck-recovery logic lives in one place.

local ZoneGraph = require('doprog.data.zones')

---@class doprog.TravelService.Hop
---@field from string
---@field to string
---@field edge doprog.ZoneEdge

---@class doprog.TravelService : doprog.ITravelService
---@field private _mq doprog.MqAdapter
---@field private _nav doprog.NavService
---@field private _log doprog.Logger
---@field private _graph doprog.ZoneGraph
---@field private _path doprog.TravelService.Hop[]?
---@field private _hopIndex integer
---@field private _zonedAt number
local TravelService = {}
TravelService.__index = TravelService

---@class doprog.TravelService.Deps
---@field mq doprog.MqAdapter
---@field nav doprog.NavService
---@field logger doprog.LoggerFactory
---@field graph? doprog.ZoneGraph   # defaults to the bundled TBL graph

---@param deps doprog.TravelService.Deps
---@return doprog.TravelService
function TravelService.new(deps)
    assert(deps and deps.mq and deps.nav, 'TravelService requires deps.mq and deps.nav')
    return setmetatable({
        _mq = deps.mq,
        _nav = deps.nav,
        _log = deps.logger:forModule('Travel'),
        _graph = deps.graph or ZoneGraph,
        _path = nil,
        _hopIndex = 1,
        _zonedAt = 0,
    }, TravelService)
end

function TravelService:reset()
    self._path = nil
    self._hopIndex = 1
    self._nav:reset()
end

--- Breadth-first search for a hop sequence from `from` to `to`.
---@private
---@param from string
---@param to string
---@return doprog.TravelService.Hop[]?
function TravelService:_findPath(from, to)
    if from == to then return {} end
    local queue = { from }
    local cameFrom = { [from] = false } ---@type table<string, doprog.TravelService.Hop|false>
    while #queue > 0 do
        local current = table.remove(queue, 1)
        local edges = self._graph.edges[current] or {}
        for _, edge in ipairs(edges) do
            if cameFrom[edge.to] == nil then
                cameFrom[edge.to] = { from = current, to = edge.to, edge = edge }
                if edge.to == to then
                    -- Reconstruct.
                    local hops = {} ---@type doprog.TravelService.Hop[]
                    local step = cameFrom[edge.to]
                    while step do
                        table.insert(hops, 1, step)
                        step = cameFrom[step.from]
                    end
                    return hops
                end
                queue[#queue + 1] = edge.to
            end
        end
    end
    return nil
end

--- Execute a single hop. Returns true once the zone has changed to `hop.to`.
---@private
---@param hop doprog.TravelService.Hop
---@return boolean
function TravelService:_runHop(hop)
    if self._mq:zoneShortName() == hop.to then
        return true
    end

    local edge = hop.edge
    if edge.kind == 'portal' and edge.action then
        -- Portals: walk to the clicky/NPC if a loc is given, then run the action.
        if edge.loc and not self._nav:to(edge.loc) then
            return false
        end
        self._log:Info('portal hop %s -> %s: %s', hop.from, hop.to, edge.action)
        self._mq:cmd(edge.action)
        self._mq:delay('3s', function() return self._mq:zoneShortName() == hop.to end)
        return self._mq:zoneShortName() == hop.to
    end

    -- Zone line: nav to the line; zoning happens automatically on contact.
    if edge.loc and not self._nav:to(edge.loc) then
        return false
    end
    self._log:Debug('at zone line %s -> %s, waiting for zone', hop.from, hop.to)
    return self._mq:zoneShortName() == hop.to
end

---@param targetZone string
---@return boolean
function TravelService:toZone(targetZone)
    local here = self._mq:zoneShortName()
    if here == targetZone then
        if self._path then self:reset() end
        return true
    end

    if not self._path then
        local path = self:_findPath(here, targetZone)
        if not path then
            self._log:Error('no route from %s to %s', here, targetZone)
            return false
        end
        self._path = path
        self._hopIndex = 1
        self._log:Info('routing %s -> %s in %d hop(s)', here, targetZone, #path)
    end

    local hop = self._path[self._hopIndex]
    if not hop then
        self:reset()
        return self._mq:zoneShortName() == targetZone
    end

    -- If we have already arrived at this hop's destination zone, advance.
    if self._mq:zoneShortName() == hop.to then
        self._nav:reset()
        self._hopIndex = self._hopIndex + 1
        return self:toZone(targetZone)
    end

    self:_runHop(hop)
    return false
end

return TravelService
