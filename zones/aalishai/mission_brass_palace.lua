--- doprog.zones.aalishai.mission_brass_palace
---
--- Brass Palace (group mission 1-6). Source: tbl.eqresource.com/brasspalace
--- Requested from Great Sky Ocean (Stratos) by saying "see it through"; enter the
--- instance by saying "ready". 6h limit, 5h lockout.
---
--- Objectives:
---   1. Defeat the guards and get into the palace. 0/1
---   2. Defeat the guards and get into the throne room. 0/1
---   3. Defeat the guards and get into the queen's bedroom. 0/1
---      Named (55M HP each): Silent Sun, Ash Wrathful, Discipline of Flame.
---      Beware non-aggro fire elementals with ~50k/s damage auras.
---   4. Find evidence: pick up "Note on Brass" from the table in the queen's
---      bedroom and right-click it. 0/1.
---   5. Open the chest. 0/1.

local Mission = require('doprog.domain.mission')
local S = require('doprog.steps')

local TASK = 'Brass Palace'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local GIVER = { name = 'Great Sky Ocean', npc = true }

---@type doprog.Mission
return Mission.new({
    name = TASK,
    zone = 'aalishai',
    completionTask = TASK,
    requestNpc = GIVER,
    requestSay = 'see it through',
    lockoutMinutes = 300,
    prereq = { tasks = { 'Palace of Embers' } },
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = TASK, request = 'see it through',
            desc = 'request Brass Palace (say "see it through")' }),
        S.click({ zone = 'stratos', npc = GIVER, action = '/say ready',
            desc = 'enter the Brass Palace instance (say "ready")' }),
        S.combat({ taskName = TASK, objective = 1, target = { npc = true, radius = 1000, exclude = { 'elemental' } },
            desc = 'defeat the guards into the palace (avoid the fire-aura elementals)' }),
        S.combat({ taskName = TASK, objective = 2, target = { npc = true, radius = 1000, exclude = { 'elemental' } },
            desc = 'defeat the guards into the throne room' }),
        S.combat({ taskName = TASK, objective = 3, target = { npc = true, radius = 1000, exclude = { 'elemental' } },
            desc = "defeat the guards into the queen's bedroom" }),
        S.click({ action = '/multiline ; /itemtarget Note on Brass ; /click left item',
            condition = objDone(4), desc = 'pick up and right-click "Note on Brass" (obj 4)' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest' }),
    },
})
