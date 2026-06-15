--- doprog.zones.doomfire.task_remodeling
--- Remodeling — task quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Remodeling',
    type = 'task',
    zone = 'doomfire',
    completionTask = 'Remodeling',
    steps = {
        S.pickup({ zone = 'doomfire', npc = { name = 'TODO giver', npc = true }, taskName = 'Remodeling', desc = 'accept Remodeling' }),
        S.combat({ zone = 'doomfire', target = { name = 'TODO target', npc = true }, taskName = 'Remodeling', objective = 1, desc = 'Remodeling objective' }),
        S.handin({ zone = 'doomfire', npc = { name = 'TODO giver', npc = true }, taskName = 'Remodeling', desc = 'complete Remodeling' }),
    },
})
