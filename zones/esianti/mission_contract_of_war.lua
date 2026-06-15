--- doprog.zones.esianti.mission_contract_of_war
--- Contract of War — mission (group mission, 1h lockout). Giver: Great Sky Ocean in stratos.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Great Sky Ocean", npc = true }

---@type doprog.Mission
return Mission.new({
    name = "Contract of War",
    zone = "esianti",
    completionTask = "Contract of War",
    requestNpc = GIVER,
    requestSay = "contract of war",
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = "stratos", npc = GIVER, taskName = "Contract of War", desc = "request Contract of War" }),
        S.combat({ zone = "esianti", taskName = "Contract of War", objective = 1, desc = "Contract of War — clear combat objective" }),
        S.handin({ zone = "stratos", npc = GIVER, taskName = "Contract of War", desc = "complete Contract of War" }),
    },
})
