--- doprog.zones.plane_of_smoke.trials.trial_eternal_cyclone
---
--- Trial of the Eternal Cyclone (group trial). Source:
--- tbl.eqresource.com/trialoftheeternalcyclone
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; any one progresses you.
---
--- Boss: Disappointed Heart's Torrent (rooted, no summon). HP-locked while adds
--- are up; Gust/Gritty adds spawn every 1-2 min (don't let them combine). After
--- ~30 min it casts Gathering Torrent (-105959 HP); powers up ~45 min. Then chest.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Trial of the Eternal Cyclone'
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = TASK, request = 'prepared',
            desc = 'start Trial of the Eternal Cyclone (say "prepared")' }),
        S.combat({ zone = 'smoke', target = { name = "Disappointed Heart's Torrent", npc = true },
            desc = "defeat Disappointed Heart's Torrent (kill adds; HP-locked while adds up)" }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
