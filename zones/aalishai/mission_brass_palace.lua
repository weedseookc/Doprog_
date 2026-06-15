--- doprog.zones.aalishai.mission_brass_palace
--- Brass Palace — mission (group mission, 1h lockout). Giver: Great Sky Ocean in stratos.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Great Sky Ocean", npc = true }

---@type doprog.Mission
return Mission.new({
    name = "Brass Palace",
    zone = "aalishai",
    completionTask = "Brass Palace",
    requestNpc = GIVER,
    requestSay = "brass palace",
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Brass Palace", desc = "request Brass Palace" }),
        S.combat({ zone = "aalishai", taskName = "Brass Palace", objective = 1, desc = "Brass Palace — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Brass Palace", desc = "complete Brass Palace" }),
    },
})
