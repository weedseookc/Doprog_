--- doprog.zones.mearatas.partisan_earthen_dirge
--- Earthen Dirge — partisan. Giver: Obsidian Sundering Master in esianti.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Obsidian Sundering Master", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Earthen Dirge",
    type = "partisan",
    zone = "mearatas",
    completionTask = "Earthen Dirge",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Earthen Dirge", desc = "accept Earthen Dirge" }),
        S.combat({ zone = "mearatas", taskName = "Earthen Dirge", objective = 1, desc = "Earthen Dirge — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Earthen Dirge", desc = "complete Earthen Dirge" }),
    },
})
