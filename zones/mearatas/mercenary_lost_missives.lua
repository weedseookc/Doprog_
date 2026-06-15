--- doprog.zones.mearatas.mercenary_lost_missives
--- Lost Missives — mercenary. Giver: Emli Widgetton.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Emli Widgetton", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Lost Missives",
    type = "mercenary",
    zone = "mearatas",
    completionTask = "Lost Missives",
    steps = {
        S.pickup({ zone = "mearatas", npc = GIVER, taskName = "Lost Missives", desc = "accept Lost Missives" }),
        S.combat({ zone = "mearatas", taskName = "Lost Missives", objective = 1, desc = "Lost Missives — clear combat objective" }),
        S.handin({ zone = "mearatas", npc = GIVER, taskName = "Lost Missives", desc = "complete Lost Missives" }),
    },
})
