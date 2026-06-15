--- doprog.zones.doomfire.task_delivery
--- Delivery — task quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Delivery',
    type = 'task',
    zone = 'doomfire',
    completionTask = 'Delivery',
    steps = {
        S.pickup({ zone = 'doomfire', npc = { name = 'TODO giver', npc = true }, taskName = 'Delivery', desc = 'accept Delivery' }),
        S.combat({ zone = 'doomfire', target = { name = 'TODO target', npc = true }, taskName = 'Delivery', objective = 1, desc = 'Delivery objective' }),
        S.handin({ zone = 'doomfire', npc = { name = 'TODO giver', npc = true }, taskName = 'Delivery', desc = 'complete Delivery' }),
    },
})
