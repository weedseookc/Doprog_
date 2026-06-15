--- doprog.zones.stratos.mission_fight_fire
--- Fight Fire — mission (group mission, 1h lockout). Giver: Grieving Soul Scent.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Grieving Soul Scent", npc = true }

---@type doprog.Mission
return Mission.new({
    name = "Fight Fire",
    zone = "stratos",
    completionTask = "Fight Fire",
    requestNpc = GIVER,
    requestSay = "fight fire",
    lockoutMinutes = 60,
    prereq = { tasks = { "Soldier of Air" } },
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Fight Fire", desc = "request Fight Fire" }),
        S.combat({ zone = "stratos", taskName = "Fight Fire", objective = 1, desc = "Fight Fire — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Fight Fire", desc = "complete Fight Fire" }),
    },
})
