--- doprog.zones.plane_of_smoke.mercenary_plane_of_smoke
--- Mercenary of The Plane of Smoke — optional kill-count grind (mephits, ash
--- creatures, flashfires, twisters, blazers, breeze creatures). Objective-driven
--- combat; doprog watches the task objectives while the host kills.
---
--- The giver's exact name is not published on eqresource's NPC list; set it once
--- confirmed in-game. Until then this quest is left out of the zone index so it
--- never blocks progression.
local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

---@type doprog.Quest
return Quest.new({
    name = 'Mercenary of The Plane of Smoke',
    type = 'mercenary',
    zone = 'smoke',
    completionTask = 'Mercenary of The Plane of Smoke',
    steps = {
        S.pickup({ zone = 'smoke', npc = { name = 'Mercenary', npc = true }, taskName = 'Mercenary of The Plane of Smoke', desc = 'accept mercenary task' }),
        S.combat({ zone = 'smoke', taskName = 'Mercenary of The Plane of Smoke', objective = 1, desc = 'kill smoke creatures' }),
        S.handin({ zone = 'smoke', npc = { name = 'Mercenary', npc = true }, taskName = 'Mercenary of The Plane of Smoke', desc = 'complete mercenary task' }),
    },
})
