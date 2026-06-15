--- doprog.zones.empyr.partisan_fire_and_fury
--- Fire and Fury — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Fire and Fury',
    type = 'partisan',
    zone = 'empyr',
    completionTask = 'Fire and Fury',
    steps = {
        S.pickup({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = 'Fire and Fury', desc = 'accept Fire and Fury' }),
        S.combat({ zone = 'empyr', target = { name = 'TODO target', npc = true }, taskName = 'Fire and Fury', objective = 1, desc = 'Fire and Fury objective' }),
        S.handin({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = 'Fire and Fury', desc = 'complete Fire and Fury' }),
    },
})
