--- doprog.zones.mearatas.partisan_mold_seeker
---
--- Mold Seeker. Source: https://tbl.eqresource.com/moldseeker.php
--- Group task (1-6), 24h limit, 30m lockout, repeatable. Accepted from the
--- Obsidian Sundering Master in Esianti (request "mold seeker"), run in Mearatas.
--- The relic keeper's key looted at the end is the token that requests the
--- Relic Raider mission afterwards. Awards Partisan of Mearatas achievement.
---
--- Objectives (in order):
---   1. Find out where the duende keep their unused female mold -> say
---      "where is the female duende mold" to duende in the NE section (some aggro).
---   2. Speak with the relic keeper -> say "show me the relics" to the Battleworn
---      Obelisk (it aggros).
---   3. Get the relic keeper's key -> defeat the Battleworn Obelisk.
---   4. Pick up the relic keeper's key -> loot it from the Obelisk.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Mold Seeker'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local MASTER = { name = 'Obsidian Sundering Master', npc = true }
---@type doprog.SpawnQuery
local DUENDE = { name = 'duende', npc = true }
---@type doprog.SpawnQuery
local OBELISK = { name = 'Battleworn Obelisk', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'mearatas',
    completionTask = TASK,
    prereq = { tasks = { 'Enter Mearatas', 'Earthen Dirge' } },
    steps = {
        S.pickup({ zone = 'esianti', npc = MASTER, taskName = TASK, request = 'mold seeker',
            desc = 'accept Mold Seeker from the Obsidian Sundering Master (say "mold seeker")' }),
        -- 1: question the duende in the NE section; doprog targets one, then /say.
        S.click({ zone = 'mearatas', npc = DUENDE, action = '/say where is the female duende mold',
            condition = objDone(1), desc = 'question the NE duende (say "where is the female duende mold")' }),
        -- 2: speak with the relic keeper (Battleworn Obelisk) -- it aggros.
        S.click({ zone = 'mearatas', npc = OBELISK, action = '/say show me the relics',
            condition = objDone(2), desc = 'speak with the relic keeper (say "show me the relics")' }),
        -- 3: defeat the Battleworn Obelisk for the key.
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 3, target = OBELISK,
            desc = 'defeat the Battleworn Obelisk' }),
        -- 4: loot the relic keeper's key (used to request Relic Raider).
        S.loot({ zone = 'mearatas', item = "relic keeper's key", desc = "pick up the relic keeper's key" }),
    },
})
