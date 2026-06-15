--- doprog.zones.plane_of_smoke.trials.trial_wending_ways
---
--- Trial of the Wending Ways (group trial). Source:
--- tbl.eqresource.com/trialofthewendingways
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; any one progresses you.
---
--- ORDER: the element with the MOST portals visible is fought first; recount after
--- each kill. doprog SOLVES this with `portal_solver` (counts portals per element
--- each frame) and feeds the order to a dynamic-target CombatStep. The fire boss
--- additionally must be dragged to a brazier and is only damageable when it
--- "gains solidity" (positioning mechanic on that target).
---   Blazing Triumphant Bulwark (fire), Obsidian Undefeated Shield (earth, splits
---   at 50%), Flowing Unconquered Guard (water), Blustering Stalwart Screen (wind).

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')
local PortalSolver = require('doprog.zones.plane_of_smoke.trials.portal_solver')

local TASK = 'Trial of the Wending Ways'
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }

-- TODO(calibrate): the brazier /loc to drag the fire boss to.
---@type doprog.Vec3?
local BRAZIER = nil

local solver = PortalSolver.new({
    { name = 'Blazing Triumphant Bulwark', element = 'fire' },
    { name = 'Obsidian Undefeated Shield', element = 'earth' },
    { name = 'Flowing Unconquered Guard', element = 'water' },
    { name = 'Blustering Stalwart Screen', element = 'wind' },
})

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = TASK, request = 'prepared',
            desc = 'start Trial of the Wending Ways (say "prepared")' }),
        -- Fight the bosses in most-portals-first order, recomputed each frame.
        S.combat({
            zone = 'smoke',
            target = function(ctx) return solver:nextTarget(ctx) end,
            mechanics = {
                { react = 'drag', loc = BRAZIER,
                  desc = 'if fighting the fire boss: drag it to a brazier (damage it only when solid)' },
            },
            desc = 'defeat the four elemental bosses, most-portals-first',
        }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
