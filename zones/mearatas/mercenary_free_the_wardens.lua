--- doprog.zones.mearatas.mercenary_free_the_wardens
---
--- Free the Wardens (solo mercenary task).
--- Source: https://tbl.eqresource.com/freethewardens.php
--- Giver/turn-in: Emli Widgetton (Mearatas: The Stone Demesne). Request:
--- "servitude". Repeatable, 30-minute lockout. Achievement: Mercenary of
--- Mearatas: The Stone Demesne.
---
--- Objectives (in order):
---   1. Destroy the jann's wardens to free the elementals 0/6 (wardens are found
---      throughout the zone; doprog targets each warden as it is located).
---   2. Return to Emli 0/1 (return to and Hail Emli Widgetton at her marked spot).

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
    prereq = { tasks = { 'Enter Mearatas', 'Serving Another Master' } },
    steps = {
        S.pickup({ zone = 'mearatas', npc = GIVER, taskName = TASK, request = 'servitude',
            desc = 'accept Free the Wardens from Emli Widgetton (say "servitude")' }),
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 1,
            target = { name = 'warden', npc = true },
            desc = "Destroy the jann's wardens 0/6 (found throughout the zone)" }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 2,
            desc = 'Return to Emli 0/1 (Hail Emli Widgetton)' }),
    },
})
