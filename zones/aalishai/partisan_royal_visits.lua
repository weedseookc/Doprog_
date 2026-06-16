--- doprog.zones.aalishai.partisan_royal_visits
---
--- Royal Visits (solo partisan, repeatable, 30-minute lockout).
--- Source: https://tbl.eqresource.com/royalvisits.php
--- Giver: Sky Orchid Understanding (Esianti: Palace of the Winds). Request:
--- "continue". The quest hops between Aalishai and Esianti instances; the muhbis
--- (a Ring) is fetched in Esianti and delivered in the Aalishai queen instance.
--- (Group note: every member must be in-zone for objective credit.)
---
--- Objectives (in order):
---   1. Get access to the queen of the efreeti. 0/1 (Aalishai) -> turn Windseal in
---      to Dirgeful Ruby Blade, finish his dialogue, say "ready" to zone into the
---      queen instance.
---   2. Speak with Heart of Flawless Brass and convince her to stop the war. 0/1
---      -> say "in exchange" ("in" and "exchange" are the minimum keywords).
---   3. Speak with Moon Serf of the Harmonious Heavens and obtain the muhbis. 0/1
---      -> back in Esianti, get the instance from Sky Orchid Understanding (say
---      "ready"), then say "ring with garnets and rubies muhbis" to Moon Serf.
---   4. Deliver the muhbis to the efreeti queen. 0/1 (Aalishai) -> return to
---      Dirgeful Ruby Blade, say "ready" to re-enter, turn the Ring in to Heart of
---      Flawless Brass.

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
        -- Accept from Sky Orchid Understanding in Esianti (say the offer keyword).
        S.pickup({ zone = 'esianti', npc = ORCHID, taskName = TASK, request = 'continue',
            desc = 'accept Royal Visits (say "continue")' }),
        -- 1a: hand Windseal to Dirgeful Ruby Blade in Aalishai.
        S.handin({ zone = 'aalishai', npc = DIRGEFUL, taskName = TASK,
            items = { 'Windseal' }, desc = 'turn Windseal in to Dirgeful Ruby Blade' }),
        -- 1b: say "ready" to zone into the queen instance; obj 1 ticks on entry.
        S.click({ zone = 'aalishai', npc = DIRGEFUL, action = '/say ready',
            condition = objDone(1), desc = 'enter the queen instance (say "ready")' }),
        -- 2: convince Heart of Flawless Brass (say "in exchange").
        S.click({ npc = HEART, action = '/say in exchange', objective = 2,
            condition = objDone(2),
            desc = 'convince Heart of Flawless Brass (say "in exchange")' }),
        -- 3a: back in Esianti, get the new instance from Sky Orchid (say "ready").
        S.click({ zone = 'esianti', npc = ORCHID, action = '/say ready',
            condition = function(ctx) return ctx.mq:findSpawn(MOON_SERF) ~= nil or objDone(3)(ctx) end,
            desc = 'get the Esianti instance from Sky Orchid Understanding (say "ready")' }),
        -- 3b: obtain the muhbis (a Ring) from Moon Serf via the request phrase.
        S.click({ npc = MOON_SERF, action = '/say ring with garnets and rubies muhbis',
            objective = 3, condition = objDone(3),
            desc = 'obtain the muhbis Ring from Moon Serf (say the muhbis phrase)' }),
        -- 4a: return to Dirgeful Ruby Blade, say "ready" to re-enter the instance.
        S.click({ zone = 'aalishai', npc = DIRGEFUL, action = '/say ready',
            condition = function(ctx) return ctx.mq:findSpawn(HEART) ~= nil or objDone(4)(ctx) end,
            desc = 're-enter the queen instance via Dirgeful Ruby Blade (say "ready")' }),
        -- 4b: deliver the Ring (muhbis) to Heart of Flawless Brass.
        S.handin({ npc = HEART, taskName = TASK, objective = 4,
            items = { 'Ring' }, desc = 'deliver the muhbis Ring to Heart of Flawless Brass' }),
    },
})
