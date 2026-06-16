--- doprog.zones.empyr.partisan_fire_and_fury
---
--- Fire and Fury (solo partisan). Source: tbl.eqresource.com/fireandfury
--- Giver/turn-in: Horizon Blighted Sage (Empyr: Realms of Ash). Request:
--- "curious". Prereqs: Soldier of Air, Fight Fire, any Trials of Smoke.
---
--- Objectives (in order):
---   1. Kill 3 Wildfire Phoenix. 0/3 -> only certain phoenixes count; one of the
---      four immediately visible from Horizon counts (per player comments).
---   2. Reveal the Truth. 0/1 -> right-click the wand item handed out on task
---      request onto a phoenix (best while it is low), then defeat the lava
---      elemental that spawns from a successful reveal.
---   3. Deliver 1 Rebirth of Heaven's Truth Wand to Horizon Blighted Sage. 0/1.
---   4. Speak with Horizon Blighted Sage about the [truth] -> say "truth".

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Fire and Fury'
local WAND = "Rebirth of Heaven's Truth Wand"
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local SAGE = { name = 'Horizon Blighted Sage', npc = true }
local PHOENIX = { name = 'Wildfire Phoenix', npc = true }
local ELEMENTAL = { name = 'lava elemental', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'empyr',
    completionTask = TASK,
    prereq = { tasks = { 'Soldier of Air', 'Fight Fire', 'Trial of Three' } },
    steps = {
        S.pickup({ zone = 'empyr', npc = SAGE, taskName = TASK, request = 'curious',
            desc = 'accept Fire and Fury (hail Horizon Blighted Sage, say "curious")' }),
        -- 1: kill 3 qualifying Wildfire Phoenix around the giver.
        S.combat({ zone = 'empyr', taskName = TASK, objective = 1, target = PHOENIX,
            desc = 'kill 3 Wildfire Phoenix near the Sage (only qualifying ones count)' }),
        -- 2a: bring a phoenix low so the wand reveal lands.
        S.combat({ zone = 'empyr', target = PHOENIX,
            desc = 'bring a Wildfire Phoenix low for the reveal' }),
        -- 2b: right-click the wand onto the low phoenix to reveal the truth.
        S.click({ zone = 'empyr', npc = PHOENIX,
            action = '/itemnotify "' .. WAND .. '" rightmouseup',
            condition = objDone(2),
            desc = 'right-click the wand on the low phoenix to Reveal the Truth (obj 2)' }),
        -- 2c: a successful reveal spawns a lava elemental — defeat it.
        S.combat({ zone = 'empyr', target = ELEMENTAL,
            desc = 'defeat the lava elemental spawned by the reveal' }),
        -- 3: deliver the wand to the Sage.
        S.handin({ zone = 'empyr', npc = SAGE, taskName = TASK, objective = 3,
            items = { WAND }, desc = 'deliver the Rebirth of Heaven\'s Truth Wand to the Sage' }),
        -- 4: say "truth" to view the dialogue.
        S.click({ zone = 'empyr', npc = SAGE, action = '/say truth',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'speak with the Sage about the [truth] (say "truth")' }),
    },
})
