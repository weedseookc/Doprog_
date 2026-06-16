--- doprog.zones.stratos.partisan_petitioners_plight
---
--- A Petitioner's Plight (group task, 1-6). Source:
--- tbl.eqresource.com/apetitionersplight
--- Giver/turn-in: Iron Lightning Spirit, reached via the Soaring Moon porter
--- (hail Soaring Moon, say "assist"; you must be next to the NPC to request).
--- 24h limit, 30m lockout, repeatable.
---
--- Objectives:
---   1. Remove unwanted petitioners. 0/4  -> defeat petitioners around the zone.
---   2. Find and get rid of some of the more persistent petitioners. 0/2
---      -> Multiple paths; we take the deterministic one: defeat "Still Ore"
---         twice. (Alternatives: Still Ore + Bloom, or say "karana" to trigger
---         Cold Cloud Blossom.)
---   3. Speak with Iron Lightning Spirit. 0/1 -> hail.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local PORTER = { name = 'Soaring Moon', npc = true }
---@type doprog.SpawnQuery
local GIVER = { name = 'Iron Lightning Spirit', npc = true }

---@type doprog.Quest
return Quest.new({
    name = "A Petitioner's Plight",
    type = 'partisan',
    zone = 'stratos',
    completionTask = "A Petitioner's Plight",
    steps = {
        S.click({ zone = 'stratos', npc = PORTER, action = '/say assist', completeAfter = 4000,
            desc = 'port to Iron Lightning Spirit (Soaring Moon: assist)' }),
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = "A Petitioner's Plight",
            desc = "accept A Petitioner's Plight" }),
        S.combat({ zone = 'stratos', taskName = "A Petitioner's Plight", objective = 1,
            desc = 'defeat 4 unwanted petitioners' }),
        S.combat({ zone = 'stratos', taskName = "A Petitioner's Plight", objective = 2,
            target = { name = 'Still Ore', npc = true },
            desc = 'defeat the persistent petitioner "Still Ore" twice' }),
        S.click({ zone = 'stratos', npc = PORTER, action = '/say assist', completeAfter = 4000,
            desc = 'return to Iron Lightning Spirit (Soaring Moon: assist)' }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = "A Petitioner's Plight", objective = 3,
            desc = 'speak with Iron Lightning Spirit (obj 3)' }),
    },
})
