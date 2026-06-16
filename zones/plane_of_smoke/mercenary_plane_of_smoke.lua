--- doprog.zones.plane_of_smoke.mercenary_plane_of_smoke
---
--- Mercenary of The Plane of Smoke — optional kill-count grind (mephits, ash
--- creatures, flashfires, twisters, blazers, breeze creatures). Source:
--- tbl.eqresource.com/questsnpcplaneofsmoke returned HTTP 404 on 2026-06-16, so
--- the giver's exact name could not be confirmed; the placeholder giver below is
--- left as-is and this quest stays OUT of the zone index so it never blocks
--- progression. The kill/return steps are objective-driven: doprog advertises
--- NEED_COMBAT and watches the task objective while the host kills, then hands the
--- task back in. Set the giver's real name + zone marker once confirmed in-game.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Mercenary of The Plane of Smoke'
---@type doprog.SpawnQuery
local GIVER = { name = 'Mercenary', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = GIVER, taskName = TASK,
            desc = 'accept the Plane of Smoke mercenary task' }),
        S.combat({ zone = 'smoke', taskName = TASK, objective = 1,
            desc = 'kill smoke creatures until the kill-count objective ticks over' }),
        S.handin({ zone = 'smoke', npc = GIVER, taskName = TASK,
            desc = 'return to the giver to complete the mercenary task' }),
    },
})
