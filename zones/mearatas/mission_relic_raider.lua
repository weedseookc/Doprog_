--- doprog.zones.mearatas.mission_relic_raider
---
--- Relic Raider. Source: https://tbl.eqresource.com/relicraider.php
--- Group mission (1-6), 6h limit, 30m lockout, repeatable. There is no NPC giver
--- and no request keyword: the mission is BOTH requested and zoned into by
--- RIGHT-CLICKING the relic keeper's key looted during Mold Seeker, while inside
--- Mearatas. Chest loot: Battleworn Stalwart Moon Binding Head/Legs Muhbis,
--- Fashioned Hope Stone, Glowing Gem of Stone, Glowing Spellbound Lamp.
---
--- Objective 1 (relic guardians) is a fixed wave gauntlet, broken out so doprog
--- drives each wave's target in order: 2 armors -> 3 mephits -> 1 earth elemental
--- -> Iron Heart. During Iron Heart a boulder emote targets a player and follows
--- them; doprog flees it (escape vector from the live boulder spawn) while the
--- host keeps DPS on the boss. Comment tip: back into a cubby until ready.
---
--- Objectives (in order):
---   1. Defeat the relic guardians (the wave gauntlet above).
---   2. Steal the duende female mold.
---   3. Open the chest.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Relic Raider'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local ARMOR = { name = 'armor', npc = true }
---@type doprog.SpawnQuery
local MEPHIT = { name = 'mephit', npc = true }
---@type doprog.SpawnQuery
local ELEMENTAL = { name = 'earth elemental', npc = true }
---@type doprog.SpawnQuery
local IRON_HEART = { name = 'Iron Heart', npc = true }

---@type doprog.Mission
return Mission.new({
    name = TASK,
    zone = 'mearatas',
    completionTask = TASK,
    lockoutMinutes = 30,
    prereq = { tasks = {
        'Soldier of Air', 'Fight Fire', 'Trial of Three', "Prisoner's Dilemma",
        'Palace of Embers', 'Brass Palace', 'Key to the Kingdom', 'Contract of War',
        'All Hail the King', 'Royal Visits', 'Tyrant of Fire', 'Enter Mearatas',
        'Serving Another Master', 'Earthen Dirge', 'Mold Seeker',
    } },
    steps = {
        -- Request: right-click the Mold Seeker key (in Mearatas) and accept the
        -- task window. There is no porter NPC or request phrase for this mission.
        S.click({ zone = 'mearatas',
            action = '/multiline ; /itemnotify "relic keeper\'s key" rightmouseup'
                .. ' ; /notify TaskSelectWnd TSEL_AcceptButton leftmouseup',
            condition = function(ctx) return ctx.task:has(TASK) end,
            desc = "right-click the relic keeper's key to request Relic Raider" }),
        -- Zone-in: right-click the same key again to enter the instance.
        S.click({ action = '/itemnotify "relic keeper\'s key" rightmouseup', completeAfter = 4000,
            condition = function(ctx) return ctx.mq:zoneShortName() == 'mearatas' and ctx.task:has(TASK) end,
            desc = 'right-click the key again to zone into the instance' }),
        -- 1: wave gauntlet, one target type at a time (armors -> mephits ->
        -- elemental -> boss). Each combat step clears all spawns matching its name.
        S.combat({ target = ARMOR, desc = 'wave 1: defeat the 2 armors' }),
        S.combat({ target = MEPHIT, desc = 'wave 2: defeat the 3 mephits' }),
        S.combat({ target = ELEMENTAL, desc = 'wave 3: defeat the earth elemental' }),
        S.combat({ taskName = TASK, objective = 1, target = IRON_HEART,
            mechanics = {
                { react = 'flee', emote = 'boulder', spawn = { name = 'boulder' }, distance = 50,
                  desc = 'Iron Heart boulder emote: run the boulder away from the group' },
            },
            desc = 'boss: defeat Iron Heart (flee the boulder)' }),
        -- 2: steal the duende female mold (ground/relic clicky).
        S.click({ action = '/multiline ; /itemtarget "female mold" ; /click left item',
            condition = objDone(2), desc = 'steal the duende female mold' }),
        -- 3: open the chest to complete the mission.
        S.click({ action = '/multiline ; /itemtarget "chest" ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
