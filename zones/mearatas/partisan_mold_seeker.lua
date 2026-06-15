--- doprog.zones.mearatas.partisan_mold_seeker
---
--- Mold Seeker (group task 1-6). Source: tbl.eqresource.com/moldseeker
--- Giver: Obsidian Sundering Master (Esianti). Request: "mold seeker".
--- The looted key is what requests the Relic Raider mission afterwards.
---
--- Objectives:
---   1. Find where the duende keep their unused female mold -> say
---      "where is the female duende mold" to duende mobs (NE Mearatas; some aggro).
---   2. Speak with the relic keeper -> say "show me the relics" to Battleworn
---      Obelisk.
---   3. Get the relic keeper's key -> defeat Battleworn Obelisk.
---   4. Pick up the relic keeper's key -> loot the key.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Mold Seeker'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local MASTER = { name = 'Obsidian Sundering Master', npc = true }
local OBELISK = { name = 'Battleworn Obelisk', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'mearatas',
    completionTask = TASK,
    prereq = { tasks = { 'Enter Mearatas' } },
    steps = {
        S.pickup({ zone = 'esianti', npc = MASTER, taskName = TASK, request = 'mold seeker',
            desc = 'accept Mold Seeker (say "mold seeker")' }),
        S.click({ zone = 'mearatas', npc = { name = 'duende', npc = true },
            action = '/say where is the female duende mold', condition = objDone(1),
            desc = 'question the duende (say "where is the female duende mold")' }),
        S.click({ zone = 'mearatas', npc = OBELISK, action = '/say show me the relics',
            condition = objDone(2), desc = 'speak with the relic keeper (Battleworn Obelisk)' }),
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 3, target = OBELISK,
            desc = 'defeat Battleworn Obelisk for his key' }),
        S.loot({ zone = 'mearatas', item = "relic keeper's key", desc = "loot the relic keeper's key" }),
    },
})
