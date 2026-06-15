--- doprog.zones.stratos.partisan_key_to_the_kingdom
--- Key to the Kingdom — partisan. Giver: Dusky Iron Meditation.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Dusky Iron Meditation", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Key to the Kingdom",
    type = "partisan",
    zone = "stratos",
    completionTask = "Key to the Kingdom",
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Key to the Kingdom", desc = "accept Key to the Kingdom" }),
        S.combat({ zone = "stratos", taskName = "Key to the Kingdom", objective = 1, desc = "Key to the Kingdom — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Key to the Kingdom", desc = "complete Key to the Kingdom" }),
    },
})
