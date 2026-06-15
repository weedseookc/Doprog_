--- doprog.zones.esianti.mercenary_armor_of_acrophobia
--- Armor of Acrophobia — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Armor of Acrophobia',
    type = 'mercenary',
    zone = 'esianti',
    completionTask = 'Armor of Acrophobia',
    steps = {
        S.pickup({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Armor of Acrophobia', desc = 'accept Armor of Acrophobia' }),
        S.combat({ zone = 'esianti', target = { name = 'TODO target', npc = true }, taskName = 'Armor of Acrophobia', objective = 1, desc = 'Armor of Acrophobia objective' }),
        S.handin({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Armor of Acrophobia', desc = 'complete Armor of Acrophobia' }),
    },
})
