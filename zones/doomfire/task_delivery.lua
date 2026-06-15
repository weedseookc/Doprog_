--- doprog.zones.doomfire.task_delivery
---
--- Delivery (group task 1-6). Source: tbl.eqresource.com/delivery
--- Giver/turn-in: Unrepentant Sunrise (Doomfire). Request: "delivery".
---
--- Objectives:
---   1. Fight your way to the throne room to speak with Fennin Ro. 0/3 -> jopal
---      see-invis at zone-in, Guardian of Doomfire (random Doom debuff), 2 snails
---      (continue East after the Guardian).
---   2. Deliver the duende mold to Fennin Ro. 0/1.
---   3. Open the chest. 0/1.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Delivery'
---@type doprog.SpawnQuery
local GIVER = { name = 'Unrepentant Sunrise', npc = true }
local FENNIN = { name = 'Fennin Ro', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'doomfire',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'doomfire', npc = GIVER, taskName = TASK, request = 'delivery',
            desc = 'accept Delivery (say "delivery")' }),
        S.combat({ zone = 'doomfire', taskName = TASK, objective = 1, target = { npc = true, radius = 1000 },
            desc = 'fight to the throne room: jopal, Guardian of Doomfire, 2 snails' }),
        S.handin({ zone = 'doomfire', npc = FENNIN, taskName = TASK, objective = 2,
            items = { 'duende mold' }, desc = 'deliver the duende mold to Fennin Ro' }),
        S.click({ zone = 'doomfire', action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
