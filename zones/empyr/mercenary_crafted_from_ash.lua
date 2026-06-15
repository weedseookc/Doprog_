--- doprog.zones.empyr.mercenary_crafted_from_ash
--- Crafted from Ash — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Crafted from Ash',
    type = 'mercenary',
    zone = 'empyr',
    completionTask = 'Crafted from Ash',
    steps = {
        S.pickup({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = 'Crafted from Ash', desc = 'accept Crafted from Ash' }),
        S.combat({ zone = 'empyr', target = { name = 'TODO target', npc = true }, taskName = 'Crafted from Ash', objective = 1, desc = 'Crafted from Ash objective' }),
        S.handin({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = 'Crafted from Ash', desc = 'complete Crafted from Ash' }),
    },
})
