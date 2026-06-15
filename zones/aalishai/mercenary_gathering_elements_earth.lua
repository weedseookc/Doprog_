--- doprog.zones.aalishai.mercenary_gathering_elements_earth
--- Gathering Elements - Earth — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Gathering Elements - Earth',
    type = 'mercenary',
    zone = 'aalishai',
    completionTask = 'Gathering Elements - Earth',
    steps = {
        S.pickup({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Gathering Elements - Earth', desc = 'accept Gathering Elements - Earth' }),
        S.combat({ zone = 'aalishai', target = { name = 'TODO target', npc = true }, taskName = 'Gathering Elements - Earth', objective = 1, desc = 'Gathering Elements - Earth objective' }),
        S.handin({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Gathering Elements - Earth', desc = 'complete Gathering Elements - Earth' }),
    },
})
