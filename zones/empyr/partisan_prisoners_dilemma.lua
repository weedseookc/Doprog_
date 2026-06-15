--- doprog.zones.empyr.partisan_prisoners_dilemma
--- Prisoner's Dilemma — partisan quest.
--- TODO(data): confirm giver NPC, kill target(s), hand-in NPC, objective indices
--- and /loc coordinates from https://tbl.eqresource.com .
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = "Prisoner's Dilemma",
    type = 'partisan',
    zone = 'empyr',
    completionTask = "Prisoner's Dilemma",
    steps = {
        S.pickup({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = "Prisoner's Dilemma", desc = "accept Prisoner's Dilemma" }),
        S.combat({ zone = 'empyr', target = { name = 'TODO target', npc = true }, taskName = "Prisoner's Dilemma", objective = 1, desc = "Prisoner's Dilemma objective" }),
        S.handin({ zone = 'empyr', npc = { name = 'TODO giver', npc = true }, taskName = "Prisoner's Dilemma", desc = "complete Prisoner's Dilemma" }),
    },
})
