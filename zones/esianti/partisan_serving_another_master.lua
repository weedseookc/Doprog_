--- doprog.zones.esianti.partisan_serving_another_master
---
--- Serving Another Master (group task 1-6).
--- Source: tbl.eqresource.com/servinganothermaster.php
--- Giver/turn-in: Obsidian Sundering Master (Esianti: Palace of the Winds).
--- Request: "can do". 24h limit, 5h lockout. Repeatable.
---
--- Objectives (in order, per source):
---   1. Speak with Obsidian Sundering Master. 0/1 -> hail.
---   2. Speak with Silent Sun. 0/1 -> hail.
---   3. Find the being called Ghost Ruby. 0/1 -> say "where is Ghost Ruby?" to the
---      fire-area mobs in the NW of the zone; Ghost Ruby spawns ~30s later at a
---      random building location.
---   4. Defeat Ghost Ruby and take his head. 0/1 -> kill, loot "Head of Ghost Ruby".
---   5. Give the head of Ghost Ruby to Silent Sun. 0/1.
---   6. Deliver the Dark Ruby Muhbis to Obsidian Sundering Master. 0/1.
---   7. Deliver the Elegant Note to Obsidian Sundering Master. 0/1.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Serving Another Master'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local MASTER = { name = 'Obsidian Sundering Master', npc = true }
---@type doprog.SpawnQuery
local SILENT_SUN = { name = 'Silent Sun', npc = true }
-- The NW fire area is patrolled by Confluence of Gracious Incandescence mobs;
-- saying the request phrase to one of them triggers Ghost Ruby's spawn.
---@type doprog.SpawnQuery
local FIRE_MOB = { name = 'Confluence of Gracious Incandescence', npc = true }
---@type doprog.SpawnQuery
local GHOST_RUBY = { name = 'Ghost Ruby', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'esianti',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'esianti', npc = MASTER, taskName = TASK, request = 'can do',
            desc = 'accept Serving Another Master (say "can do")' }),
        -- 1: speak with the Master.
        S.handin({ zone = 'esianti', npc = MASTER, taskName = TASK, objective = 1,
            desc = 'speak with Obsidian Sundering Master' }),
        -- 2: speak with Silent Sun.
        S.handin({ zone = 'esianti', npc = SILENT_SUN, taskName = TASK, objective = 2,
            desc = 'speak with Silent Sun' }),
        -- 3: find Ghost Ruby -> say the request phrase to a NW fire-area mob.
        S.click({ zone = 'esianti', npc = FIRE_MOB, action = '/say where is Ghost Ruby?',
            condition = function(ctx)
                return objDone(3)(ctx) or ctx.mq:findSpawn(GHOST_RUBY) ~= nil
            end,
            desc = 'find Ghost Ruby (ask the NW fire-area mobs where he is)' }),
        -- 4: defeat Ghost Ruby, then loot his head (objective ticks on the kill).
        S.combat({ zone = 'esianti', taskName = TASK, objective = 4, target = GHOST_RUBY,
            desc = 'defeat Ghost Ruby' }),
        S.loot({ zone = 'esianti', item = 'Head of Ghost Ruby',
            desc = 'loot Head of Ghost Ruby' }),
        -- 5: give the head to Silent Sun (receives Dark Ruby Muhbis + Elegant Note).
        S.handin({ zone = 'esianti', npc = SILENT_SUN, taskName = TASK, objective = 5,
            items = { 'Head of Ghost Ruby' }, desc = 'give the head of Ghost Ruby to Silent Sun' }),
        -- 6: deliver the Dark Ruby Muhbis to the Master.
        S.handin({ zone = 'esianti', npc = MASTER, taskName = TASK, objective = 6,
            items = { 'Dark Ruby Muhbis' }, desc = 'deliver Dark Ruby Muhbis to the Master' }),
        -- 7: deliver the Elegant Note to the Master.
        S.handin({ zone = 'esianti', npc = MASTER, taskName = TASK, objective = 7,
            items = { 'Elegant Note' }, desc = 'deliver Elegant Note to the Master' }),
    },
})
