--- doprog.zones.aalishai.mission_brass_palace
--- Brass Palace — group mission (1-hour request lockout).
---
--- TODO(data): confirm request NPC + phrase, instance objectives, and the camp
--- /loc coordinates from https://tbl.eqresource.com .
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.Mission
return Mission.new({
    name = 'Brass Palace',
    zone = 'aalishai',
    completionTask = 'Brass Palace',
    requestNpc = { name = 'TODO request npc', npc = true },
    requestSay = 'TODO request phrase',
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = 'aalishai', npc = { name = 'TODO request npc', npc = true }, taskName = 'Brass Palace', desc = 'request Brass Palace' }),
        S.combat({ zone = 'aalishai', target = { name = 'TODO boss', npc = true }, taskName = 'Brass Palace', objective = 1, desc = 'Brass Palace objective' }),
        S.handin({ zone = 'aalishai', npc = { name = 'TODO request npc', npc = true }, taskName = 'Brass Palace', desc = 'complete Brass Palace' }),
    },
})
