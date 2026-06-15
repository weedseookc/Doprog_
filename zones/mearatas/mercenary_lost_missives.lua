--- doprog.zones.mearatas.mercenary_lost_missives
---
--- Lost Missives (solo mercenary). Source: tbl.eqresource.com/lostmissives
--- Giver/turn-in: Emli Widgetton (Mearatas). Request: "messengers".
---   1. Kill Envoys 0/6 (throughout the zone).
---   2. Return to Emli 0/1.

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
    prereq = { tasks = { 'Enter Mearatas' } },
    steps = {
        S.pickup({ zone = 'mearatas', npc = GIVER, taskName = TASK, request = 'messengers',
            desc = 'accept Lost Missives (say "messengers")' }),
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 1,
            target = { name = 'envoy', npc = true }, desc = 'kill 6 Envoys' }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, desc = 'return to Emli' }),
    },
})
