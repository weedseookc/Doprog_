--- doprog.zones.empyr.mission_prince_ralaifin
--- Prince Ralaifin — group mission (1-hour request lockout).
---
--- TODO(data): confirm request NPC + phrase, instance objectives, and the camp
--- /loc coordinates from https://tbl.eqresource.com .
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.Mission
return Mission.new({
    name = 'Prince Ralaifin',
    zone = 'empyr',
    completionTask = 'Prince Ralaifin',
    requestNpc = { name = 'TODO request npc', npc = true },
    requestSay = 'TODO request phrase',
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = 'empyr', npc = { name = 'TODO request npc', npc = true }, taskName = 'Prince Ralaifin', desc = 'request Prince Ralaifin' }),
        S.combat({ zone = 'empyr', target = { name = 'TODO boss', npc = true }, taskName = 'Prince Ralaifin', objective = 1, desc = 'Prince Ralaifin objective' }),
        S.handin({ zone = 'empyr', npc = { name = 'TODO request npc', npc = true }, taskName = 'Prince Ralaifin', desc = 'complete Prince Ralaifin' }),
    },
})
