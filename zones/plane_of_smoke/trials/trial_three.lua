--- doprog.zones.plane_of_smoke.trials.trial_three
--- Trial of Three — one of the five Trials of Smoke (instanced).
---
--- Only one trial is required to progress. TODO(data): confirm the trial NPC of
--- the same name, the instance mechanics/objectives, and camp /loc from
--- https://tbl.eqresource.com .
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Trial of Three',
    type = 'task',
    zone = 'smoke',
    completionTask = 'Trial of Three',
    steps = {
        S.pickup({ zone = 'smoke', npc = { name = 'Trial of Three', npc = true }, taskName = 'Trial of Three', desc = 'start Trial of Three' }),
        S.combat({ zone = 'smoke', target = { name = 'TODO trial target', npc = true }, taskName = 'Trial of Three', objective = 1, desc = 'Trial of Three objective' }),
    },
})
