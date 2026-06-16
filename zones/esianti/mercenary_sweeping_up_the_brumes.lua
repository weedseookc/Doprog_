--- doprog.zones.esianti.mercenary_sweeping_up_the_brumes
---
--- Sweeping up the Brumes (solo mercenary).
--- Source: https://tbl.eqresource.com/sweepingupthebrumes.php
--- Giver/turn-in: Phibbit (Esianti: Palace of the Winds). Request: "brume".
--- 30-minute lockout, repeatable. Reward: 212pp 5gp; Mercenary of Esianti
--- achievement. (Source gives no /loc, exact spawn points, or emote text.)
---
--- Objectives (in order):
---   1. Dispatch Brume Armors. 0/4 -> brume armors throughout the Middle section.
---   2. Return to Phibbit. 0/1 -> return and hail.

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
        -- Navigate to Phibbit, hail, say the offer keyword, accept the window.
        S.pickup({ zone = 'esianti', npc = GIVER, taskName = TASK, request = 'brume',
            desc = 'accept Sweeping up the Brumes (say "brume")' }),
        -- 1: defeat 4 Brume Armors. doprog targets each; the host kills. Mid zone.
        S.combat({ zone = 'esianti', taskName = TASK, objective = 1,
            target = { name = 'Brume Armor', npc = true },
            desc = 'dispatch 4 Brume Armors (Middle section of Esianti)' }),
        -- 2: return to Phibbit and hail (objective-gated).
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK, objective = 2,
            desc = 'return to and hail Phibbit' }),
    },
})
