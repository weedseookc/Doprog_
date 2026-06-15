--- doprog.zones.stratos.partisan_petitioners_plight
--- A Petitioner's Plight — partisan. Giver: Iron Lightning Spirit.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Iron Lightning Spirit", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "A Petitioner's Plight",
    type = "partisan",
    zone = "stratos",
    completionTask = "A Petitioner's Plight",
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "A Petitioner's Plight", desc = "accept A Petitioner's Plight" }),
        S.combat({ zone = "stratos", taskName = "A Petitioner's Plight", objective = 1, desc = "A Petitioner's Plight — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "A Petitioner's Plight", desc = "complete A Petitioner's Plight" }),
    },
})
