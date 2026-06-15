--- tools/gen_quests.lua
---
--- Generates the per-quest zone files from a single data table of real TBL
--- givers (sourced from tbl.eqresource.com Quests-by-NPC pages). Run from the
--- repo root:  lua5.4 tools/gen_quests.lua
---
--- Combat steps are objective-driven (no fabricated mob names): doprog advertises
--- NEED_COMBAT and watches the task objective counter while the host kills.
--- Givers that live in a different zone than the objectives use a giverZone so
--- the pickup/hand-in navigate to the right place.

---@class GenEntry
---@field dir string
---@field file string
---@field name string
---@field qtype string         # partisan | mercenary | task | mission
---@field zone string          # zone the objectives are in
---@field giver string
---@field gz string            # giver zone (where pickup/handin happen)
---@field requestSay? string   # missions only
---@field prereq? string[]     # required completed task names

local Q = {}
local function add(e) Q[#Q + 1] = e end

-- ===== Stratos: Zephyr's Flight =====
add{ dir='stratos', file='mercenary_soldier_of_air',       name='Soldier of Air',        qtype='mercenary', zone='stratos', giver='Grieving Soul Scent',    gz='stratos' }
add{ dir='stratos', file='mission_fight_fire',             name='Fight Fire',            qtype='mission',   zone='stratos', giver='Grieving Soul Scent',    gz='stratos', requestSay='fight fire', prereq={'Soldier of Air'} }
add{ dir='stratos', file='partisan_petitioners_plight',    name="A Petitioner's Plight", qtype='partisan',  zone='stratos', giver='Iron Lightning Spirit',  gz='stratos' }
add{ dir='stratos', file='partisan_political_awareness',   name='Political Awareness',   qtype='partisan',  zone='stratos', giver='Rianar Gadliun',         gz='stratos' }
add{ dir='stratos', file='partisan_key_to_the_kingdom',    name='Key to the Kingdom',    qtype='partisan',  zone='stratos', giver='Dusky Iron Meditation',  gz='stratos' }
add{ dir='stratos', file='mercenary_do_unto_them',         name='Do Unto Them',          qtype='mercenary', zone='stratos', giver='Ashen Wandering Horizon',gz='stratos' }
add{ dir='stratos', file='mercenary_earning_ones_place',   name="Earning One's Place",   qtype='mercenary', zone='stratos', giver='Iron Lightning Spirit',  gz='stratos' }

-- ===== Esianti: Palace of the Winds =====
add{ dir='esianti', file='partisan_all_hail_the_king',     name='All Hail the King',            qtype='partisan',  zone='esianti', giver='Great Sky Ocean',        gz='stratos' }
add{ dir='esianti', file='partisan_of_mice_and_jann',      name='Of Mice and Jann',             qtype='partisan',  zone='esianti', giver='Joyous Blossom',         gz='esianti' }
add{ dir='esianti', file='partisan_serving_another_master',name='Serving Another Master',       qtype='partisan',  zone='esianti', giver='Obsidian Sundering Master',gz='esianti' }
add{ dir='esianti', file='mission_contract_of_war',        name='Contract of War',              qtype='mission',   zone='esianti', giver='Great Sky Ocean',        gz='stratos', requestSay='contract of war' }
add{ dir='esianti', file='mercenary_armor_of_acrophobia',  name='Armor of Acrophobia',          qtype='mercenary', zone='esianti', giver='Phibbit',                gz='esianti' }
add{ dir='esianti', file='mercenary_not_as_swell',         name='Not as Swell as You Would Think',qtype='mercenary',zone='esianti', giver='Phibbit',               gz='esianti' }
add{ dir='esianti', file='mercenary_beyond_expyration_date',name='Beyond the Ex-pyre-ation Date',qtype='mercenary', zone='esianti', giver='Phibbit',                gz='esianti' }
add{ dir='esianti', file='mercenary_sweeping_up_the_brumes',name='Sweeping up the Brumes',      qtype='mercenary', zone='esianti', giver='Phibbit',                gz='esianti' }

-- ===== Empyr: Realms of Ash =====
add{ dir='empyr', file='partisan_prisoners_dilemma', name="Prisoner's Dilemma",     qtype='partisan',  zone='empyr', giver='Star Stealing Sage',    gz='empyr' }
add{ dir='empyr', file='partisan_palace_of_embers',  name='Palace of Embers',       qtype='partisan',  zone='empyr', giver='Great Sky Ocean',       gz='stratos' }
add{ dir='empyr', file='partisan_fire_and_fury',     name='Fire and Fury',          qtype='partisan',  zone='empyr', giver='Horizon Blighted Sage', gz='empyr' }
add{ dir='empyr', file='mission_prince_ralaifin',    name='Prince Ralaifin',        qtype='mission',   zone='empyr', giver='Horizon Blighted Sage', gz='empyr', requestSay='prince ralaifin' }
add{ dir='empyr', file='mercenary_scalding_webs',    name='Scalding Webs We Weave', qtype='mercenary', zone='empyr', giver='Charred Forest',        gz='empyr' }
add{ dir='empyr', file='mercenary_crafted_from_ash', name='Crafted from Ash',       qtype='mercenary', zone='empyr', giver='Charred Forest',        gz='empyr' }
add{ dir='empyr', file='mercenary_slimy_yet_sizzling',name='Slimy, Yet Sizzling',   qtype='mercenary', zone='empyr', giver='Charred Forest',        gz='empyr' }

-- ===== Aalishai: Palace of Embers =====
add{ dir='aalishai', file='partisan_royal_visits',      name='Royal Visits',       qtype='partisan',  zone='aalishai', giver='Sky Orchid Understanding', gz='esianti' }
add{ dir='aalishai', file='partisan_enter_mearatas',    name='Enter Mearatas',     qtype='partisan',  zone='aalishai', giver='Blazing Sorrows Darkness', gz='aalishai' }
add{ dir='aalishai', file='partisan_fragmented_coterie', name='Fragmented Coterie', qtype='partisan', zone='aalishai', giver='Spear Sundering Ivory',    gz='aalishai' }
add{ dir='aalishai', file='mission_brass_palace',       name='Brass Palace',       qtype='mission',   zone='aalishai', giver='Great Sky Ocean',          gz='stratos', requestSay='brass palace' }
add{ dir='aalishai', file='mercenary_gathering_elements_air',  name='Gathering Elements: Air',   qtype='mercenary', zone='aalishai', giver='Everna Delestrod', gz='aalishai' }
add{ dir='aalishai', file='mercenary_gathering_elements_water',name='Gathering Elements: Water', qtype='mercenary', zone='aalishai', giver='Everna Delestrod', gz='aalishai' }
add{ dir='aalishai', file='mercenary_gathering_elements_earth',name='Gathering Elements: Earth', qtype='mercenary', zone='aalishai', giver='Everna Delestrod', gz='aalishai' }

-- ===== Mearatas: The Stone Demesne =====
add{ dir='mearatas', file='partisan_earthen_dirge',   name='Earthen Dirge',  qtype='partisan',  zone='mearatas', giver='Obsidian Sundering Master', gz='esianti' }
add{ dir='mearatas', file='partisan_mold_seeker',     name='Mold Seeker',    qtype='partisan',  zone='mearatas', giver='Obsidian Sundering Master', gz='esianti' }
add{ dir='mearatas', file='partisan_slippery_slope',  name='Slippery Slope', qtype='partisan',  zone='mearatas', giver='Flexing Devout Purpose',    gz='mearatas' }
add{ dir='mearatas', file='mission_relic_raider',     name='Relic Raider',   qtype='mission',   zone='mearatas', giver='Key of the Relic Keeper',   gz='mearatas', requestSay='relic raider' }
add{ dir='mearatas', file='mercenary_thin_out_the_mephits',name='Thin out the Mephits', qtype='mercenary', zone='mearatas', giver='Emli Widgetton', gz='mearatas' }
add{ dir='mearatas', file='mercenary_free_the_wardens',name='Free the Wardens', qtype='mercenary', zone='mearatas', giver='Emli Widgetton',        gz='mearatas' }
add{ dir='mearatas', file='mercenary_lost_missives',  name='Lost Missives',   qtype='mercenary', zone='mearatas', giver='Emli Widgetton',           gz='mearatas' }

-- ===== Doomfire, the Burning Lands =====
add{ dir='doomfire', file='task_delivery',      name='Delivery',      qtype='task', zone='doomfire', giver='Unrepentant Sunrise', gz='doomfire' }
add{ dir='doomfire', file='task_remodeling',    name='Remodeling',    qtype='task', zone='doomfire', giver='Unrepentant Sunrise', gz='doomfire' }
add{ dir='doomfire', file='task_strange_magic', name='Strange Magic', qtype='task', zone='doomfire', giver='Unrepentant Sunrise', gz='doomfire' }

local function q(s) return string.format('%q', s) end

---@param e GenEntry
---@return string
local function render(e)
    local isMission = e.qtype == 'mission'
    local ctor = isMission and 'Mission' or 'Quest'
    local req = isMission and 'doprog.domain.mission' or 'doprog.domain.quest'
    local lines = {}
    local function w(s) lines[#lines + 1] = s end

    w(('--- doprog.zones.%s.%s'):format(e.dir, e.file))
    w(('--- %s — %s%s. Giver: %s%s.'):format(
        e.name, e.qtype, isMission and ' (group mission, 1h lockout)' or '',
        e.giver, e.gz ~= e.zone and (' in ' .. e.gz) or ''))
    w('--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches')
    w('--- the task objective; the host combat system selects and kills targets.')
    w(("local %s = require('%s')"):format(ctor, req))
    w("local S = require('doprog.steps')")
    w('')
    w('---@type doprog.SpawnQuery')
    w(('local GIVER = { name = %s, npc = true }'):format(q(e.giver)))
    w('')
    w(('---@type doprog.%s'):format(ctor))
    w(('return %s.new({'):format(ctor))
    w(('    name = %s,'):format(q(e.name)))
    if not isMission then
        w(('    type = %s,'):format(q(e.qtype)))
    end
    w(('    zone = %s,'):format(q(e.zone)))
    w(('    completionTask = %s,'):format(q(e.name)))
    if isMission then
        w('    requestNpc = GIVER,')
        w(('    requestSay = %s,'):format(q(e.requestSay or e.name:lower())))
        w('    lockoutMinutes = 60,')
    end
    if e.prereq then
        local t = {}
        for _, p in ipairs(e.prereq) do t[#t + 1] = q(p) end
        w(('    prereq = { tasks = { %s } },'):format(table.concat(t, ', ')))
    end
    w('    steps = {')
    w(('        S.pickup({ zone = %s, npc = GIVER, taskName = %s, desc = %s }),'):format(
        q(e.gz), q(e.name), q((isMission and 'request ' or 'accept ') .. e.name)))
    w(('        S.combat({ zone = %s, taskName = %s, objective = 1, desc = %s }),'):format(
        q(e.zone), q(e.name), q(e.name .. ' — clear combat objective')))
    w(('        S.handin({ zone = %s, npc = GIVER, taskName = %s, desc = %s }),'):format(
        q(e.gz), q(e.name), q('complete ' .. e.name)))
    w('    },')
    w('})')
    return table.concat(lines, '\n') .. '\n'
end

local count = 0
for _, e in ipairs(Q) do
    local path = ('zones/%s/%s.lua'):format(e.dir, e.file)
    local f = assert(io.open(path, 'w'))
    f:write(render(e))
    f:close()
    count = count + 1
end
print(('generated %d quest files'):format(count))
