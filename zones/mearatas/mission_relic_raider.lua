--- doprog.zones.mearatas.mission_relic_raider
--- Relic Raider — group mission (1-hour request lockout).
---
--- TODO(data): confirm request NPC + phrase, instance objectives, and the camp
--- /loc coordinates from https://tbl.eqresource.com .
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.Mission
return Mission.new({
    name = 'Relic Raider',
    zone = 'mearatas',
    completionTask = 'Relic Raider',
    requestNpc = { name = 'TODO request npc', npc = true },
    requestSay = 'TODO request phrase',
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = 'mearatas', npc = { name = 'TODO request npc', npc = true }, taskName = 'Relic Raider', desc = 'request Relic Raider' }),
        S.combat({ zone = 'mearatas', target = { name = 'TODO boss', npc = true }, taskName = 'Relic Raider', objective = 1, desc = 'Relic Raider objective' }),
        S.handin({ zone = 'mearatas', npc = { name = 'TODO request npc', npc = true }, taskName = 'Relic Raider', desc = 'complete Relic Raider' }),
    },
})
