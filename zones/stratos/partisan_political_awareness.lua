--- doprog.zones.stratos.partisan_political_awareness
---
--- Political Awareness (group task 1-6). Source:
--- tbl.eqresource.com/politicalawareness
--- Giver/turn-in: Rianar Gadliun (Stratos: Zephyr's Flight). Request: "guess".
--- A say-phrase puzzle with one combat objective; each say-step fires its phrase
--- (against a targeted citizen NPC) and is gated on the matching task objective
--- ticking over. Per player comments an objective only updates once the prior
--- stage's text has been received, so the steps are strictly ordered.
---
--- Objectives:
---   1. Discover history of djinn leadership. 0/1 -> hail dervishes/djinn/mephits
---      in the PoT half of the zone until one gives text.
---   2. Discover how rulership changes in Esianti. 0/1
---      -> say "what about wind of the shining void" near the Great Sky Ocean.
---   3. Find out what the citizens think. 0/1  (phrase not published on
---      eqresource; it updates alongside the rulership says, so gate on obj 3.)
---   4. Some citizens do not care. 0/1
---      -> say "what about moon serf of the harmonious heavens".
---   5. Defeat the angry elementals. 0/3
---      -> say "what about the current rulership" to spawn 3, then defeat them.
---   6. Report to Rianar. 0/1 -> hail.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Political Awareness'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local GIVER = { name = 'Rianar Gadliun', npc = true }
---@type doprog.SpawnQuery
local OCEAN = { name = 'Great Sky Ocean', npc = true }
-- Citizens to hail for obj 1: dervishes, djinn, mephits in the PoT half.
---@type doprog.SpawnQuery
local CITIZEN = { name = 'dervish', npc = true }
---@type doprog.SpawnQuery
local ELEMENTAL = { name = 'angry', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'stratos',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = TASK, request = 'guess',
            desc = 'accept Political Awareness (say "guess")' }),
        -- 1: hail a citizen NPC near the PoT zone line until the text updates.
        S.click({ zone = 'stratos', npc = CITIZEN, action = '/say Hail',
            condition = objDone(1), desc = 'hail dervishes/djinn/mephits for djinn history (obj 1)' }),
        -- 2: rulership-change phrase to the Great Sky Ocean.
        S.click({ zone = 'stratos', npc = OCEAN, action = '/say what about wind of the shining void',
            condition = objDone(2), desc = 'say rulership-change phrase (obj 2)' }),
        -- 3: citizens' opinion updates alongside the void/serf says; gate on obj 3.
        S.click({ zone = 'stratos', npc = OCEAN, action = '/say what about wind of the shining void',
            condition = objDone(3), desc = 'learn what the citizens think (obj 3)' }),
        -- 4: moon-serf phrase ("some citizens do not care").
        S.click({ zone = 'stratos', npc = OCEAN, action = '/say what about moon serf of the harmonious heavens',
            condition = objDone(4), desc = 'say moon-serf phrase (obj 4)' }),
        -- 5a: rulership phrase spawns 3 angry elementals that aggro.
        S.click({ zone = 'stratos', npc = OCEAN, action = '/say what about the current rulership',
            condition = function(ctx)
                return ctx.mq:findSpawn(ELEMENTAL) ~= nil or ctx.task:objectiveDone(TASK, 5)
            end,
            desc = 'spawn the 3 angry elementals (obj 5)' }),
        -- 5b: defeat the 3 spawned elementals (host kills; doprog targets named mob).
        S.combat({ zone = 'stratos', taskName = TASK, objective = 5, target = ELEMENTAL,
            desc = 'defeat 3 angry elementals' }),
        -- 6: report back.
        S.handin({ zone = 'stratos', npc = GIVER, taskName = TASK,
            desc = 'report to Rianar Gadliun to finish' }),
    },
})
