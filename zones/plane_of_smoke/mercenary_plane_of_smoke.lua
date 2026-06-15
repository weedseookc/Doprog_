--- doprog.zones.plane_of_smoke.mercenary_plane_of_smoke
--- Mercenary of The Plane of Smoke — kill-count task (mephits, ash creatures,
--- flashfires, twisters, blazers, breeze creatures).
---
--- TODO(data): confirm giver NPC, exact target names per objective, and counts.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Mercenary of The Plane of Smoke',
    type = 'mercenary',
    zone = 'smoke',
    completionTask = 'Mercenary of The Plane of Smoke',
    steps = {
        S.pickup({ zone = 'smoke', npc = { name = 'TODO giver', npc = true }, taskName = 'Mercenary of The Plane of Smoke', desc = 'accept mercenary task' }),
        S.combat({ zone = 'smoke', target = { name = 'mephit', npc = true }, taskName = 'Mercenary of The Plane of Smoke', objective = 1, desc = 'kill mephits' }),
        S.combat({ zone = 'smoke', target = { name = 'ash', npc = true }, taskName = 'Mercenary of The Plane of Smoke', objective = 2, desc = 'kill ash creatures' }),
        S.handin({ zone = 'smoke', npc = { name = 'TODO giver', npc = true }, taskName = 'Mercenary of The Plane of Smoke', desc = 'complete mercenary task' }),
    },
})
