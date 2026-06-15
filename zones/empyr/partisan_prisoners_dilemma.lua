--- doprog.zones.empyr.partisan_prisoners_dilemma
--- Prisoner's Dilemma — partisan. Giver: Star Stealing Sage.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Star Stealing Sage", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Prisoner's Dilemma",
    type = "partisan",
    zone = "empyr",
    completionTask = "Prisoner's Dilemma",
    steps = {
        S.pickup({ zone = "empyr", npc = GIVER, taskName = "Prisoner's Dilemma", desc = "accept Prisoner's Dilemma" }),
        S.combat({ zone = "empyr", taskName = "Prisoner's Dilemma", objective = 1, desc = "Prisoner's Dilemma — clear combat objective" }),
        S.handin({ zone = "empyr", npc = GIVER, taskName = "Prisoner's Dilemma", desc = "complete Prisoner's Dilemma" }),
    },
})
