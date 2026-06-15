--- doprog.zones.aalishai.partisan_fragmented_coterie
--- Fragmented Coterie — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Fragmented Coterie',
    type = 'partisan',
    zone = 'aalishai',
    completionTask = 'Fragmented Coterie',
    steps = {
        S.pickup({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Fragmented Coterie', desc = 'accept Fragmented Coterie' }),
        S.combat({ zone = 'aalishai', target = { name = 'TODO target', npc = true }, taskName = 'Fragmented Coterie', objective = 1, desc = 'Fragmented Coterie objective' }),
        S.handin({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Fragmented Coterie', desc = 'complete Fragmented Coterie' }),
    },
})
