--- doprog.zones.stratos.mercenary_do_unto_them
---
--- Do Unto Them (solo mercenary task). Source: tbl.eqresource.com/dountothem
--- Giver/turn-in: Ashen Wandering Horizon (Stratos: Zephyr's Flight).
--- Request phrase: "destroy the djinn". Lockout 30m, repeatable.
---
--- Objectives:
---   1. Defeat the residents of Stratos on behalf of the Empyr invaders. 0/9
---      -> Blue-con mobs in the half of the zone nearer the Plane of Tranquility
---         zone line. Objective-driven combat (host kills, doprog watches 0/9).
---   2. Speak with Ashen Wandering Horizon about your success. 0/1 -> hail.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = 'Ashen Wandering Horizon', npc = true }

---@type doprog.Quest
return Quest.new({
    name = 'Do Unto Them',
    type = 'mercenary',
    zone = 'stratos',
    completionTask = 'Do Unto Them',
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = 'Do Unto Them', request = 'destroy the djinn',
            desc = 'accept Do Unto Them (say "destroy the djinn")' }),
        S.combat({ zone = 'stratos', taskName = 'Do Unto Them', objective = 1,
            desc = 'defeat 9 blue-con residents near the PoT zone line' }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = 'Do Unto Them', objective = 2,
            desc = 'speak with Ashen Wandering Horizon (obj 2)' }),
    },
})
