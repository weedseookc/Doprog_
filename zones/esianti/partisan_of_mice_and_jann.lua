--- doprog.zones.esianti.partisan_of_mice_and_jann
--- Of Mice and Jann — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Of Mice and Jann',
    type = 'partisan',
    zone = 'esianti',
    completionTask = 'Of Mice and Jann',
    steps = {
        S.pickup({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Of Mice and Jann', desc = 'accept Of Mice and Jann' }),
        S.combat({ zone = 'esianti', target = { name = 'TODO target', npc = true }, taskName = 'Of Mice and Jann', objective = 1, desc = 'Of Mice and Jann objective' }),
        S.handin({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Of Mice and Jann', desc = 'complete Of Mice and Jann' }),
    },
})
