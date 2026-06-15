--- doprog.zones.doomfire.task_strange_magic
--- Strange Magic — task quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Strange Magic',
    type = 'task',
    zone = 'doomfire',
    completionTask = 'Strange Magic',
    steps = {
        S.pickup({ zone = 'doomfire', npc = { name = 'TODO giver', npc = true }, taskName = 'Strange Magic', desc = 'accept Strange Magic' }),
        S.combat({ zone = 'doomfire', target = { name = 'TODO target', npc = true }, taskName = 'Strange Magic', objective = 1, desc = 'Strange Magic objective' }),
        S.handin({ zone = 'doomfire', npc = { name = 'TODO giver', npc = true }, taskName = 'Strange Magic', desc = 'complete Strange Magic' }),
    },
})
