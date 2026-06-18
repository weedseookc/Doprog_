--- doprog.zones.plane_of_smoke.mercenary_plane_of_smoke
---
--- Mercenary of The Plane of Smoke — optional kill-count grind in the STATIC
--- Plane of Smoke (enterable only after all five Trials of Smoke are done).
--- Source: references/eqresource/trials_of_smoke_overview.md (the quests-by-name
--- page 404s; givers confirmed from the overview research).
---
--- There are actually SIX mercenary kill tasks split across two givers:
---   * Darkened Victorious Scholar -> Ash Creatures / Flashfires / Blazes
---   * Emerald Hope of the Stars   -> Mephits / Twisters / Breeze Creatures
--- Completing all six earns the "Mercenary of The Plane of Smoke" achievement.
--- This file encodes the Darkened Victorious Scholar "Ash Creatures" task as the
--- representative; it stays OUT of the zone index (optional grind, and it needs
--- the static zone) so it never blocks progression. The exact request phrases and
--- kill counts are not published; objective-driven combat handles the count.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Mercenary of The Plane of Smoke'
---@type doprog.SpawnQuery
local GIVER = { name = 'Darkened Victorious Scholar', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'mercenary',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = GIVER, taskName = TASK,
            desc = 'accept a Plane of Smoke mercenary task from Darkened Victorious Scholar' }),
        S.combat({ zone = 'smoke', taskName = TASK, objective = 1,
            target = { name = 'ash', npc = true },
            desc = 'kill Ash Creatures until the objective ticks over' }),
        S.handin({ zone = 'smoke', npc = GIVER, taskName = TASK,
            desc = 'return to Darkened Victorious Scholar' }),
    },
})
