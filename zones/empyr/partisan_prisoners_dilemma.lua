--- doprog.zones.empyr.partisan_prisoners_dilemma
---
--- Prisoner's Dilemma (solo task). Source: tbl.eqresource.com/prisonersdilemma
--- Giver/turn-in: Star Stealing Sage (Empyr: Realms of Ash). Request: "could"
--- but you must KILL THE 3 GUARDS around him first (the host clears them on
--- approach). Prereqs: Soldier of Air, Fight Fire, any Trials of Smoke.
---
--- Objectives:
---   1-3. Intercept the messenger to / from the warfront / the towers. 0/1 each
---        -> defeat furtive messengers (around Aalishai and north Plane of Smoke)
---           and loot their messenger cases.
---   4.   Question Blazing Battleworn Eyes. 0/1 -> he roams the SE; hail/aggro,
---        and when his aggro drops say
---        "if you agree to tell us more we will let you go".
---   5-7. Bring each message to Star Stealing Sage.
---   8.   Speak with Great Sky Ocean about the War. 0/1 (Stratos).

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
            desc = "clear Star Stealing Sage's 3 guards" }),
        S.pickup({ zone = 'empyr', npc = SAGE, taskName = TASK, request = 'could',
            desc = 'accept Prisoner\'s Dilemma (say "could")' }),
        -- 1-3: intercept the three messengers (loot the cases).
        S.combat({ taskName = TASK, objective = 1, target = { name = 'messenger', npc = true },
            desc = 'intercept the messenger to the warfront' }),
        S.combat({ taskName = TASK, objective = 2, target = { name = 'messenger', npc = true },
            desc = 'intercept the messenger from the warfront' }),
        S.combat({ taskName = TASK, objective = 3, target = { name = 'messenger', npc = true },
            desc = 'intercept the messenger of the towers' }),
        -- 4: question Blazing Battleworn Eyes (aggro then release phrase).
        S.click({ npc = EYES, action = '/say if you agree to tell us more we will let you go',
            condition = objDone(4),
            desc = 'question Blazing Battleworn Eyes (aggro, then say the release phrase)' }),
        -- 5-7: deliver the three messages to the Sage.
        S.handin({ zone = 'empyr', npc = SAGE, taskName = TASK, objective = 5,
            desc = 'bring the warfront message to Star Stealing Sage' }),
        S.handin({ zone = 'empyr', npc = SAGE, taskName = TASK, objective = 6,
            desc = 'bring the from-warfront message to Star Stealing Sage' }),
        S.handin({ zone = 'empyr', npc = SAGE, taskName = TASK, objective = 7,
            desc = 'bring the tower messages to Star Stealing Sage' }),
        -- 8: report to Great Sky Ocean (say "news"). Disband first if grouped so
        -- everyone can use the prompt (per comments).
        S.click({ zone = 'stratos', npc = OCEAN, action = '/say news',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'speak with Great Sky Ocean about the War (say "news")' }),
    },
})
