--- doprog.zones.aalishai.mercenary_gathering_elements_air
---
--- Gathering Elements: Air (solo mercenary). Source:
--- tbl.eqresource.com/gatheringelementsair
--- Giver/turn-in: Everna Delestrod (Aalishai). Request: "take advantage" (the
--- three Gathering tasks share this phrase; pick Air from the task offer).
---   Deliver 10 Essence of Elemental Air 0/10 -> kill Air mobs (Northern section;
---   drop is rareish), then turn the 10 essences in.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Gathering Elements: Air'
local ESSENCE = 'Essence of Elemental Air'
---@type doprog.SpawnQuery
local GIVER = { name = 'Everna Delestrod', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'aalishai',
    completionTask = TASK,
    prereq = { tasks = { "Prisoner's Dilemma", 'Palace of Embers' } },
    steps = {
        S.pickup({ zone = 'aalishai', npc = GIVER, taskName = TASK, request = 'take advantage',
            desc = 'accept Gathering Elements: Air (say "take advantage")' }),
        S.combat({ zone = 'aalishai', target = { name = 'air', npc = true },
            untilItem = ESSENCE, untilCount = 10,
            desc = 'kill Air mobs (North) until 10 Essence of Elemental Air' }),
        S.handin({ zone = 'aalishai', npc = GIVER, taskName = TASK, objective = 1,
            items = { ESSENCE }, desc = 'deliver 10 Essence of Elemental Air to Everna Delestrod' }),
    },
})
