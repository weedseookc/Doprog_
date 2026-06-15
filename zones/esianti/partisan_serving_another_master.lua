--- doprog.zones.esianti.partisan_serving_another_master
--- Serving Another Master — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Serving Another Master',
    type = 'partisan',
    zone = 'esianti',
    completionTask = 'Serving Another Master',
    steps = {
        S.pickup({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Serving Another Master', desc = 'accept Serving Another Master' }),
        S.combat({ zone = 'esianti', target = { name = 'TODO target', npc = true }, taskName = 'Serving Another Master', objective = 1, desc = 'Serving Another Master objective' }),
        S.handin({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Serving Another Master', desc = 'complete Serving Another Master' }),
    },
})
