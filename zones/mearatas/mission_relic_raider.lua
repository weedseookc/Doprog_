--- doprog.zones.mearatas.mission_relic_raider
---
--- Relic Raider (group mission 1-6). Source: tbl.eqresource.com/relicraider
--- Requested AND zoned into by RIGHT-CLICKING the key looted during Mold Seeker,
--- inside Mearatas. Quest giver token: Key of the Relic Keeper. 6h limit.
---
--- Objectives:
---   1. Defeat the relic guardians. 0/1 -> waves: 2 armors, 3 mephits, 1 earth
---      elemental, then the boss Iron Heart (boulder emote follows a player —
---      run it away; evading it earns "Perfect Timing").
---   2. Steal the duende female mold. 0/1.
---   3. Open the chest. 0/1.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Relic Raider'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local GIVER = { name = 'Key of the Relic Keeper', npc = true }

---@type doprog.Mission
return Mission.new({
    name = TASK,
    zone = 'mearatas',
    completionTask = TASK,
    requestNpc = GIVER,
    requestSay = 'relic raider',
    lockoutMinutes = 30,
    prereq = { tasks = {
        'Soldier of Air', 'Fight Fire', 'Trial of Three', "Prisoner's Dilemma",
        'Palace of Embers', 'Brass Palace', 'Key to the Kingdom', 'Contract of War',
        'All Hail the King', 'Royal Visits', 'Tyrant of Fire', 'Enter Mearatas',
        'Serving Another Master', 'Earthen Dirge', 'Mold Seeker',
    } },
    steps = {
        -- Request + zone-in are both right-clicking the Mold Seeker key.
        S.click({ zone = 'mearatas',
            action = "/multiline ; /itemnotify \"relic keeper's key\" rightmouseup ; /notify TaskSelectWnd TSEL_AcceptButton leftmouseup",
            condition = function(ctx) return ctx.task:has(TASK) end,
            desc = "right-click the relic keeper's key to get Relic Raider" }),
        S.click({ action = "/itemnotify \"relic keeper's key\" rightmouseup",
            condition = function(ctx) return ctx.mq:zoneShortName() == 'mearatas' and ctx.task:has(TASK) end,
            completeAfter = 4000, desc = 'right-click the key again to zone into the instance' }),
        -- 1: clear the waves and Iron Heart.
        S.combat({ taskName = TASK, objective = 1, target = { npc = true, radius = 1000 },
            desc = 'defeat the relic guardians: armors -> mephits -> earth elemental -> Iron Heart' }),
        -- 2: steal the mold.
        S.click({ action = '/multiline ; /itemtarget female mold ; /click left item',
            condition = objDone(2), desc = 'steal the duende female mold' }),
        -- 3: open the chest.
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
