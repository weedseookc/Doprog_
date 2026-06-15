--- doprog.zones.esianti.partisan_serving_another_master
---
--- Serving Another Master (group task 1-6). Source:
--- tbl.eqresource.com/servinganothermaster
--- Giver/turn-in: Obsidian Sundering Master (Esianti: Palace of the Winds).
--- Request: "can do". 24h limit, 5h lockout.
---
--- Objectives:
---   1. Speak with Obsidian Sundering Master. 0/1 -> hail.
---   2. Speak with Silent Sun. 0/1 -> hail.
---   3. Find Ghost Ruby. 0/1 -> say "where is Ghost Ruby?" to fire-area mobs in
---      the NW, then follow the dialogue: "ruined" -> "lesson" -> "spot".
---      Ghost Ruby spawns ~30s later (behind Confluence of Gracious Incandescence
---      / ravine on the north side).
---   4. Defeat Ghost Ruby and take his head. 0/1 -> kill, loot "Head of Ghost Ruby".
---   5. Give the head to Silent Sun. 0/1.
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
---@type doprog.SpawnQuery
local FIRE_MOB = { name = 'Confluence of Gracious Incandescence', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'esianti',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'esianti', npc = MASTER, taskName = TASK, request = 'can do',
            desc = 'accept Serving Another Master (say "can do")' }),
        S.handin({ zone = 'esianti', npc = MASTER, taskName = TASK, objective = 1,
            desc = 'speak with Obsidian Sundering Master' }),
        S.handin({ zone = 'esianti', npc = SILENT_SUN, taskName = TASK, objective = 2,
            desc = 'speak with Silent Sun' }),
        -- 3: trigger Ghost Ruby via fire-mob dialogue chain.
        S.click({ zone = 'esianti', npc = FIRE_MOB,
            action = '/multiline ; /say where is Ghost Ruby? ; /say ruined ; /say lesson ; /say spot',
            condition = function(ctx)
                return ctx.mq:findSpawn({ name = 'Ghost Ruby', npc = true }) ~= nil or objDone(3)(ctx)
            end,
            desc = 'spawn Ghost Ruby via the fire-mob dialogue (ruined/lesson/spot)' }),
        -- 4: kill Ghost Ruby and loot his head.
        S.combat({ zone = 'esianti', taskName = TASK, objective = 4,
            target = { name = 'Ghost Ruby', npc = true }, desc = 'defeat Ghost Ruby' }),
        S.loot({ zone = 'esianti', item = 'Head of Ghost Ruby', desc = 'loot Head of Ghost Ruby' }),
        -- 5: give head to Silent Sun.
        S.handin({ zone = 'esianti', npc = SILENT_SUN, taskName = TASK, objective = 5,
            items = { 'Head of Ghost Ruby' }, desc = 'give the head to Silent Sun' }),
        -- 6/7: deliver muhbis + note to the Master.
        S.handin({ zone = 'esianti', npc = MASTER, taskName = TASK, objective = 6,
            items = { 'Dark Ruby Muhbis' }, desc = 'deliver Dark Ruby Muhbis to the Master' }),
        S.handin({ zone = 'esianti', npc = MASTER, taskName = TASK, objective = 7,
            items = { 'Elegant Note' }, desc = 'deliver Elegant Note to the Master' }),
    },
})
