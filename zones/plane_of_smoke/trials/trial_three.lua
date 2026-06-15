--- doprog.zones.plane_of_smoke.trials.trial_three
---
--- Trial of Three (group trial, 1-6). Source: tbl.eqresource.com/trialofthree
--- Started inside the Trials of Smoke instance by saying "prepared" to Waves of
--- Saffron Sky. One of the five trials; completing any one progresses you.
--- 6h limit, 60h lockout.
---
--- Single objective: "Defeat any trial you have not already defeated. 0/1"
--- The trial is a PUZZLE: three elemental bosses must be defeated in an order
--- derived from four clue lines shown at the start (size / weapon / position /
--- element). The clue mapping is randomized per run, so the *order* cannot be
--- baked in here — doprog targets each boss and closes distance; the correct
--- defeat order is read from the clues at run time (a clue parser is a planned
--- enhancement). After all three, open the chest.
---
--- Bosses (all max melee ~35-40k, AE-warned by an emote):
---   Dark Waters Sing   (water): Water Blast (DD+knockback), Boiling Mana (mana AE)
---   Warm Heart Flickers(fire) : Flaming Defense (DS), Burning Embers (AE + DoT)
---   Shadows of Stone   (earth): Crushing Earth (AE + 3s stun), Choking Dust (silence)
--- Note: all members must be in the room on engage or take a blind DoT; mobs leash
--- at room edges.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Trial of Three'
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
            desc = 'start Trial of Three (say "prepared" inside the Trials instance)' }),
        -- Defeat the three bosses. Order is clue-driven; doprog targets each.
        S.combat({ target = { name = 'Dark Waters Sing', npc = true },
            desc = 'defeat Dark Waters Sing (water) in clue order' }),
        S.combat({ target = { name = 'Warm Heart Flickers', npc = true },
            desc = 'defeat Warm Heart Flickers (fire) in clue order' }),
        S.combat({ target = { name = 'Shadows of Stone', npc = true },
            desc = 'defeat Shadows of Stone (earth) in clue order' }),
        -- Claim the reward chest to register the trial.
        S.click({ taskName = TASK, action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest to complete the trial' }),
    },
})
