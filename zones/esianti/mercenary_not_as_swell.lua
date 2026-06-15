--- doprog.zones.esianti.mercenary_not_as_swell
--- Not as Swell as You Would Think — mercenary. Giver: Phibbit.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Phibbit", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Not as Swell as You Would Think",
    type = "mercenary",
    zone = "esianti",
    completionTask = "Not as Swell as You Would Think",
    steps = {
        S.pickup({ zone = "esianti", npc = GIVER, taskName = "Not as Swell as You Would Think", desc = "accept Not as Swell as You Would Think" }),
        S.combat({ zone = "esianti", taskName = "Not as Swell as You Would Think", objective = 1, desc = "Not as Swell as You Would Think — clear combat objective" }),
        S.handin({ zone = "esianti", npc = GIVER, taskName = "Not as Swell as You Would Think", desc = "complete Not as Swell as You Would Think" }),
    },
})
