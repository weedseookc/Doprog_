--- doprog.zones.doomfire.mission_tyrant_of_fire
---
--- Tyrant of Fire (group mission 1-6). Source: tbl.eqresource.com/tyrantoffire
--- A key progression link: Royal Visits -> Tyrant of Fire -> Enter Mearatas.
--- Requested by RIGHT-CLICKING the "Golden Ruby and Garnet Ring" in Plane of
--- Tranquility (a replacement ring comes from Sky Orchid Understanding in
--- Esianti). Zone in by saying "ready" to Unrepentant Sunrise in the Old Plane
--- of Fire. Objectives are in Doomfire. 6h limit, 5h lockout.
---
--- Objectives:
---   1. Speak with Fennin Ro about the ring. 0/1 -> head south into the courtyard
---      and defeat invader packs; kill the TANK mobs first (they summon via
---      script). When the final mob's script text fires, Fennin Ro spawns and
---      summons the group.
---   2. Open the chest. 0/1.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Tyrant of Fire'
---@type doprog.SpawnQuery
local PORTER = { name = 'Unrepentant Sunrise', npc = true }

---@type doprog.Mission
return Mission.new({
    name = TASK,
    zone = 'doomfire',
    completionTask = TASK,
    requestNpc = PORTER,
    requestSay = 'ready',
    lockoutMinutes = 300,
    prereq = { tasks = {
        'Soldier of Air', 'Fight Fire', 'Trial of Three', "Prisoner's Dilemma",
        'Palace of Embers', 'Brass Palace', 'Key to the Kingdom', 'Contract of War',
        'All Hail the King', 'Royal Visits',
    } },
    steps = {
        -- Request by right-clicking the ring in Plane of Tranquility.
        S.click({ zone = 'potranquility',
            action = '/multiline ; /itemnotify "Golden Ruby and Garnet Ring" rightmouseup ; /notify TaskSelectWnd TSEL_AcceptButton leftmouseup',
            condition = function(ctx) return ctx.task:has(TASK) end,
            desc = 'right-click the Golden Ruby and Garnet Ring in PoT to get the task' }),
        -- Zone in via Unrepentant Sunrise in the Old Plane of Fire.
        S.click({ npc = PORTER, action = '/say ready',
            desc = 'enter the instance (say "ready" to Unrepentant Sunrise)' }),
        -- 1: clear invader packs (tanks first); Fennin Ro spawns and summons you.
        S.combat({ taskName = TASK, objective = 1,
            target = { npc = true, radius = 1000, exclude = { 'Fennin' } },
            desc = 'defeat the invader packs (kill tank mobs first); Fennin Ro then spawns' }),
        -- 2: open the chest.
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest' }),
    },
})
