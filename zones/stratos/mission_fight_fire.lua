--- doprog.zones.stratos.mission_fight_fire
---
--- Fight Fire (group mission 1-6). Source: tbl.eqresource.com/fightfire
--- Requested from Grieving Soul Scent in Stratos by saying "defeat"; enter the
--- instance by saying "ready". 6h limit, 5h lockout. Prereq: Soldier of Air.
---
--- Objectives:
---   1. Defeat the invaders. 0/12 -> talk to NPCs to initiate; they aggro; a
---      second wave follows. (Host engages; doprog watches 0/12.)
---   2. Defeat the Efreeti lieutenants. 0/4 -> 4 aggro-linked yellow-con mobs that
---      CANNOT be separated; efreeti and armors path in. Snare/mez ok, very root
---      resistant, no summon. (Strategy is the host's; doprog watches 0/4.)
---   3. Receive judgment. 0/1 -> say "grieving soul scent" to Evasion Flame Desires.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Fight Fire'
---@type doprog.SpawnQuery
local GIVER = { name = 'Grieving Soul Scent', npc = true }

---@type doprog.Mission
return Mission.new({
    name = TASK,
    zone = 'stratos',
    completionTask = TASK,
    requestNpc = GIVER,
    requestSay = 'defeat',
    lockoutMinutes = 300, -- 5h request lockout
    prereq = { tasks = { 'Soldier of Air' } },
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = TASK, request = 'defeat',
            desc = 'request Fight Fire (say "defeat")' }),
        -- Enter the instance: say "ready" (zone changes into the Fight Fire copy).
        S.click({ zone = 'stratos', npc = GIVER, action = '/say ready',
            desc = 'enter the Fight Fire instance (say "ready")' }),
        -- Inside the instance: no zone enforcement (instance short name varies).
        -- Phase 1: talk to an invader NPC to initiate; it aggros and a 2nd wave
        -- follows. Gate on the 0/12 counter starting (or the step's first kill).
        S.click({ npc = { name = 'invader', npc = true }, action = '/say Hail',
            condition = function(ctx)
                return ctx.mq:findSpawn({ name = 'invader', npc = true }) == nil
                    or ctx.task:objectiveDone(TASK, 1)
            end,
            desc = 'talk to the invaders to initiate the fight (obj 1)' }),
        -- Phase 1 combat: defeat 12 invaders (two waves). Host fights; doprog
        -- targets invaders and watches the 0/12 counter.
        S.combat({ taskName = TASK, objective = 1,
            target = { name = 'invader', npc = true },
            desc = 'defeat 12 invaders (2nd wave follows the first)' }),
        -- Phase 2: 4 aggro-linked efreeti lieutenants spawn; they cannot be
        -- separated. If they go inactive the host re-activates by Balancing the
        -- active one(s); doprog targets them and watches the 0/4 counter.
        S.combat({ taskName = TASK, objective = 2,
            target = { name = 'lieutenant', npc = true },
            desc = 'defeat 4 aggro-linked efreeti lieutenants (cannot be separated)' }),
        -- Receive judgment.
        S.click({ npc = { name = 'Evasion Flame Desires', npc = true },
            action = '/say grieving soul scent',
            condition = function(ctx) return ctx.task:objectiveDone(TASK, 3) end,
            desc = 'say "grieving soul scent" to Evasion Flame Desires' }),
    },
})
