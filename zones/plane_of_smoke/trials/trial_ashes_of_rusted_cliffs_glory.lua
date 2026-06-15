--- doprog.zones.plane_of_smoke.trials.trial_ashes_of_rusted_cliffs_glory
--- Trial of the Ashes of Rusted Cliff's Glory — one of the five Trials of Smoke.
--- Only one trial is required to progress. TODO(data): confirm the trial NPC,
--- instance mechanics/objectives, and camp /loc from https://tbl.eqresource.com .
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = "Trial of the Ashes of Rusted Cliff's Glory",
    type = 'task',
    zone = 'smoke',
    completionTask = "Trial of the Ashes of Rusted Cliff's Glory",
    steps = {
        S.pickup({ zone = 'smoke', npc = { name = "Trial of the Ashes of Rusted Cliff's Glory", npc = true }, taskName = "Trial of the Ashes of Rusted Cliff's Glory", desc = "start trial" }),
        S.combat({ zone = 'smoke', target = { name = 'TODO trial target', npc = true }, taskName = "Trial of the Ashes of Rusted Cliff's Glory", objective = 1, desc = "trial objective" }),
    },
})
