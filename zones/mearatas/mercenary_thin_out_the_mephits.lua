--- doprog.zones.mearatas.mercenary_thin_out_the_mephits
--- Thin out the Mephits — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Thin out the Mephits',
    type = 'mercenary',
    zone = 'mearatas',
    completionTask = 'Thin out the Mephits',
    steps = {
        S.pickup({ zone = 'mearatas', npc = { name = 'TODO giver', npc = true }, taskName = 'Thin out the Mephits', desc = 'accept Thin out the Mephits' }),
        S.combat({ zone = 'mearatas', target = { name = 'TODO target', npc = true }, taskName = 'Thin out the Mephits', objective = 1, desc = 'Thin out the Mephits objective' }),
        S.handin({ zone = 'mearatas', npc = { name = 'TODO giver', npc = true }, taskName = 'Thin out the Mephits', desc = 'complete Thin out the Mephits' }),
    },
})
