--- doprog.zones.aalishai.partisan_royal_visits
--- Royal Visits — partisan. Giver: Sky Orchid Understanding in esianti.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Sky Orchid Understanding", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Royal Visits",
    type = "partisan",
    zone = "aalishai",
    completionTask = "Royal Visits",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Royal Visits", desc = "accept Royal Visits" }),
        S.combat({ zone = "aalishai", taskName = "Royal Visits", objective = 1, desc = "Royal Visits — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Royal Visits", desc = "complete Royal Visits" }),
    },
})
