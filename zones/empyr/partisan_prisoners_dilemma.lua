--- doprog.zones.empyr.partisan_prisoners_dilemma
---
--- Prisoner's Dilemma (solo task).
--- Source: https://tbl.eqresource.com/prisonersdilemma.php
--- Giver/turn-in: Star Stealing Sage (Empyr: Realms of Ash). Request: "could",
--- but the 3 guards around him must be killed first (host clears them on
--- approach). Prereqs: Soldier of Air, Fight Fire, any Trials of Smoke.
--- 30-minute lockout, repeatable. Reward: ~283pp; Partisan of Empyr achievement.
---
--- Objectives (in order):
---   1. Intercept messenger going to the warfront. 0/1
---   2. Intercept messenger coming from the warfront. 0/1
---   3. Intercept messenger that travels the towers. 0/1
---      -> three roaming messengers; updates come fast in the valley N of the
---         guards (per comments). Combat is objective-gated.
---   4. Question Blazing Battleworn Eyes. 0/1 -> he roams the SE-most section;
---      engage him, and when he drops aggro (after the "die" emote) say
---      "If you agree to tell us more we will let you go".
---   5. Bring the message to the warfront to Star Stealing Sage. 0/1
---   6. Bring the message from the warfront to Star Stealing Sage. 0/1
---   7. Bring the messages from the Empyr towers to Star Stealing Sage. 0/1
---   8. Speak with Great Sky Ocean about the War. 0/1 (Stratos: Zephyr's Flight)
---      -> if grouped, disband first so each member can use the prompt (comments).

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = "Prisoner's Dilemma"
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local SAGE = { name = 'Star Stealing Sage', npc = true }
local EYES = { name = 'Blazing Battleworn Eyes', npc = true }
local OCEAN = { name = 'Great Sky Ocean', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'empyr',
    completionTask = TASK,
    prereq = { tasks = { 'Soldier of Air', 'Fight Fire', 'Trial of Three' } },
    steps = {
        -- Clear the 3 guards around the Sage so he is talkable, then accept.
        S.combat({ zone = 'empyr', target = { name = 'guard', npc = true, radius = 50 },
            desc = "clear the 3 guards around Star Stealing Sage" }),
        S.pickup({ zone = 'empyr', npc = SAGE, taskName = TASK, request = 'could',
            desc = 'accept Prisoner\'s Dilemma (say "could")' }),
        -- 1-3: intercept the three roaming messengers (objective-gated kills).
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1,
            target = { name = 'messenger', npc = true },
            desc = 'intercept the messenger going to the warfront (obj 1)' }),
        S.combat({ zone = 'empyr', taskName = TASK, objective = 2,
            target = { name = 'messenger', npc = true },
            desc = 'intercept the messenger coming from the warfront (obj 2)' }),
        S.combat({ zone = 'empyr', taskName = TASK, objective = 3,
            target = { name = 'messenger', npc = true },
            desc = 'intercept the messenger that travels the towers (obj 3)' }),
        -- 4: engage Blazing Battleworn Eyes (SE), then say the release phrase
        -- once he drops aggro. The host engages; doprog says the phrase.
        S.click({ zone = 'empyr', npc = EYES,
            action = '/say If you agree to tell us more we will let you go',
            condition = objDone(4),
            desc = 'question Blazing Battleworn Eyes: engage, then say the release phrase (obj 4)' }),
        -- 5-7: deliver each message to the Sage (objective-gated turn-ins).
        S.handin({ zone = 'empyr', npc = SAGE, taskName = TASK, objective = 5,
            desc = 'bring the message to the warfront to Star Stealing Sage (obj 5)' }),
        S.handin({ zone = 'empyr', npc = SAGE, taskName = TASK, objective = 6,
            desc = 'bring the message from the warfront to Star Stealing Sage (obj 6)' }),
        S.handin({ zone = 'empyr', npc = SAGE, taskName = TASK, objective = 7,
            desc = 'bring the tower messages to Star Stealing Sage (obj 7)' }),
        -- 8: report to Great Sky Ocean in Stratos (objective-gated; completes task).
        S.handin({ zone = 'stratos', npc = OCEAN, taskName = TASK, objective = 8,
            desc = 'speak with Great Sky Ocean about the War (obj 8)' }),
    },
})
