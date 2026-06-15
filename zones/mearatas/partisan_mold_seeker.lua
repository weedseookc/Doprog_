--- doprog.zones.mearatas.partisan_mold_seeker
--- Mold Seeker — partisan. Giver: Obsidian Sundering Master in esianti.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Obsidian Sundering Master", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Mold Seeker",
    type = "partisan",
    zone = "mearatas",
    completionTask = "Mold Seeker",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Mold Seeker", desc = "accept Mold Seeker" }),
        S.combat({ zone = "mearatas", taskName = "Mold Seeker", objective = 1, desc = "Mold Seeker — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Mold Seeker", desc = "complete Mold Seeker" }),
    },
})
