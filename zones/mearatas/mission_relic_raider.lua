--- doprog.zones.mearatas.mission_relic_raider
---
--- Relic Raider (group mission 1-6). Source: tbl.eqresource.com/relicraider
--- Requested AND zoned into by RIGHT-CLICKING the key looted during Mold Seeker,
--- inside Mearatas. Quest giver token: Key of the Relic Keeper. 6h limit.
---
--- Objective 1 is a wave gauntlet, broken out here so doprog drives each wave's
--- target in order:  2 armors -> 3 mephits -> 1 earth elemental -> Iron Heart.
--- During Iron Heart, a boulder targets a player and follows them — doprog flees
--- it (computed escape vector) while the host keeps DPS on the boss. Tip from
--- comments: back into a cubby so nothing aggros until ready, then drop to centre.
---
--- Objectives:
---   1. Defeat the relic guardians. 0/1.
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
        -- 1: wave gauntlet, one target type at a time.
        S.combat({ target = { name = 'armor', npc = true }, desc = 'wave 1: 2 armors' }),
        S.combat({ target = { name = 'mephit', npc = true }, desc = 'wave 2: 3 mephits' }),
        S.combat({ target = { name = 'earth elemental', npc = true }, desc = 'wave 3: earth elemental' }),
        S.combat({ taskName = TASK, objective = 1, target = { name = 'Iron Heart', npc = true },
            mechanics = {
                { react = 'flee', emote = 'boulder', spawn = { name = 'boulder' }, distance = 50,
                  desc = 'Iron Heart boulder: run it away from the group' },
            },
            desc = 'boss: defeat Iron Heart' }),
        -- 2: steal the mold.
        S.click({ action = '/multiline ; /itemtarget female mold ; /click left item',
            condition = objDone(2), desc = 'steal the duende female mold' }),
        -- 3: open the chest.
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
