--- doprog.zones.aalishai.partisan_fragmented_coterie
--- Fragmented Coterie — partisan. Giver: Spear Sundering Ivory.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Spear Sundering Ivory", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Fragmented Coterie",
    type = "partisan",
    zone = "aalishai",
    completionTask = "Fragmented Coterie",
    steps = {
        S.pickup({ zone = "aalishai", npc = GIVER, taskName = "Fragmented Coterie", desc = "accept Fragmented Coterie" }),
        S.combat({ zone = "aalishai", taskName = "Fragmented Coterie", objective = 1, desc = "Fragmented Coterie — clear combat objective" }),
        S.handin({ zone = "aalishai", npc = GIVER, taskName = "Fragmented Coterie", desc = "complete Fragmented Coterie" }),
    },
})
