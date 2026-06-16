--- doprog.zones.esianti.mission_contract_of_war
---
--- Contract of War (group mission 1-6).
--- Source: tbl.eqresource.com/contractofwar.php
--- Requested from Great Sky Ocean (Stratos: Zephyr's Flight) by saying "mission";
--- enter the instance by saying "to go". 6h limit, 5h lockout. Repeatable.
---
--- Objectives (in order, per source):
---   1. Find and defeat whomever is palace guardian today and acquire a writ to
---      see the king. 0/1 -> one of three named guardians is up per run (random
---      order, each tethered to its spawn): Sunshine Sensible Warmth,
---      Radiant Fog Evening, Feather Silver Sheen. Defeat it, loot "Writ of Access".
---   2. Speak with the king about the war. 0/1 -> click the Moon Serf of Harmonious
---      Heavens door from OUTSIDE, defeat the mephits it spawns, then say
---      "do you know who will follow" to Moon Serf of Harmonious Heavens.
---   3. Open the Chest. 0/1.
---
--- NOTE (framework gap): the source says players must "drop the expedition but
--- stay in the task" and relog to player-select to keep the named from
--- despawning. doprog has no expedition-drop/relog primitive, so that anti-despawn
--- step is not encoded here.

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

-- Exactly one of these three is the guardian on any given run; resolve to
-- whichever is currently spawned so doprog targets the real named.
local GUARDIAN_NAMES = { 'Sunshine Sensible Warmth', 'Radiant Fog Evening', 'Feather Silver Sheen' }
---@param ctx doprog.StepContext
---@return doprog.SpawnQuery?
local function resolveGuardian(ctx)
    if objDone(1)(ctx) then return nil end
    for _, n in ipairs(GUARDIAN_NAMES) do
        local q = { name = n, npc = true }
        if ctx.mq:findSpawn(q) then return q end
    end
    return false -- guardian not yet visible this frame: keep waiting
end

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
        -- 1: defeat today's palace guardian (tethered named), then loot the writ.
        S.combat({ taskName = TASK, objective = 1, target = resolveGuardian,
            desc = 'defeat the palace guardian (Sunshine / Radiant Fog / Feather Silver)' }),
        S.loot({ item = 'Writ of Access', desc = 'loot Writ of Access from the guardian' }),
        -- 2: open the king's door from outside, clear mephits, speak to Moon Serf.
        S.click({ npc = MOON_SERF, action = '/multiline ; /doortarget ; /click left door',
            completeAfter = 4000,
            desc = 'click the Moon Serf of Harmonious Heavens door (from outside)' }),
        -- Mephit clear is target-driven (done when none remain); objective 2 itself
        -- only ticks once we hail Moon Serf, so do not gate this step on it.
        S.combat({ target = { name = 'mephit', npc = true },
            desc = 'defeat the mephits the king spawns' }),
        S.click({ npc = MOON_SERF, action = '/say do you know who will follow',
            condition = objDone(2),
            desc = 'speak with the king (Moon Serf of Harmonious Heavens)' }),
        -- 3: open the chest.
        S.click({ action = '/multiline ; /itemtarget "Chest" ; /click left item',
            condition = function(ctx) return objDone(3)(ctx) or ctx.task:isComplete(TASK) end,
            desc = 'open the Chest' }),
    },
})
