--- doprog.zones.empyr.partisan_palace_of_embers
--- Palace of Embers — partisan. Giver: Great Sky Ocean in stratos.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Great Sky Ocean", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Palace of Embers",
    type = "partisan",
    zone = "empyr",
    completionTask = "Palace of Embers",
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Palace of Embers", desc = "accept Palace of Embers" }),
        S.combat({ zone = "empyr", taskName = "Palace of Embers", objective = 1, desc = "Palace of Embers — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Palace of Embers", desc = "complete Palace of Embers" }),
    },
})
