--- doprog.zones.esianti.mercenary_beyond_expyration_date
--- Beyond the Ex-pyre-ation Date — mercenary. Giver: Phibbit.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Phibbit", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Beyond the Ex-pyre-ation Date",
    type = "mercenary",
    zone = "esianti",
    completionTask = "Beyond the Ex-pyre-ation Date",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Beyond the Ex-pyre-ation Date", desc = "accept Beyond the Ex-pyre-ation Date" }),
        S.combat({ zone = "esianti", taskName = "Beyond the Ex-pyre-ation Date", objective = 1, desc = "Beyond the Ex-pyre-ation Date — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Beyond the Ex-pyre-ation Date", desc = "complete Beyond the Ex-pyre-ation Date" }),
    },
})
