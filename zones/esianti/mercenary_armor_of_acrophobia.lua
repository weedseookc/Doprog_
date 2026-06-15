--- doprog.zones.esianti.mercenary_armor_of_acrophobia
---
--- Armor of Acrophobia (solo mercenary). Source:
--- tbl.eqresource.com/armorofacrophobia
--- Giver/turn-in: Phibbit (Esianti). Request: "crag".
---   1. Free Crag Armors. 0/4 -> Crag armors throughout the SW section.
---   2. Return to Phibbit. 0/1 -> hail.

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
        S.combat({ zone = 'esianti', taskName = TASK, objective = 1,
            target = { name = 'Crag Armor', npc = true },
            desc = 'free 4 Crag Armors (SW Esianti)' }),
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK, desc = 'return to Phibbit' }),
    },
})
