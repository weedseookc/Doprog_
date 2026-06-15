--- doprog.zones.stratos.mercenary_do_unto_them
--- Do Unto Them — mercenary. Giver: Ashen Wandering Horizon.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Ashen Wandering Horizon", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Do Unto Them",
    type = "mercenary",
    zone = "stratos",
    completionTask = "Do Unto Them",
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Do Unto Them", desc = "accept Do Unto Them" }),
        S.combat({ zone = "stratos", taskName = "Do Unto Them", objective = 1, desc = "Do Unto Them — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Do Unto Them", desc = "complete Do Unto Them" }),
    },
})
