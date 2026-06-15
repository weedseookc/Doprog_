--- doprog.zones.stratos.mercenary_earning_ones_place
--- Earning One's Place — mercenary. Giver: Iron Lightning Spirit.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Iron Lightning Spirit", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Earning One's Place",
    type = "mercenary",
    zone = "stratos",
    completionTask = "Earning One's Place",
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Earning One's Place", desc = "accept Earning One's Place" }),
        S.combat({ zone = "stratos", taskName = "Earning One's Place", objective = 1, desc = "Earning One's Place — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Earning One's Place", desc = "complete Earning One's Place" }),
    },
})
