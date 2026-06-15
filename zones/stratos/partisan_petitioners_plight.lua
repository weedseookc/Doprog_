--- doprog.zones.stratos.partisan_petitioners_plight
--- A Petitioner's Plight — partisan quest, given by Iron Lightning Spirit.
--- TODO(data): NPC /loc coordinates and exact kill target/objective indices.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = 'Iron Lightning Spirit', npc = true }

---@type doprog.Quest
return Quest.new({
    name = "A Petitioner's Plight",
    type = 'partisan',
    zone = 'stratos',
    completionTask = "A Petitioner's Plight",
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = "A Petitioner's Plight", desc = "accept A Petitioner's Plight" }),
        S.combat({ zone = 'stratos', target = { name = 'TODO target', npc = true }, taskName = "A Petitioner's Plight", objective = 1, desc = "A Petitioner's Plight objective" }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = "A Petitioner's Plight", desc = "complete A Petitioner's Plight" }),
    },
})
