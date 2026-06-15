--- doprog.zones.mearatas.mercenary_free_the_wardens
--- Free the Wardens — mercenary. Giver: Emli Widgetton.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Emli Widgetton", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Free the Wardens",
    type = "mercenary",
    zone = "mearatas",
    completionTask = "Free the Wardens",
    steps = {
        S.pickup({ zone = "mearatas", npc = GIVER, taskName = "Free the Wardens", desc = "accept Free the Wardens" }),
        S.combat({ zone = "mearatas", taskName = "Free the Wardens", objective = 1, desc = "Free the Wardens — clear combat objective" }),
        S.handin({ zone = "mearatas", npc = GIVER, taskName = "Free the Wardens", desc = "complete Free the Wardens" }),
    },
})
