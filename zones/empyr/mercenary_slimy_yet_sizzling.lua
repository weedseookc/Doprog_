--- doprog.zones.empyr.mercenary_slimy_yet_sizzling
---
--- Slimy, Yet Sizzling (solo mercenary). Source: tbl.eqresource.com/slimyyetsizzling
--- Giver/turn-in: Charred Forest (Empyr). Request: "snails".
---   Kill Fire Snails or Flame Snails 0/4 (Eastern and Southern areas).

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
        S.pickup({ zone = 'empyr', npc = GIVER, taskName = TASK, request = 'snails',
            desc = 'accept Slimy, Yet Sizzling (say "snails")' }),
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1,
            target = { name = 'Snail', npc = true },
            desc = 'kill 4 Fire/Flame Snails (East and South)' }),
        S.handin({ zone = 'empyr', npc = GIVER, taskName = TASK, desc = 'return to Charred Forest' }),
    },
})
