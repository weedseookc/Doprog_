--- doprog.zones.esianti.partisan_of_mice_and_jann
--- Of Mice and Jann — partisan. Giver: Joyous Blossom.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Joyous Blossom", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Of Mice and Jann",
    type = "partisan",
    zone = "esianti",
    completionTask = "Of Mice and Jann",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Of Mice and Jann", desc = "accept Of Mice and Jann" }),
        S.combat({ zone = "esianti", taskName = "Of Mice and Jann", objective = 1, desc = "Of Mice and Jann — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Of Mice and Jann", desc = "complete Of Mice and Jann" }),
    },
})
