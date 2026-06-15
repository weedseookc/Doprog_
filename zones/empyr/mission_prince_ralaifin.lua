--- doprog.zones.empyr.mission_prince_ralaifin
--- Prince Ralaifin — mission (group mission, 1h lockout). Giver: Horizon Blighted Sage.
--- Combat is objective-driven: doprog advertises NEED_COMBAT and watches
--- the task objective; the host combat system selects and kills targets.
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = "Horizon Blighted Sage", npc = true }

---@type doprog.Mission
return Mission.new({
    name = "Prince Ralaifin",
    zone = "empyr",
    completionTask = "Prince Ralaifin",
    requestNpc = GIVER,
    requestSay = "prince ralaifin",
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = "empyr", npc = GIVER, taskName = "Prince Ralaifin", desc = "request Prince Ralaifin" }),
        S.combat({ zone = "empyr", taskName = "Prince Ralaifin", objective = 1, desc = "Prince Ralaifin — clear combat objective" }),
        S.handin({ zone = "empyr", npc = GIVER, taskName = "Prince Ralaifin", desc = "complete Prince Ralaifin" }),
    },
})
