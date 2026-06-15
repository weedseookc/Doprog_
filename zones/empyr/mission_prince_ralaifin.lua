--- doprog.zones.empyr.mission_prince_ralaifin
---
--- Prince Ralaifin (group mission 1-6). Source: tbl.eqresource.com/princeralaifin
--- Requested from Horizon Blighted Sage (Empyr) by saying "gathered"; enter the
--- instance by saying "ready". 6h limit, 5h lockout.
---
--- Objectives:
---   1. Kill 4 Ralaifin Ecclesiastic. 0/4.
---   2. Open the chest. 0/1.
---
--- POSITIONING (doprog moves the lead; host does damage):
---   * "...reaching rapture" emote -> everyone must break line of sight in the
---     valley, Z-axis LOWER than the named, ~15s window. (HIDE_LOC must be the
---     valley /loc; calibrate in-game — until then doprog logs the reaction.)
---   * Tank the named INSIDE the fire auras; keep DPS/healers BEHIND the mob so
---     the directional AEs miss them (AURA_LOC = the aura spot to hold).
---   * Spider adds spawn during the fight and must be cleared (host).
---   * Individual emotes: a mana-drain and an AC-debuff named — the affected
---     player runs out from the group.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Prince Ralaifin'
---@type doprog.SpawnQuery
local SAGE = { name = 'Horizon Blighted Sage', npc = true }

-- TODO(calibrate): fill these /loc spots in-game (valley hide spot; tank aura).
---@type doprog.Vec3?
local HIDE_LOC = nil
---@type doprog.Vec3?
local AURA_LOC = nil

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
            mechanics = {
                { react = 'hide', emote = 'reaching rapture', window = 16, loc = HIDE_LOC,
                  desc = 'rapture: break LoS in the valley, lower than the named (~15s)' },
                { react = 'aura', loc = AURA_LOC,
                  desc = 'tank the named in the fire aura; DPS/healers stay behind it' },
            },
            desc = 'kill 4 Ralaifin Ecclesiastic (clear spider adds; mind the emotes)' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest' }),
    },
})
