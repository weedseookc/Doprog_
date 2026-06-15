--- doprog.zones.plane_of_smoke.trials.clue_solver
---
--- Solves the Trial of Three kill-order puzzle from the clues the trial emotes at
--- the start. Per the eqresource walkthrough + comments:
---   * You get a clue for the FIRST mob to kill and a clue for the THIRD (last);
---     the SECOND has no clue and is found by elimination.
---   * Each clue identifies a mob by one attribute: SIZE (smallest/largest/
---     medium), POSITION in the room (foremost=nearest the door / rear=furthest /
---     mid), WEAPON (rapier / greatest / least), or ELEMENT ("in its element").
---
--- doprog captures the clue emote lines (in order), decodes each to (dimension,
--- value), and resolves it to one of the three named bosses using what MQ can
--- actually observe:
---   * SIZE     -> rank the three bosses by Spawn.Height().
---   * POSITION -> rank by distance from the entry (captured on first observe;
---                 you enter at the door, so nearest-to-entry == "foremost").
---   * ELEMENT  -> the boss name fixes the element, but the ROOM element is not
---                 readable, so element-only clues are left unresolved.
---   * WEAPON   -> not reliably readable; left unresolved.
--- With the first and third bosses identified, the second is the remaining one.
--- If the clues cannot be resolved (e.g. weapon-only), `nextTarget` returns nil
--- and the caller waits rather than guessing a wrong order (a wrong kill resets
--- the trial).

---@class doprog.ClueBoss
---@field name string
---@field element string

---@class doprog.ClueSolver
---@field private _bosses doprog.ClueBoss[]
---@field private _armed boolean
---@field private _clues { dim: string, val: string }[]
---@field private _entry doprog.Vec3?
---@field private _order string[]?
---@field private _eventN integer
local ClueSolver = {}
ClueSolver.__index = ClueSolver

-- Decode table: emote substring -> (dimension, value). Phrases are taken from the
-- eqresource walkthrough and player comments.
local DECODE = {
    { match = 'least size', dim = 'size', val = 'smallest' },
    { match = 'greatest in size', dim = 'size', val = 'largest' },
    { match = 'neither largest nor tiniest', dim = 'size', val = 'medium' },
    { match = 'stands foremost', dim = 'pos', val = 'front' },
    { match = 'furthest from battle', dim = 'pos', val = 'rear' },
    { match = 'stands to the rear', dim = 'pos', val = 'rear' },
    { match = 'stands mid-most', dim = 'pos', val = 'middle' },
    { match = 'neither foremost nor furthest', dim = 'pos', val = 'middle' },
    { match = 'modest weapon', dim = 'weapon', val = 'rapier' },
    { match = 'rapier', dim = 'weapon', val = 'rapier' },
    { match = 'greatest of arms', dim = 'weapon', val = 'largest' },
    { match = 'least of weapons', dim = 'weapon', val = 'smallest' },
    { match = 'in its element', dim = 'element', val = 'room' },
}

---@param bosses doprog.ClueBoss[]
---@return doprog.ClueSolver
function ClueSolver.new(bosses)
    return setmetatable({
        _bosses = bosses, _armed = false, _clues = {},
        _entry = nil, _order = nil, _eventN = 0,
    }, ClueSolver)
end

---@private
---@param ctx doprog.StepContext
function ClueSolver:_arm(ctx)
    if self._armed then return end
    self._armed = true
    self._entry = ctx.mq:loc()
    local clues = self._clues
    for _, d in ipairs(DECODE) do
        self._eventN = self._eventN + 1
        ctx.mq:registerEvent('doprog_clue_' .. self._eventN, ('#*#%s#*#'):format(d.match),
            function() clues[#clues + 1] = { dim = d.dim, val = d.val } end)
    end
    ctx.log:Info('clue solver armed for Trial of Three')
end

---@private
---@param a doprog.Vec3
---@param b doprog.Vec3
---@return number
local function dist2(a, b)
    local dx, dy = a.x - b.x, a.y - b.y
    return dx * dx + dy * dy
end

--- Gather the live boss spawns with the attributes we can observe.
---@private
---@param ctx doprog.StepContext
---@return { name: string, id: integer, height: number, dist: number }[]
function ClueSolver:_infos(ctx)
    local infos = {}
    local entry = self._entry or ctx.mq:loc()
    for _, b in ipairs(self._bosses) do
        local id = ctx.mq:findSpawn({ name = b.name, npc = true })
        if id then
            infos[#infos + 1] = {
                name = b.name,
                id = id,
                height = ctx.mq:spawnHeight(id),
                dist = dist2(entry, ctx.mq:spawnLoc(id)),
            }
        end
    end
    return infos
end

--- Resolve one clue to a boss name, or nil if not determinable.
---@private
---@param ctx doprog.StepContext
---@param clue { dim: string, val: string }
---@return string?
function ClueSolver:_resolve(ctx, clue)
    local infos = self:_infos(ctx)
    if #infos < 3 then return nil end -- need all three visible to rank reliably
    local key = (clue.dim == 'size') and 'height' or (clue.dim == 'pos') and 'dist' or nil
    if not key then return nil end -- weapon/element: not observable
    table.sort(infos, function(a, b) return a[key] < b[key] end)
    if clue.val == 'smallest' or clue.val == 'front' then return infos[1].name end
    if clue.val == 'largest' or clue.val == 'rear' then return infos[#infos].name end
    if clue.val == 'medium' or clue.val == 'middle' then return infos[2].name end
    return nil
end

--- Try to compute the [first, second, third] kill order from captured clues.
---@private
---@param ctx doprog.StepContext
function ClueSolver:_solve(ctx)
    if self._order or #self._clues < 2 then return end
    local first = self:_resolve(ctx, self._clues[1])
    local third = self:_resolve(ctx, self._clues[2])
    if not first or not third or first == third then return end
    local second
    for _, b in ipairs(self._bosses) do
        if b.name ~= first and b.name ~= third then second = b.name break end
    end
    if not second then return end
    self._order = { first, second, third }
    ctx.log:Info('Trial of Three order solved: %s -> %s -> %s', first, second, third)
end

--- The next boss to kill, as a SpawnQuery. Returns `false` while the order is
--- not yet solved (caller should WAIT, not advance), and `nil` once every boss
--- in the solved order is dead (caller is done).
---@param ctx doprog.StepContext
---@return doprog.SpawnQuery|false|nil
function ClueSolver:nextTarget(ctx)
    self:_arm(ctx)
    self:_solve(ctx)
    if not self._order then return false end
    for _, name in ipairs(self._order) do
        if ctx.mq:findSpawn({ name = name, npc = true }) ~= nil then
            return { name = name, npc = true }
        end
    end
    return nil
end

return ClueSolver
