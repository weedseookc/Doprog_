--- doprog.zones.empyr.mercenary_crafted_from_ash
--- Crafted from Ash — mercenary. Giver: Charred Forest.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Charred Forest", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Crafted from Ash",
    type = "mercenary",
    zone = "empyr",
    completionTask = "Crafted from Ash",
    steps = {
        S.pickup({ zone = "empyr", npc = GIVER, taskName = "Crafted from Ash", desc = "accept Crafted from Ash" }),
        S.combat({ zone = "empyr", taskName = "Crafted from Ash", objective = 1, desc = "Crafted from Ash — clear combat objective" }),
        S.handin({ zone = "empyr", npc = GIVER, taskName = "Crafted from Ash", desc = "complete Crafted from Ash" }),
    },
})
