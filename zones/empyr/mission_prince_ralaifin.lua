--- doprog.zones.empyr.mission_prince_ralaifin
---
--- Prince Ralaifin (group mission 1-6). Source: tbl.eqresource.com/princeralaifin
--- Requested from Horizon Blighted Sage (Empyr) by saying "gathered"; enter the
--- instance by saying "ready". 6h limit, 5h lockout.
---
--- Objectives:
---   1. Kill 4 Ralaifin Ecclesiastic. 0/4 -> individual emotes cause effects (mana
---      drain / AC debuff — run out); on "The prayers to Prince Ralaifin are
---      reaching rapture" hide from the bridge NPC line of sight (~15s, drop into
---      the valley); spider adds spawn and must be cleared.
---   2. Open the chest. 0/1.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Prince Ralaifin'
---@type doprog.SpawnQuery
local SAGE = { name = 'Horizon Blighted Sage', npc = true }

---@type doprog.Mission
return Mission.new({
    name = TASK,
    zone = 'empyr',
    completionTask = TASK,
    requestNpc = SAGE,
    requestSay = 'gathered',
    lockoutMinutes = 300,
    prereq = { tasks = {
        'Soldier of Air', 'Fight Fire', 'Trial of Three',
        "Prisoner's Dilemma", 'Palace of Embers', 'Fire and Fury',
    } },
    steps = {
        S.pickup({ zone = 'empyr', npc = SAGE, taskName = TASK, request = 'gathered',
            desc = 'request Prince Ralaifin (say "gathered")' }),
        S.click({ zone = 'empyr', npc = SAGE, action = '/say ready',
            desc = 'enter the Prince Ralaifin instance (say "ready")' }),
        S.combat({ taskName = TASK, objective = 1,
            target = { name = 'Ralaifin Ecclesiastic', npc = true },
            desc = 'kill 4 Ralaifin Ecclesiastic (hide on the rapture emote; clear spider adds)' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest' }),
    },
})
