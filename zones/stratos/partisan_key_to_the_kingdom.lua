--- doprog.zones.stratos.partisan_key_to_the_kingdom
--- Key to the Kingdom — partisan quest, given by Dusky Iron Meditation.
--- TODO(data): NPC /loc coordinates and exact kill target/objective indices.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = 'Dusky Iron Meditation', npc = true }

---@type doprog.Quest
return Quest.new({
    name = 'Key to the Kingdom',
    type = 'partisan',
    zone = 'stratos',
    completionTask = 'Key to the Kingdom',
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = 'Key to the Kingdom', desc = 'accept Key to the Kingdom from Dusky Iron Meditation' }),
        S.combat({ zone = 'stratos', target = { name = 'TODO target', npc = true }, taskName = 'Key to the Kingdom', objective = 1, desc = 'Key to the Kingdom objective' }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = 'Key to the Kingdom', desc = 'complete Key to the Kingdom' }),
    },
})
