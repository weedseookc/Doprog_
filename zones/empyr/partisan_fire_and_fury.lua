--- doprog.zones.empyr.partisan_fire_and_fury
---
--- Fire and Fury (solo task). Source: tbl.eqresource.com/fireandfury
--- Giver/turn-in: Horizon Blighted Sage (Empyr: Realms of Ash). Request:
--- "curious". Prereqs: Soldier of Air, Fight Fire, any Trials of Smoke.
---
--- Objectives:
---   1. Kill 3 Wildfire Phoenix. 0/3 -> only certain ones count; one of the four
---      visible from Horizon counts, the cluster at the south bridge base does not.
---   2. Reveal the Truth. 0/1 -> use the debuff item given on task request on a
---      phoenix and defeat it while debuffed (best when it is already low); a lava
---      elemental may spawn and must be defeated.
---   3. Deliver 1 Rebirth of Heaven's Truth Wand to Horizon Blighted Sage. 0/1.
---   4. Speak with Horizon Blighted Sage about the truth -> say "truth".

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Fire and Fury'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local SAGE = { name = 'Horizon Blighted Sage', npc = true }
local PHOENIX = { name = 'Wildfire Phoenix', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'empyr',
    completionTask = TASK,
    prereq = { tasks = { 'Soldier of Air', 'Fight Fire', 'Trial of Three' } },
    steps = {
        S.pickup({ zone = 'empyr', npc = SAGE, taskName = TASK, request = 'curious',
            desc = 'accept Fire and Fury (say "curious")' }),
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1, target = PHOENIX,
            desc = 'kill 3 Wildfire Phoenix (only the qualifying ones count)' }),
        -- 2: reveal the truth (debuff item on a phoenix; lava elemental may spawn).
        S.combat({ zone = 'empyr', taskName = TASK, objective = 2, target = PHOENIX,
            desc = 'use the debuff item on a phoenix and defeat it (kill the lava elemental too)' }),
        -- 3: deliver the wand.
        S.handin({ zone = 'empyr', npc = SAGE, taskName = TASK, objective = 3,
            items = { "Rebirth of Heaven's Truth Wand" }, desc = 'deliver the wand to the Sage' }),
        -- 4: say "truth".
        S.click({ zone = 'empyr', npc = SAGE, action = '/say truth',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'speak with the Sage about the [truth]' }),
    },
})
