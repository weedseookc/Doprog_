--- doprog.zones.plane_of_smoke.trials.trial_three
--- Trial of Three — one of the five Trials of Smoke (instanced). Only ONE trial must be
--- completed to progress; the others are alternates. The trial is started by an
--- NPC of the exact same name. Combat is objective-driven: doprog advertises
--- NEED_COMBAT inside the instance and watches the trial objective.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local STARTER = { name = "Trial of Three", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Trial of Three",
    type = 'task',
    zone = 'smoke',
    completionTask = "Trial of Three",
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = "Trial of Three", desc = "start Trial of Three" }),
        S.combat({ zone = 'smoke', taskName = "Trial of Three", objective = 1, desc = "Trial of Three — clear trial objective" }),
    },
})
