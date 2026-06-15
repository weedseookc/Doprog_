--- doprog.zones.empyr.partisan_palace_of_embers
--- Palace of Embers — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Palace of Embers',
    type = 'partisan',
    zone = 'empyr',
    completionTask = 'Palace of Embers',
    steps = {
        S.pickup({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = 'Palace of Embers', desc = 'accept Palace of Embers' }),
        S.combat({ zone = 'empyr', target = { name = 'TODO target', npc = true }, taskName = 'Palace of Embers', objective = 1, desc = 'Palace of Embers objective' }),
        S.handin({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = 'Palace of Embers', desc = 'complete Palace of Embers' }),
    },
})
