--- doprog.zones.plane_of_smoke.trials.trial_wending_ways
---
--- Trial of the Wending Ways (group trial). Source:
--- tbl.eqresource.com/trialofthewendingways
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; any one progresses you.
---
--- Defeat four elemental bosses; the order is set by which element has the most
--- portals visible (recount after each kill). doprog targets each in turn:
---   Blazing Triumphant Bulwark (fire) — drag to braziers; only damageable when
---     it "gains solidity".
---   Obsidian Undefeated Shield (earth) — splits at 50% into Obsidian Fragment +
---     Obsidian Shard (Shard is mezzable).
---   Flowing Unconquered Guard (water).
---   Blustering Stalwart Screen (wind).
--- Then open the chest.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Trial of the Wending Ways'
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }

-- TODO(calibrate): the three brazier /loc spots for the fire boss drag.
---@type doprog.Vec3?
local BRAZIER = nil

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = TASK, request = 'prepared',
            desc = 'start Trial of the Wending Ways (say "prepared")' }),
        S.combat({ zone = 'smoke', target = { name = 'Blazing Triumphant Bulwark', npc = true },
            mechanics = {
                { react = 'drag', loc = BRAZIER,
                  desc = 'drag the fire boss to a brazier; it is only damageable when it "gains solidity"' },
            },
            desc = 'defeat the fire boss (drag to braziers; damage only when solid)' }),
        S.combat({ zone = 'smoke', target = { name = 'Obsidian Undefeated Shield', npc = true },
            desc = 'defeat the earth boss (splits at 50%)' }),
        S.combat({ zone = 'smoke', target = { name = 'Flowing Unconquered Guard', npc = true },
            desc = 'defeat the water boss' }),
        S.combat({ zone = 'smoke', target = { name = 'Blustering Stalwart Screen', npc = true },
            desc = 'defeat the wind boss' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
