--- doprog.zones.mearatas.mercenary_free_the_wardens
--- Free the Wardens — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Free the Wardens',
    type = 'mercenary',
    zone = 'mearatas',
    completionTask = 'Free the Wardens',
    steps = {
        S.pickup({ zone = 'mearatas', npc = { name = 'TODO giver', npc = true }, taskName = 'Free the Wardens', desc = 'accept Free the Wardens' }),
        S.combat({ zone = 'mearatas', target = { name = 'TODO target', npc = true }, taskName = 'Free the Wardens', objective = 1, desc = 'Free the Wardens objective' }),
        S.handin({ zone = 'mearatas', npc = { name = 'TODO giver', npc = true }, taskName = 'Free the Wardens', desc = 'complete Free the Wardens' }),
    },
})
