--- doprog.zones.stratos.partisan_political_awareness
--- Political Awareness — partisan. Giver: Rianar Gadliun.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Rianar Gadliun", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Political Awareness",
    type = "partisan",
    zone = "stratos",
    completionTask = "Political Awareness",
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Political Awareness", desc = "accept Political Awareness" }),
        S.combat({ zone = "stratos", taskName = "Political Awareness", objective = 1, desc = "Political Awareness — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Political Awareness", desc = "complete Political Awareness" }),
    },
})
