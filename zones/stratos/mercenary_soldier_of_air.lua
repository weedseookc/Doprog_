--- doprog.zones.stratos.mercenary_soldier_of_air
---
--- Soldier of Air (solo mercenary task). Source: tbl.eqresource.com/soldierofair
--- Giver/turn-in: Grieving Soul Scent (Stratos: Zephyr's Flight).
--- Request phrase: "deal with". Lockout 30m, repeatable.
---
--- Objectives:
---   1. Drive back the invaders from Empyr. 0/5
---      -> Defeat 5 *Brass Phoenix Brigade* mobs deep in the zone. Per player
---         comments, mephits and air elementals do NOT count. Objective-driven:
---         doprog advertises NEED_COMBAT and watches the 0/5 counter; the host
---         must engage Brass Phoenix Brigade specifically.
---   2. Speak with Grieving Soul Scent. 0/1  -> hail to finish.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = 'Grieving Soul Scent', npc = true }

---@type doprog.Quest
return Quest.new({
    name = 'Soldier of Air',
    type = 'mercenary',
    zone = 'stratos',
    completionTask = 'Soldier of Air',
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = 'Soldier of Air', request = 'deal with',
            desc = 'accept Soldier of Air (say "deal with")' }),
        -- doprog picks the target: nearest deep-zone NPC that is NOT a mephit or
        -- air elemental (those don't count), and closes the distance to it so the
        -- host doesn't grind the wrong mobs by the quest giver.
        S.combat({ zone = 'stratos', taskName = 'Soldier of Air', objective = 1,
            target = { npc = true, radius = 1000, exclude = { 'mephit', 'air elemental', 'elemental', 'twister', 'breeze' } },
            desc = 'defeat 5 Brass Phoenix Brigade (NOT mephits/air elementals)' }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = 'Soldier of Air',
            desc = 'speak with Grieving Soul Scent to finish' }),
    },
})
