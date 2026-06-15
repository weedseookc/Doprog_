--- doprog.zones.esianti.mercenary_beyond_expyration_date
---
--- Beyond the Ex-pyre-ation Date (solo mercenary). Source:
--- tbl.eqresource.com/beyondtheexpyreationdate
--- Giver/turn-in: Phibbit (Esianti). Request: "pyre".
---   1. Rough up Pyre Armors. 0/4 -> Pyre armors in the NW section.
---   2. Return to Phibbit. 0/1 -> hail.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Beyond the Ex-pyre-ation Date'
---@type doprog.SpawnQuery
local GIVER = { name = 'Phibbit', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'esianti',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'esianti', npc = GIVER, taskName = TASK, request = 'pyre',
            desc = 'accept Beyond the Ex-pyre-ation Date (say "pyre")' }),
        S.combat({ zone = 'esianti', taskName = TASK, objective = 1,
            target = { name = 'Pyre Armor', npc = true },
            desc = 'rough up 4 Pyre Armors (NW Esianti)' }),
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK, desc = 'return to Phibbit' }),
    },
})
