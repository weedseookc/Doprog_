--- doprog.zones.esianti.partisan_all_hail_the_king
--- All Hail the King — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'All Hail the King',
    type = 'partisan',
    zone = 'esianti',
    completionTask = 'All Hail the King',
    steps = {
        S.pickup({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'All Hail the King', desc = 'accept All Hail the King' }),
        S.combat({ zone = 'esianti', target = { name = 'TODO target', npc = true }, taskName = 'All Hail the King', objective = 1, desc = 'All Hail the King objective' }),
        S.handin({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'All Hail the King', desc = 'complete All Hail the King' }),
    },
})
