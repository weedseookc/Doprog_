--- doprog.zones.esianti.partisan_all_hail_the_king
--- All Hail the King — partisan. Giver: Great Sky Ocean in stratos.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Great Sky Ocean", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "All Hail the King",
    type = "partisan",
    zone = "esianti",
    completionTask = "All Hail the King",
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "All Hail the King", desc = "accept All Hail the King" }),
        S.combat({ zone = "esianti", taskName = "All Hail the King", objective = 1, desc = "All Hail the King — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "All Hail the King", desc = "complete All Hail the King" }),
    },
})
