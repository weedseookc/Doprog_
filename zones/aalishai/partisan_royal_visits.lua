--- doprog.zones.aalishai.partisan_royal_visits
---
--- Royal Visits (group task). Source: tbl.eqresource.com/royalvisits
--- Giver/turn-in: Sky Orchid Understanding (Esianti). Request: "continue".
--- Spans Aalishai/Esianti instances. (Group: everyone must be in-zone for credit.)
---
--- Objectives:
---   1. Get access to the queen of the efreeti. 0/1 -> turn Windseal in to
---      Dirgeful Ruby Blade (Aalishai) and enter the instance (say "ready").
---   2. Speak with Heart of Flawless Brass. 0/1 -> say "in exchange".
---   3. Speak with Moon Serf of the Harmonious Heavens. 0/1 -> back in Esianti,
---      get instance access from Sky Orchid Understanding (say "ready"), then say
---      "ring with garnets and rubies muhbis".
---   4. Deliver the muhbis to the efreeti queen. 0/1 -> back to Dirgeful Ruby
---      Blade for the final instance; turn the Ring in to Heart of Flawless Brass.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Royal Visits'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local ORCHID = { name = 'Sky Orchid Understanding', npc = true }
local DIRGEFUL = { name = 'Dirgeful Ruby Blade', npc = true }
local HEART = { name = 'Heart of Flawless Brass', npc = true }
local MOON_SERF = { name = 'Moon Serf of the Harmonious Heavens', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'aalishai',
    completionTask = TASK,
    prereq = { tasks = { 'All Hail the King' } },
    steps = {
        S.pickup({ zone = 'esianti', npc = ORCHID, taskName = TASK, request = 'continue',
            desc = 'accept Royal Visits (say "continue")' }),
        -- 1: Windseal -> Dirgeful Ruby Blade, enter instance.
        S.handin({ zone = 'aalishai', npc = DIRGEFUL, taskName = TASK,
            items = { 'Windseal' }, desc = 'turn Windseal in to Dirgeful Ruby Blade' }),
        S.click({ zone = 'aalishai', npc = DIRGEFUL, action = '/say ready',
            condition = objDone(1), desc = 'enter the queen instance (say "ready")' }),
        -- 2: Heart of Flawless Brass.
        S.click({ npc = HEART, action = '/say in exchange',
            condition = objDone(2), desc = 'convince Heart of Flawless Brass (say "in exchange")' }),
        -- 3: Esianti instance via Sky Orchid Understanding, then Moon Serf phrase.
        S.click({ zone = 'esianti', npc = ORCHID, action = '/say ready',
            condition = function(ctx) return ctx.mq:findSpawn(MOON_SERF) ~= nil or objDone(3)(ctx) end,
            desc = 'get Esianti instance access from Sky Orchid Understanding (say "ready")' }),
        S.click({ npc = MOON_SERF, action = '/say ring with garnets and rubies muhbis',
            condition = objDone(3), desc = 'obtain the muhbis from Moon Serf' }),
        -- 4: final instance, deliver Ring to Heart of Flawless Brass.
        S.click({ zone = 'aalishai', npc = DIRGEFUL, action = '/say ready',
            condition = function(ctx) return ctx.mq:findSpawn(HEART) ~= nil or objDone(4)(ctx) end,
            desc = 'enter the final instance via Dirgeful Ruby Blade (say "ready")' }),
        S.handin({ npc = HEART, taskName = TASK, objective = 4,
            items = { 'Ring' }, desc = 'deliver the Ring to Heart of Flawless Brass' }),
    },
})
