--- doprog.zones.mearatas.partisan_slippery_slope
--- Slippery Slope — partisan. Giver: Flexing Devout Purpose.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Flexing Devout Purpose", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Slippery Slope",
    type = "partisan",
    zone = "mearatas",
    completionTask = "Slippery Slope",
    steps = {
        S.pickup({ zone = "mearatas", npc = GIVER, taskName = "Slippery Slope", desc = "accept Slippery Slope" }),
        S.combat({ zone = "mearatas", taskName = "Slippery Slope", objective = 1, desc = "Slippery Slope — clear combat objective" }),
        S.handin({ zone = "mearatas", npc = GIVER, taskName = "Slippery Slope", desc = "complete Slippery Slope" }),
    },
})
