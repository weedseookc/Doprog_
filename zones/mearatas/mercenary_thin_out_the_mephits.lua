--- doprog.zones.mearatas.mercenary_thin_out_the_mephits
---
--- Thin out the Mephits (solo mercenary task).
--- Source: https://tbl.eqresource.com/thinoutthemephits.php
--- Giver/turn-in: Emli Widgetton (Mearatas: The Stone Demesne). Request: "nasty".
--- Repeatable, 30-minute lockout, no time limit. Achievement: Mercenary of
--- Mearatas: The Stone Demesne.
---
--- Objectives (in order):
---   1. Dispatch Mephits 0/6 (mephits are random spawns off many zone mobs, so
---      there is no fixed camp — doprog targets each mephit as it appears).
---   2. Return to Emli 0/1 (return to and Hail Emli Widgetton).

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
    prereq = { tasks = { 'Enter Mearatas', 'Serving Another Master' } },
    steps = {
        S.pickup({ zone = 'mearatas', npc = GIVER, taskName = TASK, request = 'nasty',
            desc = 'accept Thin out the Mephits from Emli Widgetton (say "nasty")' }),
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 1,
            target = { name = 'mephit', npc = true },
            desc = 'Dispatch Mephits 0/6 (random spawns throughout the zone)' }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 2,
            desc = 'Return to Emli 0/1 (Hail Emli Widgetton)' }),
    },
})
