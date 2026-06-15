--- doprog.zones.esianti.partisan_serving_another_master
--- Serving Another Master — partisan. Giver: Obsidian Sundering Master.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Obsidian Sundering Master", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Serving Another Master",
    type = "partisan",
    zone = "esianti",
    completionTask = "Serving Another Master",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Serving Another Master", desc = "accept Serving Another Master" }),
        S.combat({ zone = "esianti", taskName = "Serving Another Master", objective = 1, desc = "Serving Another Master — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Serving Another Master", desc = "complete Serving Another Master" }),
    },
})
