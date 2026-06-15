--- doprog.zones.aalishai.mercenary_gathering_elements_earth
---
--- Gathering Elements: Earth (solo mercenary). Source:
--- tbl.eqresource.com/gatheringelementsearth
--- Giver/turn-in: Everna Delestrod (Aalishai). Request: "take advantage".
---   Deliver 10 Essence of Elemental Earth 0/10 -> kill Earth mobs (Eastern
---   section), then turn the 10 essences in.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Gathering Elements: Earth'
local ESSENCE = 'Essence of Elemental Earth'
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
            desc = 'accept Gathering Elements: Earth (say "take advantage")' }),
        S.combat({ zone = 'aalishai', target = { name = 'earth', npc = true },
            untilItem = ESSENCE, untilCount = 10,
            desc = 'kill Earth mobs (East) until 10 Essence of Elemental Earth' }),
        S.handin({ zone = 'aalishai', npc = GIVER, taskName = TASK, objective = 1,
            items = { ESSENCE }, desc = 'deliver 10 Essence of Elemental Earth to Everna Delestrod' }),
    },
})
