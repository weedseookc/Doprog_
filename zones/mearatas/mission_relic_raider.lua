--- doprog.zones.mearatas.mission_relic_raider
--- Relic Raider — mission (group mission, 1h lockout). Giver: Key of the Relic Keeper.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Key of the Relic Keeper", npc = true }

---@type doprog.Mission
return Mission.new({
    name = "Relic Raider",
    zone = "mearatas",
    completionTask = "Relic Raider",
    requestNpc = GIVER,
    requestSay = "relic raider",
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = "mearatas", npc = GIVER, taskName = "Relic Raider", desc = "request Relic Raider" }),
        S.combat({ zone = "mearatas", taskName = "Relic Raider", objective = 1, desc = "Relic Raider — clear combat objective" }),
        S.handin({ zone = "mearatas", npc = GIVER, taskName = "Relic Raider", desc = "complete Relic Raider" }),
    },
})
