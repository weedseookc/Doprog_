--- doprog.zones.stratos.mercenary_soldier_of_air
--- Soldier of Air — mercenary. Giver: Grieving Soul Scent.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Grieving Soul Scent", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Soldier of Air",
    type = "mercenary",
    zone = "stratos",
    completionTask = "Soldier of Air",
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Soldier of Air", desc = "accept Soldier of Air" }),
        S.combat({ zone = "stratos", taskName = "Soldier of Air", objective = 1, desc = "Soldier of Air — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Soldier of Air", desc = "complete Soldier of Air" }),
    },
})
