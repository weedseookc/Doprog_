--- doprog.zones.stratos.mission_fight_fire
--- Fight Fire — the first group mission, requested from Grieving Soul Scent.
--- Completing it (with Soldier of Air) unlocks the Plane of Smoke trials.
--- TODO(data): confirm request phrase, instance objectives and camp /loc.
local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local GIVER = { name = 'Grieving Soul Scent', npc = true }

---@type doprog.Mission
return Mission.new({
    name = 'Fight Fire',
    zone = 'stratos',
    completionTask = 'Fight Fire',
    requestNpc = GIVER,
    requestSay = 'TODO request phrase',
    lockoutMinutes = 60,
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = 'Fight Fire', desc = 'request Fight Fire' }),
        S.combat({ zone = 'stratos', target = { name = 'TODO boss', npc = true }, taskName = 'Fight Fire', objective = 1, desc = 'Fight Fire objective' }),
        S.handin({ zone = 'stratos', npc = GIVER, taskName = 'Fight Fire', desc = 'complete Fight Fire' }),
    },
})
