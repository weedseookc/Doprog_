--- doprog.zones.stratos.partisan_political_awareness
---
--- Political Awareness (group task 1-6). Source:
--- tbl.eqresource.com/politicalawareness
--- Giver/turn-in: Rianar Gadliun (Stratos: Zephyr's Flight). Request: "guess".
--- A say-phrase puzzle with one combat objective; each say-step fires its phrase
--- and is gated on the matching task objective ticking over.
---
--- Objectives:
---   1. Discover history of djinn leadership. 0/1 -> hail dervishes/djinn/mephits
---      near the PoT zone line.
---   2. Discover how rulership changes in Esianti. 0/1
---      -> say "what about wind of the shining void" near Great Sky Ocean.
---   3. Find out what the citizens think. 0/1  (phrase not published on
---      eqresource; per comments it completes alongside the other says.)
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

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'stratos',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = TASK, request = 'guess',
            desc = 'accept Political Awareness (say "guess")' }),
        S.click({ zone = 'stratos', npc = { name = 'dervish', npc = true },
            action = '/multiline ; /target dervish ; /say Hail', condition = objDone(1),
            desc = 'hail djinn near the PoT zone line (obj 1)' }),
        S.click({ zone = 'stratos', npc = OCEAN, action = '/say what about wind of the shining void',
            condition = objDone(2), desc = 'say rulership-change phrase (obj 2)' }),
        S.click({ zone = 'stratos', npc = OCEAN, action = '/say what about moon serf of the harmonious heavens',
            condition = objDone(4), desc = 'say moon-serf phrase (obj 3/4)' }),
        S.click({ zone = 'stratos', npc = OCEAN, action = '/say what about the current rulership',
            condition = function(ctx)
                return ctx.mq:findSpawn({ name = 'angry', npc = true }) ~= nil
                    or ctx.task:objectiveDone(TASK, 5)
            end,
            desc = 'spawn the angry elementals (obj 5)' }),
        S.combat({ zone = 'stratos', taskName = TASK, objective = 5,
            desc = 'defeat 3 angry elementals' }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = TASK,
            desc = 'report to Rianar Gadliun to finish' }),
    },
})
