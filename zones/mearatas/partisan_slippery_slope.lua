--- doprog.zones.mearatas.partisan_slippery_slope
--- Slippery Slope — partisan quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Slippery Slope',
    type = 'partisan',
    zone = 'mearatas',
    completionTask = 'Slippery Slope',
    steps = {
        S.pickup({ zone = 'mearatas', npc = { name = 'TODO giver', npc = true }, taskName = 'Slippery Slope', desc = 'accept Slippery Slope' }),
        S.combat({ zone = 'mearatas', target = { name = 'TODO target', npc = true }, taskName = 'Slippery Slope', objective = 1, desc = 'Slippery Slope objective' }),
        S.handin({ zone = 'mearatas', npc = { name = 'TODO giver', npc = true }, taskName = 'Slippery Slope', desc = 'complete Slippery Slope' }),
    },
})
