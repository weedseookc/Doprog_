--- doprog.zones.plane_of_smoke.trials.portal_solver
---
--- Solves the Trial of the Wending Ways kill order. Per eqresource: "the elemental
--- type with the MOST portals visible determines which boss to fight first;
--- recount the portals after each defeat." doprog counts portals per element each
--- frame and targets the boss of the highest-count living element.
---
--- Portal spawn names are not published, so `portalSearch` is configurable per
--- element (default "<element> portal"); calibrate in-game if needed. If portals
--- can't be counted and more than one boss is alive, the solver returns `false`
--- (wait) rather than risk a wrong order; with one boss left it just returns it.

---@class doprog.PortalBoss
---@field name string
---@field element string
---@field portalSearch? string   # spawn search counting that element's portals

---@class doprog.PortalSolver
---@field private _bosses doprog.PortalBoss[]
local PortalSolver = {}
PortalSolver.__index = PortalSolver

---@param bosses doprog.PortalBoss[]
---@return doprog.PortalSolver
function PortalSolver.new(bosses)
    return setmetatable({ _bosses = bosses }, PortalSolver)
end

--- Next boss to fight (SpawnQuery), `false` while the order is ambiguous, or nil
--- when all bosses are dead.
---@param ctx doprog.StepContext
---@return doprog.SpawnQuery|false|nil
function PortalSolver:nextTarget(ctx)
    local living = {}
    for _, b in ipairs(self._bosses) do
        if ctx.mq:findSpawn({ name = b.name, npc = true }) ~= nil then
            living[#living + 1] = b
        end
    end
    if #living == 0 then return nil end
    if #living == 1 then return { name = living[1].name, npc = true } end

    local best, bestCount
    for _, b in ipairs(living) do
        local count = ctx.mq:spawnCount(b.portalSearch or (b.element .. ' portal'))
        if not bestCount or count > bestCount then best, bestCount = b, count end
    end
    if not best or bestCount == 0 then
        -- Portals not readable and several bosses up: don't guess the order.
        return false
    end
    return { name = best.name, npc = true }
end

return PortalSolver
