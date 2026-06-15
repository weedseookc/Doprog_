--- doprog.zones.empyr.mercenary_scalding_webs
--- Scalding Webs We Weave — mercenary. Giver: Charred Forest.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Charred Forest", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Scalding Webs We Weave",
    type = "mercenary",
    zone = "empyr",
    completionTask = "Scalding Webs We Weave",
    steps = {
        S.pickup({ zone = "empyr", npc = GIVER, taskName = "Scalding Webs We Weave", desc = "accept Scalding Webs We Weave" }),
        S.combat({ zone = "empyr", taskName = "Scalding Webs We Weave", objective = 1, desc = "Scalding Webs We Weave — clear combat objective" }),
        S.handin({ zone = "empyr", npc = GIVER, taskName = "Scalding Webs We Weave", desc = "complete Scalding Webs We Weave" }),
    },
})
