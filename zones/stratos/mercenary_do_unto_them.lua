--- doprog.zones.stratos.mercenary_do_unto_them
--- Do Unto Them — mercenary quest, given by Ashen Wandering Horizon.
--- TODO(data): NPC /loc coordinates and exact kill target/objective indices.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = 'Ashen Wandering Horizon', npc = true }

---@type doprog.Quest
return Quest.new({
    name = 'Do Unto Them',
    type = 'mercenary',
    zone = 'stratos',
    completionTask = 'Do Unto Them',
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = 'Do Unto Them', desc = 'accept Do Unto Them from Ashen Wandering Horizon' }),
        S.combat({ zone = 'stratos', target = { name = 'TODO target', npc = true }, taskName = 'Do Unto Them', objective = 1, desc = 'Do Unto Them objective' }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = 'Do Unto Them', desc = 'complete Do Unto Them' }),
    },
})
