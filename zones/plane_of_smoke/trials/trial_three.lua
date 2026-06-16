--- doprog.zones.plane_of_smoke.trials.trial_three
---
--- Trial of Three (group trial, 1-6). Source: tbl.eqresource.com/trialofthree
--- Started inside the Trials of Smoke instance by saying "prepared" to Waves of
--- Saffron Sky. One of the five trials; completing any one progresses you.
--- 6h limit, 60h lockout.
---
--- THE PUZZLE: three elemental bosses must be defeated in a specific order. At the
--- start the trial emotes a clue for the FIRST mob and a clue for the THIRD; the
--- SECOND is found by elimination (per eqresource + comments). doprog now SOLVES
--- this at run time: `clue_solver` captures the clue emotes, decodes each
--- (size/position/element), resolves it to a named boss, and feeds the kill order
--- to a single dynamic-target CombatStep. While the clues are not yet solved the
--- step WAITs rather than killing in the wrong order (a wrong kill resets it).
--- See clue_solver.lua for the decode/resolve details and its limits.
---
--- Bosses (max melee ~35-40k each):
---   Dark Waters Sing   (water)
---   Warm Heart Flickers(fire)
---   Shadows of Stone   (earth)
--- Per eqresource comments: every member must enter the room together on engage
--- or be kicked out / blinded; stay on the hailed mob and do NOT push the bosses
--- to the room edges (they leash). doprog therefore holds the lead on the targeted
--- boss (no flee/kite) so it is never dragged out to a leash point.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')
local ClueSolver = require('doprog.zones.plane_of_smoke.trials.clue_solver')

local TASK = 'Trial of Three'
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }

local solver = ClueSolver.new({
    { name = 'Dark Waters Sing', element = 'water' },
    { name = 'Warm Heart Flickers', element = 'fire' },
    { name = 'Shadows of Stone', element = 'earth' },
})

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = TASK, request = 'prepared',
            desc = 'start Trial of Three (say "prepared" inside the Trials instance)' }),
        -- One combat step whose target is resolved from the solved clue order:
        -- doprog targets the correct boss next, in sequence, until all three die.
        S.combat({
            zone = 'smoke',
            target = function(ctx) return solver:nextTarget(ctx) end,
            desc = 'defeat the three bosses in the clue-solved order',
        }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest to complete the trial' }),
    },
})
