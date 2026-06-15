--- doprog.zones.esianti.mercenary_sweeping_up_the_brumes
--- Sweeping up the Brumes — mercenary. Giver: Phibbit.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Phibbit", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Sweeping up the Brumes",
    type = "mercenary",
    zone = "esianti",
    completionTask = "Sweeping up the Brumes",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Sweeping up the Brumes", desc = "accept Sweeping up the Brumes" }),
        S.combat({ zone = "esianti", taskName = "Sweeping up the Brumes", objective = 1, desc = "Sweeping up the Brumes — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Sweeping up the Brumes", desc = "complete Sweeping up the Brumes" }),
    },
})
