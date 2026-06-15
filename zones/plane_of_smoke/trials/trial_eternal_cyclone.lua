--- doprog.zones.plane_of_smoke.trials.trial_eternal_cyclone
--- Trial of the Eternal Cyclone — one of the five Trials of Smoke (instanced).
---
--- Only one trial is required to progress. TODO(data): confirm the trial NPC of
--- the same name, the instance mechanics/objectives, and camp /loc from
--- https://tbl.eqresource.com .
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Trial of the Eternal Cyclone',
    type = 'task',
    zone = 'smoke',
    completionTask = 'Trial of the Eternal Cyclone',
    steps = {
        S.pickup({ zone = 'smoke', npc = { name = 'Trial of the Eternal Cyclone', npc = true }, taskName = 'Trial of the Eternal Cyclone', desc = 'start Trial of the Eternal Cyclone' }),
        S.combat({ zone = 'smoke', target = { name = 'TODO trial target', npc = true }, taskName = 'Trial of the Eternal Cyclone', objective = 1, desc = 'Trial of the Eternal Cyclone objective' }),
    },
})
