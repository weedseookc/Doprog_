--- doprog.zones.aalishai.partisan_enter_mearatas
--- Enter Mearatas — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Enter Mearatas',
    type = 'partisan',
    zone = 'aalishai',
    completionTask = 'Enter Mearatas',
    steps = {
        S.pickup({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Enter Mearatas', desc = 'accept Enter Mearatas' }),
        S.combat({ zone = 'aalishai', target = { name = 'TODO target', npc = true }, taskName = 'Enter Mearatas', objective = 1, desc = 'Enter Mearatas objective' }),
        S.handin({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Enter Mearatas', desc = 'complete Enter Mearatas' }),
    },
})
