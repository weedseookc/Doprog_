--- doprog.zones.empyr.partisan_palace_of_embers
---
--- Palace of Embers (group task). Source: tbl.eqresource.com/palaceofembers
--- Giver/turn-in: Great Sky Ocean (Stratos). Request: "news". Objectives span
--- Empyr and Aalishai.
---
--- Objectives:
---   1. Force access to Aalishai (Empyr). 0/1 -> kill spiders until the named
---      "Flame Consuming Hand" spawns; bring it to 10%, then say "KILL YOU".
---   2. Force access to the palace (Aalishai). 0/1 -> kill elementals until a
---      named ambassador spawns (water: All Consuming Sound; earth: Descending
---      Light's Laughter; fire: Warrior's Flowing Mind); at 10% say "entry".
---      (South side of the pool is the reliable spawn.)
---   3. Kill the ambassador to stop him reporting. 0/1.
---   4. Return the Challenge to Great Sky Ocean (Stratos). 0/1.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Palace of Embers'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local OCEAN = { name = 'Great Sky Ocean', npc = true }
local FLAME_HAND = { name = 'Flame Consuming Hand', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'empyr',
    completionTask = TASK,
    prereq = { tasks = { "Prisoner's Dilemma" } },
    steps = {
        S.pickup({ zone = 'stratos', npc = OCEAN, taskName = TASK, request = 'news',
            desc = 'accept Palace of Embers (say "news")' }),
        -- 1: spawn Flame Consuming Hand via spiders, take it to 10%, say KILL YOU.
        S.combat({ zone = 'empyr', target = { name = 'spider', npc = true },
            desc = 'kill spiders to spawn Flame Consuming Hand' }),
        S.combat({ zone = 'empyr', target = FLAME_HAND,
            desc = 'bring Flame Consuming Hand to ~10%' }),
        S.click({ zone = 'empyr', npc = FLAME_HAND, action = '/say KILL YOU',
            condition = objDone(1), desc = 'say "KILL YOU" to force Aalishai access (obj 1)' }),
        -- 2: in Aalishai, spawn an ambassador via elementals, 10%, say entry.
        S.combat({ zone = 'aalishai', target = { name = 'elemental', npc = true },
            desc = 'kill elementals (south of the pool) to spawn an ambassador' }),
        S.click({ zone = 'aalishai', npc = { name = 'Consuming', npc = true }, action = '/say entry',
            condition = objDone(2), desc = 'say "entry" to the ambassador at ~10% (obj 2)' }),
        -- 3: kill the ambassador.
        S.combat({ zone = 'aalishai', taskName = TASK, objective = 3,
            target = { name = 'Consuming', npc = true },
            desc = 'kill the ambassador before he reports' }),
        -- 4: return the Challenge.
        S.handin({ zone = 'stratos', npc = OCEAN, taskName = TASK, objective = 4,
            items = { 'Challenge' }, desc = 'return the Challenge to Great Sky Ocean' }),
    },
})
