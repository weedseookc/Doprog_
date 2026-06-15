--- doprog.zones.plane_of_smoke.trials.trial_speakers_amphitheater
--- Trial of the Speaker's Amphitheater — one of the five Trials of Smoke (instanced). Only ONE trial must be
--- completed to progress; the others are alternates. The trial is started by an
--- NPC of the exact same name. Combat is objective-driven: doprog advertises
--- NEED_COMBAT inside the instance and watches the trial objective.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.SpawnQuery
local STARTER = { name = "Trial of the Speaker's Amphitheater", npc = true }

---@type doprog.Quest
return Quest.new({
    name = "Trial of the Speaker's Amphitheater",
    type = 'task',
    zone = 'smoke',
    completionTask = "Trial of the Speaker's Amphitheater",
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = "Trial of the Speaker's Amphitheater", desc = "start Trial of the Speaker's Amphitheater" }),
        S.combat({ zone = 'smoke', taskName = "Trial of the Speaker's Amphitheater", objective = 1, desc = "Trial of the Speaker's Amphitheater — clear trial objective" }),
    },
})
