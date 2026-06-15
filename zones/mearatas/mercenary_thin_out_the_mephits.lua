--- doprog.zones.mearatas.mercenary_thin_out_the_mephits
---
--- Thin out the Mephits (solo mercenary). Source: tbl.eqresource.com/thinoutthemephits
--- Giver/turn-in: Emli Widgetton (Mearatas). Request: "nasty".
---   1. Dispatch Mephits 0/6 (random spawns off many zone mobs).
---   2. Return to Emli 0/1.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Thin out the Mephits'
---@type doprog.SpawnQuery
local GIVER = { name = 'Emli Widgetton', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'mearatas',
    completionTask = TASK,
    prereq = { tasks = { 'Enter Mearatas' } },
    steps = {
        S.pickup({ zone = 'mearatas', npc = GIVER, taskName = TASK, request = 'nasty',
            desc = 'accept Thin out the Mephits (say "nasty")' }),
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 1,
            target = { name = 'mephit', npc = true }, desc = 'dispatch 6 Mephits' }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, desc = 'return to Emli' }),
    },
})
