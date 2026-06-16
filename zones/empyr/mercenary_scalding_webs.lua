--- doprog.zones.empyr.mercenary_scalding_webs
---
--- Scalding Webs We Weave (solo mercenary). Source:
--- tbl.eqresource.com/scaldingwebsweweave
--- Giver: Charred Forest (Empyr: Realms of Ash). Request: "giant lava spiders".
--- Single objective: Kill Giant Lava Spiders 0/5 (Northern Middle area). The
--- page lists no item turn-in, so the task completes on the final kill.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Scalding Webs We Weave'
---@type doprog.SpawnQuery
local GIVER = { name = 'Charred Forest', npc = true }
local SPIDER = { name = 'Giant Lava Spider', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'empyr',
    completionTask = TASK,
    prereq = { tasks = { 'Soldier of Air', 'Fight Fire', 'Trial of Three' } },
    steps = {
        S.pickup({ zone = 'empyr', npc = GIVER, taskName = TASK, request = 'giant lava spiders',
            desc = 'accept Scalding Webs We Weave (hail Charred Forest, say "giant lava spiders")' }),
        -- 1: kill 5 Giant Lava Spiders in the Northern Middle area; gated on obj 1.
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1, target = SPIDER,
            desc = 'kill 5 Giant Lava Spiders (Northern Middle area)' }),
    },
})
