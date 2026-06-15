--- doprog.zones.doomfire.task_strange_magic
--- Strange Magic — task. Giver: Unrepentant Sunrise.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Unrepentant Sunrise", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Strange Magic",
    type = "task",
    zone = "doomfire",
    completionTask = "Strange Magic",
    steps = {
        S.pickup({ zone = "doomfire", npc = GIVER, taskName = "Strange Magic", desc = "accept Strange Magic" }),
        S.combat({ zone = "doomfire", taskName = "Strange Magic", objective = 1, desc = "Strange Magic — clear combat objective" }),
        S.handin({ zone = "doomfire", npc = GIVER, taskName = "Strange Magic", desc = "complete Strange Magic" }),
    },
})
