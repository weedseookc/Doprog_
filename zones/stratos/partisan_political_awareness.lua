--- doprog.zones.stratos.partisan_political_awareness
--- Political Awareness — partisan quest, given by Rianar Gadliun.
--- TODO(data): NPC /loc coordinates and exact kill target/objective indices.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = 'Rianar Gadliun', npc = true }

---@type doprog.Quest
return Quest.new({
    name = 'Political Awareness',
    type = 'partisan',
    zone = 'stratos',
    completionTask = 'Political Awareness',
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = 'Political Awareness', desc = 'accept Political Awareness from Rianar Gadliun' }),
        S.combat({ zone = 'stratos', target = { name = 'TODO target', npc = true }, taskName = 'Political Awareness', objective = 1, desc = 'Political Awareness objective' }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = 'Political Awareness', desc = 'complete Political Awareness' }),
    },
})
