--- doprog.zones.aalishai.mercenary_gathering_elements_water
---
--- Gathering Elements: Water (solo mercenary). Source:
--- tbl.eqresource.com/gatheringelementswater
--- Giver/turn-in: Everna Delestrod (Aalishai). Request: "take advantage".
---   Deliver 10 Essence of Elemental Water 0/10 -> kill Water mobs (Southern
---   section), then turn the 10 essences in.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Gathering Elements: Water'
local ESSENCE = 'Essence of Elemental Water'
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
            desc = 'accept Gathering Elements: Water (say "take advantage")' }),
        S.combat({ zone = 'aalishai', target = { name = 'water', npc = true },
            untilItem = ESSENCE, untilCount = 10,
            desc = 'kill Water mobs (South) until 10 Essence of Elemental Water' }),
        S.handin({ zone = 'aalishai', npc = GIVER, taskName = TASK, objective = 1,
            items = { ESSENCE }, desc = 'deliver 10 Essence of Elemental Water to Everna Delestrod' }),
    },
})
