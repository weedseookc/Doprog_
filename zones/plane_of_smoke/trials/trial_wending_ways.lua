--- doprog.zones.plane_of_smoke.trials.trial_wending_ways
---
--- Trial of the Wending Ways (group trial, 1-6). Source:
--- tbl.eqresource.com/trialofthewendingways
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; defeating any one progresses you.
--- 6h limit, 60h lockout, repeatable.
---
--- ORDER (per eqresource): "the most portal types you see around the area
--- determines which ambassador to fight next" — recount after each kill. doprog
--- SOLVES this with `portal_solver`, which counts portals per element each frame
--- (white=air, red=fire, blue=water, green=earth) and feeds the most-portals
--- element's boss to a dynamic-target CombatStep.
---   Blazing Triumphant Bulwark (fire): drag him onto the burning areas until the
---     emote about "changing back" (positioning mechanic below).
---   Obsidian Undefeated Shield (earth): splits into 2 adds at 50% (host fights the
---     adds; doprog keeps targeting any living boss/add via the solver).
---   Flowing Unconquered Guard (water), Blustering Stalwart Screen (wind).

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')
local PortalSolver = require('doprog.zones.plane_of_smoke.trials.portal_solver')

local TASK = 'Trial of the Wending Ways'
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }

-- The fire boss must be dragged onto a "burning area"; its floor /loc is not
-- published, so it is left nil (the drag mechanic is a no-op until calibrated
-- in-game). The emote substring below still arms the watcher for that reaction.
---@type doprog.Vec3?
local BURNING_AREA = nil

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
            desc = 'start Trial of the Wending Ways (say "prepared" inside the instance)' }),
        -- Fight the bosses in most-portals-first order, recomputed each frame.
        S.combat({
            zone = 'smoke',
            target = function(ctx) return solver:nextTarget(ctx) end,
            mechanics = {
                { react = 'drag', loc = BURNING_AREA, emote = 'changing back',
                  desc = 'drag Blazing Triumphant Bulwark onto a burning area to keep it damageable' },
            },
            desc = 'defeat the four elemental ambassadors, most-portals-first',
        }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest to complete the trial' }),
    },
})
