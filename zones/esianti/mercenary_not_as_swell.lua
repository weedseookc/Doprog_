--- doprog.zones.esianti.mercenary_not_as_swell
--- Not as SWELL as you would think — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Not as SWELL as you would think',
    type = 'mercenary',
    zone = 'esianti',
    completionTask = 'Not as SWELL as you would think',
    steps = {
        S.pickup({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Not as SWELL as you would think', desc = 'accept Not as SWELL as you would think' }),
        S.combat({ zone = 'esianti', target = { name = 'TODO target', npc = true }, taskName = 'Not as SWELL as you would think', objective = 1, desc = 'Not as SWELL as you would think objective' }),
        S.handin({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Not as SWELL as you would think', desc = 'complete Not as SWELL as you would think' }),
    },
})
