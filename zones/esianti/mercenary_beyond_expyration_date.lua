--- doprog.zones.esianti.mercenary_beyond_expyration_date
---
--- Beyond the Ex-pyre-ation Date (solo mercenary).
--- Source: https://tbl.eqresource.com/beyondtheexpyreationdate.php
--- Giver/turn-in: Phibbit (Esianti: Palace of the Winds). Request: "pyre".
--- 30-minute lockout, repeatable. Reward: 212pp 5gp; Mercenary of Esianti
--- achievement. (Source gives no /loc, exact spawn points, or emote text.)
---
--- Objectives (in order):
---   1. Rough up Pyre Armors. 0/4 -> pyre armors throughout the NW section.
---   2. Return to Phibbit. 0/1 -> return and hail.

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
        -- Navigate to Phibbit, hail, say the offer keyword, accept the window.
        S.pickup({ zone = 'esianti', npc = GIVER, taskName = TASK, request = 'pyre',
            desc = 'accept Beyond the Ex-pyre-ation Date (say "pyre")' }),
        -- 1: defeat 4 Pyre Armors. doprog targets each; the host kills. NW section.
        S.combat({ zone = 'esianti', taskName = TASK, objective = 1,
            target = { name = 'Pyre Armor', npc = true },
            desc = 'rough up 4 Pyre Armors (NW section of Esianti)' }),
        -- 2: return to Phibbit and hail (objective-gated).
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK, objective = 2,
            desc = 'return to and hail Phibbit' }),
    },
})
