--- doprog.zones.mearatas.mercenary_lost_missives
---
--- Lost Missives (solo mercenary task).
--- Source: https://tbl.eqresource.com/lostmissives.php
--- Giver/turn-in: Emli Widgetton (Mearatas: The Stone Demesne). Request:
--- "messengers". Repeatable, 30-minute lockout, no time limit. Achievement:
--- Mercenary of Mearatas: The Stone Demesne.
---
--- Objectives (in order):
---   1. Kill Envoys 0/6 (envoys are found throughout the zone; doprog targets each
---      envoy as it is located).
---   2. Return to Emli 0/1 (return to and Hail Emli Widgetton).

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Lost Missives'
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
        S.pickup({ zone = 'mearatas', npc = GIVER, taskName = TASK, request = 'messengers',
            desc = 'accept Lost Missives from Emli Widgetton (say "messengers")' }),
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 1,
            target = { name = 'envoy', npc = true },
            desc = 'Kill Envoys 0/6 (found throughout the zone)' }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 2,
            desc = 'Return to Emli 0/1 (Hail Emli Widgetton)' }),
    },
})
