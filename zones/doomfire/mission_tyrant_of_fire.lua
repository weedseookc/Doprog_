--- doprog.zones.doomfire.mission_tyrant_of_fire
---
--- Tyrant of Fire (group mission 1-6). Source: tbl.eqresource.com/tyrantoffire.php
--- A key progression link: Royal Visits -> Tyrant of Fire -> Enter Mearatas.
--- Requested by RIGHT-CLICKING the "Golden Ruby and Garnet Ring" in the Plane of
--- Tranquility (a replacement ring comes from Sky Orchid Understanding in Esianti).
--- Zone in by saying "ready" to Unrepentant Sunrise in the (Old) Plane of Fire.
--- Objectives play out in Doomfire. 6h limit, 5h lockout, repeatable.
---
--- Objectives (in order):
---   1. Speak with Fennin Ro about the ring. 0/1 -> head SOUTH into the courtyard
---      and defeat the invader packs scattered through the area. Kill the TANK
---      mobs FIRST since they summon via script; mobs can be CC'd and are not KOS.
---      When the packs are cleared, Fennin Ro spawns and summons the group, then
---      we hail him to satisfy the objective.
---   2. Open the chest. 0/1.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Tyrant of Fire'
---@type doprog.SpawnQuery
local PORTER = { name = 'Unrepentant Sunrise', npc = true }
---@type doprog.SpawnQuery
local FENNIN = { name = 'Fennin Ro', npc = true }
-- Tank mobs summon via script, so they die first; everything else in the pack
-- after. Excluding Fennin keeps the sweep off the boss that spawns at the end.
local TANKS = { name = 'tank', npc = true, radius = 1000, exclude = { 'Fennin' } }
local INVADERS = { name = 'invader', npc = true, radius = 1000, exclude = { 'Fennin' } }

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
        -- Request by right-clicking the ring in the Plane of Tranquility.
        S.click({ zone = 'potranquility',
            action = '/multiline ; /itemnotify "Golden Ruby and Garnet Ring" rightmouseup ; /notify TaskSelectWnd TSEL_AcceptButton leftmouseup',
            condition = function(ctx) return ctx.task:has(TASK) end,
            desc = 'right-click the Golden Ruby and Garnet Ring in PoT to get the task' }),
        -- Zone in via Unrepentant Sunrise (say "ready").
        S.click({ npc = PORTER, action = '/say ready',
            desc = 'enter the instance (say "ready" to Unrepentant Sunrise)' }),
        -- Obj 1, phase A: south into the courtyard, kill the tank mobs first.
        S.combat({ target = TANKS,
            desc = 'south into the courtyard: defeat the tank mobs first (they summon)' }),
        -- Obj 1, phase B: clear the remaining invader packs; Fennin Ro then spawns.
        S.combat({ target = INVADERS,
            desc = 'clear the remaining invader packs (CC ok; not KOS)' }),
        -- Obj 1 complete: hail Fennin Ro once he spawns and summons the group.
        S.handin({ npc = FENNIN, taskName = TASK, objective = 1,
            desc = 'speak with Fennin Ro about the ring (completes obj 1)' }),
        -- Obj 2: open the chest.
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest' }),
    },
})
