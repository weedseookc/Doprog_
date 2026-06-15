--- doprog.zones.doomfire.task_remodeling
---
--- Remodeling (group task 1-6). Source: tbl.eqresource.com/remodeling
--- Giver/turn-in: Unrepentant Sunrise (Doomfire). Request: "remodeling".
---
--- Objectives:
---   1. Fight your way to the throne room. 0/4 -> jopal see-invis, Guardian of
---      Doomfire, 2 snails, General Reparm.
---   2. Deliver 1 Saturated Infused Sandstone Siphon to Fennin Ro. 0/1.
---   3. Open the chest. 0/1.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Remodeling'
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
        S.pickup({ zone = 'doomfire', npc = GIVER, taskName = TASK, request = 'remodeling',
            desc = 'accept Remodeling (say "remodeling")' }),
        S.combat({ zone = 'doomfire', taskName = TASK, objective = 1, target = { npc = true, radius = 1000 },
            desc = 'fight to the throne room: jopal, Guardian of Doomfire, 2 snails, General Reparm' }),
        S.handin({ zone = 'doomfire', npc = FENNIN, taskName = TASK, objective = 2,
            items = { 'Saturated Infused Sandstone Siphon' },
            desc = 'deliver the Saturated Infused Sandstone Siphon to Fennin Ro' }),
        S.click({ zone = 'doomfire', action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
