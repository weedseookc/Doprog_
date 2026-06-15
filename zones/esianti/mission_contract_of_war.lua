--- doprog.zones.esianti.mission_contract_of_war
--- Contract of War — group mission (1-hour request lockout).
---
--- TODO(data): confirm request NPC + phrase, instance objectives, and the camp
--- /loc coordinates from https://tbl.eqresource.com .
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.Mission
return Mission.new({
    name = 'Contract of War',
    zone = 'esianti',
    completionTask = 'Contract of War',
    requestNpc = { name = 'TODO request npc', npc = true },
    requestSay = 'TODO request phrase',
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = 'esianti', npc = { name = 'TODO request npc', npc = true }, taskName = 'Contract of War', desc = 'request Contract of War' }),
        S.combat({ zone = 'esianti', target = { name = 'TODO boss', npc = true }, taskName = 'Contract of War', objective = 1, desc = 'Contract of War objective' }),
        S.handin({ zone = 'esianti', npc = { name = 'TODO request npc', npc = true }, taskName = 'Contract of War', desc = 'complete Contract of War' }),
    },
})
