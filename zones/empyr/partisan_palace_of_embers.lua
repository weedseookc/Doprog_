--- doprog.zones.empyr.partisan_palace_of_embers
---
--- Palace of Embers (partisan task).
--- Source: https://tbl.eqresource.com/palaceofembers.php
--- Giver/turn-in: Great Sky Ocean (Stratos: Zephyr's Flight). Request: "news".
--- Prereqs: Soldier of Air, Fight Fire, any Trials of Smoke, Prisoner's Dilemma.
--- 30-minute lockout, repeatable. Reward: ~354pp. Spans Empyr and Aalishai.
---
--- Objectives (in order):
---   1. Force access to Aalishai (Empyr). 0/1 -> kill spiders until the named
---      "Flame Consuming Hand" spawns; it de-aggros at ~10%, then say "KILL YOU".
---   2. Force access to the palace (Aalishai). 0/1 -> kill water/fire/air/earth
---      elementals until an ambassador spawns, bring it to ~10%, then say "entry".
---      Ambassadors: All Consuming Sound (water), Descending Light's Laughter
---      (earth), Warrior's Flowing Mind (fire).
---   3. Kill the ambassador to stop him reporting. 0/1 -> nasty fire DoTs and can
---      mez tanks, and he despawns if the fight runs long.
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

-- The three possible ambassadors share no common name substring, so resolve
-- whichever one is currently up (used by the kill step's dynamic target).
local AMBASSADORS = { 'All Consuming Sound', 'Descending Light', 'Warrior\'s Flowing Mind' }
---@param ctx doprog.StepContext
---@return doprog.SpawnQuery|false
local function ambassador(ctx)
    for _, n in ipairs(AMBASSADORS) do
        if ctx.mq:findSpawn({ name = n, npc = true }) then return { name = n, npc = true } end
    end
    return false -- not spawned yet: keep killing elementals / waiting
end

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'empyr',
    completionTask = TASK,
    prereq = { tasks = { 'Soldier of Air', 'Fight Fire', 'Trial of Three', "Prisoner's Dilemma" } },
    steps = {
        S.pickup({ zone = 'stratos', npc = OCEAN, taskName = TASK, request = 'news',
            desc = 'accept Palace of Embers (say "news")' }),
        -- 1: kill spiders to spawn Flame Consuming Hand, take it to ~10%, then say
        -- the trigger phrase to force access to Aalishai (objective-gated).
        S.combat({ zone = 'empyr', target = { name = 'spider', npc = true },
            desc = 'kill spiders until Flame Consuming Hand spawns' }),
        S.combat({ zone = 'empyr', target = FLAME_HAND,
            desc = 'bring Flame Consuming Hand to ~10% (it de-aggros there)' }),
        S.click({ zone = 'empyr', npc = FLAME_HAND, action = '/say KILL YOU',
            condition = objDone(1), desc = 'say "KILL YOU" to force Aalishai access (obj 1)' }),
        -- 2: in Aalishai, kill elementals to spawn an ambassador, take it to ~10%,
        -- then say "entry". The say step targets whichever ambassador is up.
        S.combat({ zone = 'aalishai', target = { name = 'elemental', npc = true },
            desc = 'kill water/fire/air/earth elementals until an ambassador spawns' }),
        S.combat({ zone = 'aalishai', target = ambassador,
            desc = 'bring the spawned ambassador to ~10%' }),
        S.click({ zone = 'aalishai', npc = { name = 'Consuming', npc = true }, action = '/say entry',
            condition = objDone(2), desc = 'say "entry" to the ambassador at ~10% (obj 2)' }),
        -- 3: kill the ambassador before he reports (fire DoTs / mez; despawns if
        -- the fight is slow). doprog targets whichever ambassador is up.
        S.combat({ zone = 'aalishai', taskName = TASK, objective = 3, target = ambassador,
            desc = 'kill the ambassador before he reports (obj 3)' }),
        -- 4: return the Challenge to Great Sky Ocean in Stratos (objective-gated).
        S.handin({ zone = 'stratos', npc = OCEAN, taskName = TASK, objective = 4,
            items = { 'Challenge' }, desc = 'return the Challenge to Great Sky Ocean (obj 4)' }),
    },
})
