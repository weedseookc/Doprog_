--- doprog.zones.esianti.mercenary_not_as_swell
---
--- Not as Swell as You Would Think (solo mercenary).
--- Source: tbl.eqresource.com/notasswellasyouwouldthink.php
--- Giver/turn-in: Phibbit (Esianti: Palace of the Winds). Request: "swell".
--- 30m lockout. Repeatable.
---
--- Objectives (in order, per source):
---   1. Destroy Swell Armors. 0/4 -> swell armors throughout the Eastern section.
---   2. Return to Phibbit. 0/1 -> return and hail Phibbit.

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
        -- 1: destroy 4 Swell Armors (Eastern section); objective counts the kills.
        S.combat({ zone = 'esianti', taskName = TASK, objective = 1,
            target = { name = 'Swell Armor', npc = true },
            desc = 'destroy 4 Swell Armors (East Esianti)' }),
        -- 2: return to and hail Phibbit.
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK, objective = 2,
            desc = 'return to Phibbit' }),
    },
})
