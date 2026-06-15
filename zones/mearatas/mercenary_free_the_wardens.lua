--- doprog.zones.mearatas.mercenary_free_the_wardens
---
--- Free the Wardens (solo mercenary). Source: tbl.eqresource.com/freethewardens
--- Giver/turn-in: Emli Widgetton (Mearatas). Request: "servitude".
---   1. Destroy the jann's wardens to free the elementals 0/6.
---   2. Return to Emli 0/1.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Free the Wardens'
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
        S.pickup({ zone = 'mearatas', npc = GIVER, taskName = TASK, request = 'servitude',
            desc = 'accept Free the Wardens (say "servitude")' }),
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 1,
            target = { name = 'warden', npc = true }, desc = "destroy 6 jann's wardens" }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, desc = 'return to Emli' }),
    },
})
