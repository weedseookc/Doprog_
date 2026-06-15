--- doprog.zones.mearatas.mercenary_thin_out_the_mephits
--- Thin out the Mephits — mercenary. Giver: Emli Widgetton.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Emli Widgetton", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Thin out the Mephits",
    type = "mercenary",
    zone = "mearatas",
    completionTask = "Thin out the Mephits",
    steps = {
        S.pickup({ zone = "mearatas", npc = GIVER, taskName = "Thin out the Mephits", desc = "accept Thin out the Mephits" }),
        S.combat({ zone = "mearatas", taskName = "Thin out the Mephits", objective = 1, desc = "Thin out the Mephits — clear combat objective" }),
        S.handin({ zone = "mearatas", npc = GIVER, taskName = "Thin out the Mephits", desc = "complete Thin out the Mephits" }),
    },
})
