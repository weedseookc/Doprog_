--- doprog.zones.stratos.partisan_key_to_the_kingdom
---
--- Key to the Kingdom (partisan). Source: tbl.eqresource.com/keytothekingdom
--- Giver/turn-in: Dusky Iron Meditation (Stratos: Zephyr's Flight). Request:
--- "accept". A long item chain. Prereqs (per the page) span later tiers, so the
--- registry will only surface this once they are complete.
---
--- Objectives:
---   1. Find Unfettered Stone -> grab ground spawn "Pile of Rubble" (a known spot
---      is ~ /loc 129, -335 in Stratos).
---   2. Return the remains -> give Pile of Rubble to Dusky Iron Meditation.
---   3. Find out how he died -> kill an upset dervish / hidden mephit /
---      languishing courier to spawn a furtive mob (or confused mud elemental),
---      defeat it, and loot "Gemstone Heart".
---   4. Return the gemstone heart -> give Gemstone Heart to Dusky (receive Clear Gemstone).
---   5. Convince an Udex -> give Clear Gemstone to an Udex (receive Warrant).
---   6. Give the warrant stone -> give Warrant to Dusky.
---   7. Speak with Dusky Iron Meditation -> hail.
---   8. Tell Great Sky Ocean you have the key -> hail Great Sky Ocean.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Key to the Kingdom'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local DUSKY = { name = 'Dusky Iron Meditation', npc = true }
---@type doprog.SpawnQuery
local UDEX = { name = 'Udex', npc = true }
---@type doprog.SpawnQuery
local OCEAN = { name = 'Great Sky Ocean', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'stratos',
    completionTask = TASK,
    prereq = { tasks = {
        'Soldier of Air', 'Fight Fire', 'Trial of Three',
        "Prisoner's Dilemma", 'Palace of Embers', 'Brass Palace',
    } },
    steps = {
        S.pickup({ zone = 'stratos', npc = DUSKY, taskName = TASK, request = 'accept',
            desc = 'accept Key to the Kingdom (say "accept")' }),
        -- 1: grab the Pile of Rubble ground spawn.
        S.click({ zone = 'stratos', loc = { y = 129, x = -335 },
            action = '/multiline ; /itemtarget Pile of Rubble ; /click left item',
            condition = objDone(1), desc = 'loot ground spawn "Pile of Rubble" (obj 1)' }),
        -- 2: return remains.
        S.handin({ zone = 'stratos', npc = DUSKY, taskName = TASK, objective = 2,
            items = { 'Pile of Rubble' }, desc = 'give Pile of Rubble to Dusky' }),
        -- 3: kill a trigger mob to spawn the furtive mob, defeat it, loot heart.
        S.combat({ zone = 'stratos', taskName = TASK, objective = 3,
            desc = 'kill upset dervish/hidden mephit/languishing courier -> defeat the furtive mob' }),
        S.loot({ zone = 'stratos', item = 'Gemstone Heart', desc = 'loot Gemstone Heart' }),
        -- 4: return heart (receive Clear Gemstone).
        S.handin({ zone = 'stratos', npc = DUSKY, taskName = TASK, objective = 4,
            items = { 'Gemstone Heart' }, desc = 'give Gemstone Heart to Dusky' }),
        -- 5: convince an Udex (receive Warrant).
        S.handin({ zone = 'stratos', npc = UDEX, taskName = TASK, objective = 5,
            items = { 'Clear Gemstone' }, desc = 'give Clear Gemstone to an Udex' }),
        -- 6: give the warrant to Dusky.
        S.handin({ zone = 'stratos', npc = DUSKY, taskName = TASK, objective = 6,
            items = { 'Warrant' }, desc = 'give Warrant to Dusky' }),
        -- 7: speak with Dusky.
        S.handin({ zone = 'stratos', npc = DUSKY, taskName = TASK, objective = 7,
            desc = 'speak with Dusky Iron Meditation' }),
        -- 8: tell Great Sky Ocean.
        S.handin({ zone = 'stratos', npc = OCEAN, taskName = TASK,
            desc = 'tell Great Sky Ocean you have the key' }),
    },
})
