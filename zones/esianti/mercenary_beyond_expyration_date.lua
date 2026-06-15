--- doprog.zones.esianti.mercenary_beyond_expyration_date
--- Beyond the ex-PYRE-ation date — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Beyond the ex-PYRE-ation date',
    type = 'mercenary',
    zone = 'esianti',
    completionTask = 'Beyond the ex-PYRE-ation date',
    steps = {
        S.pickup({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Beyond the ex-PYRE-ation date', desc = 'accept Beyond the ex-PYRE-ation date' }),
        S.combat({ zone = 'esianti', target = { name = 'TODO target', npc = true }, taskName = 'Beyond the ex-PYRE-ation date', objective = 1, desc = 'Beyond the ex-PYRE-ation date objective' }),
        S.handin({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Beyond the ex-PYRE-ation date', desc = 'complete Beyond the ex-PYRE-ation date' }),
    },
})
