--- doprog.zones.empyr.mercenary_crafted_from_ash
---
--- Crafted from Ash (solo mercenary). Source: tbl.eqresource.com/craftedfromash
--- Giver: Charred Forest (Empyr: Realms of Ash). Request: "slag golems".
--- Single objective: Kill Slag Golems 0/3. Walkthrough: golems are found
--- throughout the zone, and defeating flamelings and fires on the East side
--- spawns more of them. No item turn-in is published, so the task completes on
--- the final golem kill.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Crafted from Ash'
---@type doprog.SpawnQuery
local GIVER = { name = 'Charred Forest', npc = true }
local GOLEM = { name = 'Slag Golem', npc = true }
-- Defeating flamelings/fires (East side) spawns Slag Golems when none are up.
local SPAWNERS = { name = 'flameling', npc = true, exclude = { 'Slag' } }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'empyr',
    completionTask = TASK,
    prereq = { tasks = { 'Soldier of Air', 'Fight Fire', 'Trial of Three' } },
    steps = {
        S.pickup({ zone = 'empyr', npc = GIVER, taskName = TASK, request = 'slag golems',
            desc = 'accept Crafted from Ash (hail Charred Forest, say "slag golems")' }),
        -- Seed golems on the East side: clear flamelings/fires only while none are up.
        S.combat({ zone = 'empyr', target = function(ctx)
                if ctx.mq:findSpawn(GOLEM) then return nil end
                return SPAWNERS
            end,
            desc = 'kill flamelings/fires (East side) to spawn Slag Golems' }),
        -- 1: kill 3 Slag Golems; gated on objective 1.
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1, target = GOLEM,
            desc = 'kill 3 Slag Golems' }),
    },
})
