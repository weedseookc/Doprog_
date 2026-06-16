--- doprog.zones.aalishai.mission_brass_palace
---
--- Brass Palace (group mission 1-6). Source: tbl.eqresource.com/brasspalace
--- Requested from Great Sky Ocean (Stratos) by saying "see it through"; enter the
--- instance by saying "ready". 6h limit, 5h lockout.
---
--- Three named bosses gate the three "get into the next room" objectives, each
--- 55M HP, so doprog drives one named per objective in the published kill order:
---   obj1 Silent Sun -> obj2 Ash Wrathful -> obj3 Discipline of Flame.
--- Hazard (Ash Wrathful room): fire elementals carry a short-range damage aura.
--- doprog (a) excludes them from targeting so the host fights only the named, and
--- (b) attaches a `flee` mechanic so the lead is repositioned away from the nearest
--- fire elemental during the fight (escape vector from the live spawn).
---
--- Objectives (in order):
---   1. Defeat the guards and get into the palace. 0/1 -> Silent Sun.
---   2. Defeat the guards and get into the throne room. 0/1 -> Ash Wrathful.
---   3. Defeat the guards and get into the queen's bedroom. 0/1 -> Discipline of Flame.
---   4. Find evidence: pick up "Note on Brass" from the bedroom table, right-click it.
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

-- Keep DPS off the fire elementals; the named are the real targets.
local AVOID = { 'fire elemental', 'elemental' }

-- Fire-aura avoidance: stand clear of the nearest fire elemental during the
-- Ash Wrathful fight. No loc/emote -> a standing rule that fires every tick,
-- nav-ing the lead away from the live elemental spawn by `distance` units.
---@type doprog.Mechanic[]
local FIRE_AURA = {
    {
        desc = 'stay out of the fire elemental aura',
        react = 'flee',
        spawn = { name = 'fire elemental', npc = true, radius = 200 },
        distance = 60,
    },
}

-- Each room is a "defeat the guards, then the named spawns" objective. We resolve
-- the named first; if it is not up yet we feed the host a guard to clear (the
-- walkthrough: "defeat armors until Silent Sun spawns"). Completion is driven by
-- the objective counter, so once the named dies the step advances regardless.
---@param boss string
---@return fun(ctx: doprog.StepContext): doprog.SpawnQuery?
local function bossThenGuards(boss)
    ---@param ctx doprog.StepContext
    return function(ctx)
        local named = { name = boss, npc = true, radius = 1000, exclude = AVOID }
        if ctx.mq:findSpawn(named) then return named end
        -- Named not up: clear guards/armors (anything that isn't a fire elemental
        -- or another named) to trigger the spawn.
        return { npc = true, radius = 200, exclude = AVOID }
    end
end

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
        S.combat({ taskName = TASK, objective = 1, target = bossThenGuards('Silent Sun'),
            desc = 'into the palace: clear guards until Silent Sun spawns, then defeat it' }),
        S.combat({ taskName = TASK, objective = 2, target = bossThenGuards('Ash Wrathful'),
            mechanics = FIRE_AURA,
            desc = 'into the throne room: defeat Ash Wrathful (flee the fire-aura elementals)' }),
        S.combat({ taskName = TASK, objective = 3, target = bossThenGuards('Discipline of Flame'),
            desc = "into the queen's bedroom: clear guards until Discipline of Flame, then defeat it" }),
        -- Obj 4: pick the note off the bedroom table (ground clicky), then
        -- right-click it in inventory to read it and satisfy "find evidence".
        S.click({ action = '/multiline ; /itemtarget "Note on Brass" ; /click left item'
                .. ' ; /itemnotify "Note on Brass" rightmouseup',
            condition = objDone(4), desc = 'pick up + right-click "Note on Brass" (obj 4)' }),
        S.click({ action = '/multiline ; /doortarget ; /click left door',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest (obj 5)' }),
    },
})
