--- doprog.zones.esianti.mercenary_not_as_swell
---
--- Not as Swell as You Would Think (solo mercenary). Source:
--- tbl.eqresource.com/notasswellasyouwouldthink
--- Giver/turn-in: Phibbit (Esianti). Request: "swell".
---   1. Destroy Swell Armors. 0/4 -> Swell armors throughout the Eastern section.
---   2. Return to Phibbit. 0/1 -> hail.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Not as Swell as You Would Think'
---@type doprog.SpawnQuery
local GIVER = { name = 'Phibbit', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'esianti',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'esianti', npc = GIVER, taskName = TASK, request = 'swell',
            desc = 'accept Not as Swell as You Would Think (say "swell")' }),
        S.combat({ zone = 'esianti', taskName = TASK, objective = 1,
            target = { name = 'Swell Armor', npc = true },
            desc = 'destroy 4 Swell Armors (East Esianti)' }),
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK, desc = 'return to Phibbit' }),
    },
})
