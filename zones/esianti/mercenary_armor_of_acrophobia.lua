--- doprog.zones.esianti.mercenary_armor_of_acrophobia
---
--- Armor of Acrophobia (solo mercenary).
--- Source: tbl.eqresource.com/armorofacrophobia.php
--- Giver/turn-in: Phibbit (Esianti: Palace of the Winds). Request: "crag".
--- Unlimited time, 30m lockout. Repeatable.
---
--- Objectives (in order, per source):
---   1. Free Crag Armors. 0/4 -> crag armors throughout the SW section of the zone.
---   2. Return to Phibbit. 0/1 -> return and hail Phibbit.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Armor of Acrophobia'
---@type doprog.SpawnQuery
local GIVER = { name = 'Phibbit', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'esianti',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'esianti', npc = GIVER, taskName = TASK, request = 'crag',
            desc = 'accept Armor of Acrophobia (say "crag")' }),
        -- 1: free 4 Crag Armors (SW section); objective counts the kills.
        S.combat({ zone = 'esianti', taskName = TASK, objective = 1,
            target = { name = 'Crag Armor', npc = true },
            desc = 'free 4 Crag Armors (SW Esianti)' }),
        -- 2: return to and hail Phibbit.
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK, objective = 2,
            desc = 'return to Phibbit' }),
    },
})
