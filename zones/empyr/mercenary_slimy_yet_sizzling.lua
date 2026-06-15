--- doprog.zones.empyr.mercenary_slimy_yet_sizzling
--- Slimy, Yet Sizzling — mercenary. Giver: Charred Forest.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Charred Forest", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Slimy, Yet Sizzling",
    type = "mercenary",
    zone = "empyr",
    completionTask = "Slimy, Yet Sizzling",
    steps = {
        S.pickup({ zone = "empyr", npc = GIVER, taskName = "Slimy, Yet Sizzling", desc = "accept Slimy, Yet Sizzling" }),
        S.combat({ zone = "empyr", taskName = "Slimy, Yet Sizzling", objective = 1, desc = "Slimy, Yet Sizzling — clear combat objective" }),
        S.handin({ zone = "empyr", npc = GIVER, taskName = "Slimy, Yet Sizzling", desc = "complete Slimy, Yet Sizzling" }),
    },
})
