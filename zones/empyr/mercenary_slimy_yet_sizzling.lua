--- doprog.zones.empyr.mercenary_slimy_yet_sizzling
---
--- Slimy, Yet Sizzling (solo mercenary).
--- Source: https://tbl.eqresource.com/slimyyetsizzling.php
--- Giver: Charred Forest (Empyr: Realms of Ash). Request: "snails".
--- Solo, unlimited time, 30-minute lockout, repeatable.
--- Prereqs: Soldier of Air, Fight Fire, any Trial of Smoke.
---
--- Objectives (in order):
---   1. Kill Fire Snails or Flame Snails 0/4 (Empyr: Realms of Ash) — the snails
---      are found throughout the Eastern and Southern parts of the zone. This is
---      an auto-complete kill objective: no turn-in NPC is published, the task
---      closes when the counter reaches 4.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Slimy, Yet Sizzling'
---@type doprog.SpawnQuery
local GIVER = { name = 'Charred Forest', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'empyr',
    completionTask = TASK,
    prereq = { tasks = { 'Soldier of Air', 'Fight Fire', 'Trial of Three' } },
    steps = {
        -- Accept the task by hailing Charred Forest and saying the offer keyword.
        S.pickup({ zone = 'empyr', npc = GIVER, taskName = TASK, request = 'snails',
            desc = 'accept Slimy, Yet Sizzling (say "snails")' }),
        -- 1: kill 4 Fire/Flame Snails (East and South of the zone). Objective-gated
        -- so the host only fights snails that count toward the counter.
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1,
            target = { name = 'Snail', npc = true },
            desc = 'kill 4 Fire/Flame Snails (Eastern and Southern areas)' }),
    },
})
