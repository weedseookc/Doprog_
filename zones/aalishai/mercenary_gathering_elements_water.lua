--- doprog.zones.aalishai.mercenary_gathering_elements_water
--- Gathering Elements: Water — mercenary. Giver: Everna Delestrod.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Everna Delestrod", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Gathering Elements: Water",
    type = "mercenary",
    zone = "aalishai",
    completionTask = "Gathering Elements: Water",
    steps = {
        S.pickup({ zone = "aalishai", npc = GIVER, taskName = "Gathering Elements: Water", desc = "accept Gathering Elements: Water" }),
        S.combat({ zone = "aalishai", taskName = "Gathering Elements: Water", objective = 1, desc = "Gathering Elements: Water — clear combat objective" }),
        S.handin({ zone = "aalishai", npc = GIVER, taskName = "Gathering Elements: Water", desc = "complete Gathering Elements: Water" }),
    },
})
