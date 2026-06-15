--- doprog.zones.mearatas.mercenary_lost_missives
--- Lost Missives — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Lost Missives',
    type = 'mercenary',
    zone = 'mearatas',
    completionTask = 'Lost Missives',
    steps = {
        S.pickup({ zone = 'mearatas', npc = { name = 'TODO giver', npc = true }, taskName = 'Lost Missives', desc = 'accept Lost Missives' }),
        S.combat({ zone = 'mearatas', target = { name = 'TODO target', npc = true }, taskName = 'Lost Missives', objective = 1, desc = 'Lost Missives objective' }),
        S.handin({ zone = 'mearatas', npc = { name = 'TODO giver', npc = true }, taskName = 'Lost Missives', desc = 'complete Lost Missives' }),
    },
})
