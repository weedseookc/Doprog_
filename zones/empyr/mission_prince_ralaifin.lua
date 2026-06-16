--- doprog.zones.empyr.mission_prince_ralaifin
---
--- Prince Ralaifin (group mission, 1-6). Source:
--- tbl.eqresource.com/princeralaifin
--- Requested from Horizon Blighted Sage (Empyr: Realms of Ash) by saying
--- "gathered"; enter the instance by saying "ready". 6h limit, 5h lockout.
---
--- Objectives (in order):
---   1. Kill 4 Ralaifin Ecclesiastic. 0/4.
---   2. Open the chest. 0/1.
---
--- POSITIONING (doprog moves the lead; the host deals damage):
---   * "...reaching rapture" emote -> break line of sight and stand Z-lower than
---     the named (~15s window). The valley hide /loc is unpublished, so HIDE_LOC
---     is left for in-game calibration; until set, the watcher logs the reaction
---     and the crew must duck LoS manually for that window.
---   * The named attack from within fire auras: hold the tank in the aura while
---     DPS/healers stay behind the mob so the directional AEs miss. The aura
---     /loc is unpublished (AURA_LOC), so it is a standing rule pending calibration.
---   * Individual emotes (a mana-drain named and an AC-debuff named): the affected
---     player runs out of the group. The per-named emote strings are unpublished,
---     so this stays a manual call — encoding it as an always-on flee would break
---     the tank's aura position, so it is intentionally not added until the emote
---     text is known (then add a flee mechanic keyed to that emote).
---   * Spider adds spawn during the fight and are cleared by the host as part of
---     the NEED_COMBAT handoff.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Prince Ralaifin'
---@type doprog.SpawnQuery
local SAGE = { name = 'Horizon Blighted Sage', npc = true }
local ECCLESIASTIC = { name = 'Ralaifin Ecclesiastic', npc = true }

-- /loc spots are unpublished; set these in-game to enable the loc-based reactions.
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
            desc = 'request Prince Ralaifin from the Sage (say "gathered")' }),
        S.click({ zone = 'empyr', npc = SAGE, action = '/say ready',
            desc = 'enter the Prince Ralaifin instance (say "ready")' }),
        -- 1: kill the 4 named; honour the rapture/aura/individual-emote mechanics.
        S.combat({ taskName = TASK, objective = 1, target = ECCLESIASTIC,
            mechanics = {
                { react = 'hide', emote = 'reaching rapture', window = 16, loc = HIDE_LOC,
                  desc = 'rapture: break LoS in the valley, Z-lower than the named (~15s)' },
                { react = 'aura', loc = AURA_LOC,
                  desc = 'tank the named in the fire aura; keep DPS/healers behind it' },
            },
            desc = 'kill 4 Ralaifin Ecclesiastic (host clears spider adds; mind the emotes)' }),
        -- 2: open the chest (target the object before clicking).
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest (obj 2)' }),
    },
})
