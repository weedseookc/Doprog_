--- doprog.zones.aalishai.mercenary_gathering_elements_air
--- Gathering Elements: Air — mercenary. Giver: Everna Delestrod.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Everna Delestrod", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Gathering Elements: Air",
    type = "mercenary",
    zone = "aalishai",
    completionTask = "Gathering Elements: Air",
    steps = {
        S.pickup({ zone = "aalishai", npc = GIVER, taskName = "Gathering Elements: Air", desc = "accept Gathering Elements: Air" }),
        S.combat({ zone = "aalishai", taskName = "Gathering Elements: Air", objective = 1, desc = "Gathering Elements: Air — clear combat objective" }),
        S.handin({ zone = "aalishai", npc = GIVER, taskName = "Gathering Elements: Air", desc = "complete Gathering Elements: Air" }),
    },
})
