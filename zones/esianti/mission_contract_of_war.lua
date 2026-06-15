--- doprog.zones.esianti.mission_contract_of_war
---
--- Contract of War (group mission 1-6). Source: tbl.eqresource.com/contractofwar
--- Requested from Great Sky Ocean (Stratos) by saying "mission"; enter the
--- instance by saying "to go". 6h limit, 5h lockout. Heavy prereq chain.
---
--- Objectives:
---   1. Defeat the palace guardian and acquire a writ. 0/1 -> 3 named guardians
---      spawn in random order; defeat them and loot "Writ of Access". Named:
---      Sunshine Sensible Warmth (Crippling Knives: DoT+mana drain/snare),
---      Radiant Fog Evening (Suffocating Breeze: cure with Curse),
---      Feather Silver Sheen (Gouging Strike; spawns mezzable adds).
---   2. Speak with the king. 0/1 -> click the Moon Serf of Harmonious Heavens
---      door from OUTSIDE, defeat the mephits it spawns, then say
---      "do you know who will follow" to Moon Serf (hailing stops mephit spawns).
---   3. Open the chest. 0/1.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Contract of War'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local GIVER = { name = 'Great Sky Ocean', npc = true }
---@type doprog.SpawnQuery
local MOON_SERF = { name = 'Moon Serf of Harmonious Heavens', npc = true }

---@type doprog.Mission
return Mission.new({
    name = TASK,
    zone = 'esianti',
    completionTask = TASK,
    requestNpc = GIVER,
    requestSay = 'mission',
    lockoutMinutes = 300,
    prereq = { tasks = {
        'Soldier of Air', 'Fight Fire', 'Trial of Three',
        "Prisoner's Dilemma", 'Palace of Embers', 'Brass Palace', 'Key to the Kingdom',
    } },
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = TASK, request = 'mission',
            desc = 'request Contract of War (say "mission")' }),
        S.click({ zone = 'stratos', npc = GIVER, action = '/say to go',
            desc = 'enter the Contract of War instance (say "to go")' }),
        -- 1: defeat the palace guardians (random order), loot the writ.
        S.combat({ taskName = TASK, objective = 1,
            target = { npc = true, radius = 1000,
                exclude = { 'mephit', 'a ', 'pet' } },
            desc = 'defeat the palace guardian (Sunshine/Radiant Fog/Feather Silver)' }),
        S.loot({ item = 'Writ of Access', desc = 'loot Writ of Access from a guardian' }),
        -- 2: open the king's door, clear mephits, then speak with Moon Serf.
        S.click({ action = '/multiline ; /target Moon Serf ; /click left door',
            condition = objDone(2), desc = 'click the Moon Serf door (from outside)' }),
        S.combat({ taskName = TASK, objective = 2,
            target = { name = 'mephit', npc = true },
            desc = 'defeat the mephits the king spawns' }),
        S.click({ npc = MOON_SERF, action = '/say do you know who will follow',
            condition = objDone(2), desc = 'speak with the king (Moon Serf)' }),
        -- 3: open the chest.
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest' }),
    },
})
