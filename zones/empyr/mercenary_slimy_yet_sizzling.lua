--- doprog.zones.empyr.mercenary_slimy_yet_sizzling
--- Slimy, Yet Sizzling — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Slimy, Yet Sizzling',
    type = 'mercenary',
    zone = 'empyr',
    completionTask = 'Slimy, Yet Sizzling',
    steps = {
        S.pickup({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = 'Slimy, Yet Sizzling', desc = 'accept Slimy, Yet Sizzling' }),
        S.combat({ zone = 'empyr', target = { name = 'TODO target', npc = true }, taskName = 'Slimy, Yet Sizzling', objective = 1, desc = 'Slimy, Yet Sizzling objective' }),
        S.handin({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = 'Slimy, Yet Sizzling', desc = 'complete Slimy, Yet Sizzling' }),
    },
})
