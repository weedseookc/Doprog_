--- doprog.zones.esianti.mercenary_sweeping_up_the_brumes
---
--- Sweeping up the Brumes (solo mercenary). Source:
--- tbl.eqresource.com/sweepingupthebrumes
--- Giver/turn-in: Phibbit (Esianti). Request: "brume".
---   1. Dispatch Brume Armors. 0/4 -> Brume armors in the middle section.
---   2. Return to Phibbit. 0/1 -> hail.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Sweeping up the Brumes'
---@type doprog.SpawnQuery
local GIVER = { name = 'Phibbit', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'esianti',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'esianti', npc = GIVER, taskName = TASK, request = 'brume',
            desc = 'accept Sweeping up the Brumes (say "brume")' }),
        S.combat({ zone = 'esianti', taskName = TASK, objective = 1,
            target = { name = 'Brume Armor', npc = true },
            desc = 'dispatch 4 Brume Armors (mid Esianti)' }),
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK, desc = 'return to Phibbit' }),
    },
})
