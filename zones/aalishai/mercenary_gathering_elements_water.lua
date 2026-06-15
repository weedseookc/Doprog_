--- doprog.zones.aalishai.mercenary_gathering_elements_water
--- Gathering Elements - Water — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Gathering Elements - Water',
    type = 'mercenary',
    zone = 'aalishai',
    completionTask = 'Gathering Elements - Water',
    steps = {
        S.pickup({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Gathering Elements - Water', desc = 'accept Gathering Elements - Water' }),
        S.combat({ zone = 'aalishai', target = { name = 'TODO target', npc = true }, taskName = 'Gathering Elements - Water', objective = 1, desc = 'Gathering Elements - Water objective' }),
        S.handin({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Gathering Elements - Water', desc = 'complete Gathering Elements - Water' }),
    },
})
