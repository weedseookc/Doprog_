--- doprog.zones.esianti.mercenary_sweeping_up_the_brumes
--- Sweeping up the Brumes — mercenary quest.
---
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com . The step shape below
--- (pickup -> combat -> handin) is the common pattern; adjust to the real task.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Sweeping up the Brumes',
    type = 'mercenary',
    zone = 'esianti',
    completionTask = 'Sweeping up the Brumes',
    steps = {
        S.pickup({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Sweeping up the Brumes', desc = 'accept Sweeping up the Brumes' }),
        S.combat({ zone = 'esianti', target = { name = 'TODO target', npc = true }, taskName = 'Sweeping up the Brumes', objective = 1, desc = 'Sweeping up the Brumes objective' }),
        S.handin({ zone = 'esianti', npc = { name = 'TODO giver', npc = true }, taskName = 'Sweeping up the Brumes', desc = 'complete Sweeping up the Brumes' }),
    },
})
