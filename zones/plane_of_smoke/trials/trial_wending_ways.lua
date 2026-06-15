--- doprog.zones.plane_of_smoke.trials.trial_wending_ways
--- Trial of the Wending Ways — one of the five Trials of Smoke (instanced). Only ONE trial must be
--- completed to progress; the others are alternates. The trial is started by an
--- NPC of the exact same name. Combat is objective-driven: doprog advertises
--- NEED_COMBAT inside the instance and watches the trial objective.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local STARTER = { name = "Trial of the Wending Ways", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Trial of the Wending Ways",
    type = 'task',
    zone = 'smoke',
    completionTask = "Trial of the Wending Ways",
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = "Trial of the Wending Ways", desc = "start Trial of the Wending Ways" }),
        S.combat({ zone = 'smoke', taskName = "Trial of the Wending Ways", objective = 1, desc = "Trial of the Wending Ways — clear trial objective" }),
    },
})
