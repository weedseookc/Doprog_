--- doprog.zones.empyr.mercenary_scalding_webs
---
--- Scalding Webs We Weave (solo mercenary). Source:
--- tbl.eqresource.com/scaldingwebsweweave
--- Giver/turn-in: Charred Forest (Empyr). Request: "giant lava spiders".
---   Kill Giant Lava Spiders 0/5 (Northern Middle area).

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Scalding Webs We Weave'
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
        S.pickup({ zone = 'empyr', npc = GIVER, taskName = TASK, request = 'giant lava spiders',
            desc = 'accept Scalding Webs We Weave (say "giant lava spiders")' }),
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1,
            target = { name = 'Giant Lava Spider', npc = true },
            desc = 'kill 5 Giant Lava Spiders (N middle)' }),
        S.handin({ zone = 'empyr', npc = GIVER, taskName = TASK, desc = 'return to Charred Forest' }),
    },
})
