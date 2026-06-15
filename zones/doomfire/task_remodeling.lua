--- doprog.zones.doomfire.task_remodeling
--- Remodeling — task. Giver: Unrepentant Sunrise.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Unrepentant Sunrise", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Remodeling",
    type = "task",
    zone = "doomfire",
    completionTask = "Remodeling",
    steps = {
        S.pickup({ zone = "doomfire", npc = GIVER, taskName = "Remodeling", desc = "accept Remodeling" }),
        S.combat({ zone = "doomfire", taskName = "Remodeling", objective = 1, desc = "Remodeling — clear combat objective" }),
        S.handin({ zone = "doomfire", npc = GIVER, taskName = "Remodeling", desc = "complete Remodeling" }),
    },
})
