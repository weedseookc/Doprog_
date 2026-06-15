--- doprog.zones.plane_of_smoke.trials.trial_speakers_amphitheater
--- Trial of the Speaker's Amphitheater — one of the five Trials of Smoke.
--- Only one trial is required to progress. TODO(data): confirm the trial NPC,
--- instance mechanics/objectives, and camp /loc from https://tbl.eqresource.com .
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = "Trial of the Speaker's Amphitheater",
    type = 'task',
    zone = 'smoke',
    completionTask = "Trial of the Speaker's Amphitheater",
    steps = {
        S.pickup({ zone = 'smoke', npc = { name = "Trial of the Speaker's Amphitheater", npc = true }, taskName = "Trial of the Speaker's Amphitheater", desc = "start trial" }),
        S.combat({ zone = 'smoke', target = { name = 'TODO trial target', npc = true }, taskName = "Trial of the Speaker's Amphitheater", objective = 1, desc = "trial objective" }),
    },
})
