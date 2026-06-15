--- doprog.zones.empyr.mercenary_crafted_from_ash
---
--- Crafted from Ash (solo mercenary). Source: tbl.eqresource.com/craftedfromash
--- Giver/turn-in: Charred Forest (Empyr). Request: "slag golems".
---   Kill Slag Golems 0/3 -> defeat flamelings/fires on the East side to spawn them.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Crafted from Ash'
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
        S.pickup({ zone = 'empyr', npc = GIVER, taskName = TASK, request = 'slag golems',
            desc = 'accept Crafted from Ash (say "slag golems")' }),
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1,
            target = { name = 'Slag Golem', npc = true },
            desc = 'kill 3 Slag Golems (spawn via flamelings/fires, East side)' }),
        S.handin({ zone = 'empyr', npc = GIVER, taskName = TASK, desc = 'return to Charred Forest' }),
    },
})
