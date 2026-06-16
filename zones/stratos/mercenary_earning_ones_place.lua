--- doprog.zones.stratos.mercenary_earning_ones_place
---
--- Earning One's Place (solo mercenary task). Source:
--- tbl.eqresource.com/earningonesplace
--- Giver: Iron Lightning Spirit (Stratos: Zephyr's Flight), reached via the
--- Soaring Moon porter (hail Soaring Moon, say "assist"). Request: "worthiness".
--- Requirement noted on the page: Servants of Esianti faction "Threateningly or
--- Lower" before the task is offered (faction is not automated here).
---
--- Objective (single):
---   1. Gain favor with the Djinn by assisting in their war with the Efreeti. 0/5
---      -> Reach the Efreeti area via Soaring Moon (say "accept") and defeat 5
---         Efreeti. Objective-driven; completes the task on 0/5.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local PORTER = { name = 'Soaring Moon', npc = true }
---@type doprog.SpawnQuery
local GIVER = { name = 'Iron Lightning Spirit', npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Earning One's Place",
    type = 'mercenary',
    zone = 'stratos',
    completionTask = "Earning One's Place",
    steps = {
        S.click({ zone = 'stratos', npc = PORTER, action = '/say assist', completeAfter = 4000,
            desc = 'port to Iron Lightning Spirit (Soaring Moon: assist)' }),
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = "Earning One's Place", request = 'worthiness',
            desc = "accept Earning One's Place (say \"worthiness\")" }),
        S.click({ zone = 'stratos', npc = PORTER, action = '/say accept', completeAfter = 4000,
            desc = 'port to the Efreeti area (Soaring Moon: accept)' }),
        -- Per player tip: the Efreeti can be KOS on arrival; break line of sight
        -- behind a tree until engaged. doprog only repositions; the host fights.
        S.combat({ zone = 'stratos', taskName = "Earning One's Place", objective = 1,
            mechanics = { { react = 'hide', desc = 'hide behind a tree if KOS on arrival' } },
            desc = 'defeat 5 Efreeti in the Djinn-Efreeti war (obj 1)' }),
    },
})
