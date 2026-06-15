--- doprog.zones.doomfire.task_delivery
--- Delivery — task. Giver: Unrepentant Sunrise.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Unrepentant Sunrise", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Delivery",
    type = "task",
    zone = "doomfire",
    completionTask = "Delivery",
    steps = {
        S.pickup({ zone = "doomfire", npc = GIVER, taskName = "Delivery", desc = "accept Delivery" }),
        S.combat({ zone = "doomfire", taskName = "Delivery", objective = 1, desc = "Delivery — clear combat objective" }),
        S.handin({ zone = "doomfire", npc = GIVER, taskName = "Delivery", desc = "complete Delivery" }),
    },
})
