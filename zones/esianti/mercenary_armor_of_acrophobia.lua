--- doprog.zones.esianti.mercenary_armor_of_acrophobia
--- Armor of Acrophobia — mercenary. Giver: Phibbit.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Phibbit", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Armor of Acrophobia",
    type = "mercenary",
    zone = "esianti",
    completionTask = "Armor of Acrophobia",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Armor of Acrophobia", desc = "accept Armor of Acrophobia" }),
        S.combat({ zone = "esianti", taskName = "Armor of Acrophobia", objective = 1, desc = "Armor of Acrophobia — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Armor of Acrophobia", desc = "complete Armor of Acrophobia" }),
    },
})
