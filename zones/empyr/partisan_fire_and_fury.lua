--- doprog.zones.empyr.partisan_fire_and_fury
--- Fire and Fury — partisan. Giver: Horizon Blighted Sage.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Horizon Blighted Sage", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Fire and Fury",
    type = "partisan",
    zone = "empyr",
    completionTask = "Fire and Fury",
    steps = {
        S.pickup({ zone = "empyr", npc = GIVER, taskName = "Fire and Fury", desc = "accept Fire and Fury" }),
        S.combat({ zone = "empyr", taskName = "Fire and Fury", objective = 1, desc = "Fire and Fury — clear combat objective" }),
        S.handin({ zone = "empyr", npc = GIVER, taskName = "Fire and Fury", desc = "complete Fire and Fury" }),
    },
})
