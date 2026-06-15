--- doprog.zones.aalishai.partisan_enter_mearatas
--- Enter Mearatas — partisan. Giver: Blazing Sorrows Darkness.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Blazing Sorrows Darkness", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Enter Mearatas",
    type = "partisan",
    zone = "aalishai",
    completionTask = "Enter Mearatas",
    steps = {
        S.pickup({ zone = "aalishai", npc = GIVER, taskName = "Enter Mearatas", desc = "accept Enter Mearatas" }),
        S.combat({ zone = "aalishai", taskName = "Enter Mearatas", objective = 1, desc = "Enter Mearatas — clear combat objective" }),
        S.handin({ zone = "aalishai", npc = GIVER, taskName = "Enter Mearatas", desc = "complete Enter Mearatas" }),
    },
})
