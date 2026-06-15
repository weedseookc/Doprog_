--- doprog.zones.aalishai.partisan_royal_visits
--- Royal Visits — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Royal Visits',
    type = 'partisan',
    zone = 'aalishai',
    completionTask = 'Royal Visits',
    steps = {
        S.pickup({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Royal Visits', desc = 'accept Royal Visits' }),
        S.combat({ zone = 'aalishai', target = { name = 'TODO target', npc = true }, taskName = 'Royal Visits', objective = 1, desc = 'Royal Visits objective' }),
        S.handin({ zone = 'aalishai', npc = { name = 'TODO giver', npc = true }, taskName = 'Royal Visits', desc = 'complete Royal Visits' }),
    },
})
