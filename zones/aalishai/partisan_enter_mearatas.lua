--- doprog.zones.aalishai.partisan_enter_mearatas
---
--- Enter Mearatas (solo partisan, repeatable, 30-minute lockout).
--- Source: https://tbl.eqresource.com/entermearatas.php
--- Giver: Blazing Sorrows Darkness (Aalishai: Palace of Embers) — or granted
--- automatically during Tyrant of Fire. Request: "require". Objectives 2-4
--- execute in RANDOM order; the engine fast-forwards any already-satisfied
--- objective, so the listed order resolves correctly regardless.
---
--- Objectives (in order):
---   1. Find a way into Mearatas. 0/1 -> say "enter mearatas" to the earth mobs on
---      the Eastern side of the zone. (Players report obj 1 can hang; doing it
---      UNGROUPED / on a pick zone is the published workaround.)
---   2. Convince Glance of Sky to tell you a name. 0/1 -> defeat Dread Last
---      Guardian, loot its head, turn the head in to Glance of Sky. (Glance of Sky
---      needs Indifferent+ faction unless sneaking.)
---   3. Convince Obsidian Bitterness to tell you a name. 0/1 -> hail Obsidian
---      Bitterness, hail Udex until the CORRECT one answers "I will not speak
---      about anyone appearing before me in my capacity as Udex.", give it the
---      note (receive Opened Copper Note), return the Opened Copper Note to
---      Obsidian Bitterness.
---   4. Convince Ivory Flume to tell you a name. 0/1 -> defeat Hidden Dust, loot
---      its head, turn the head in to Eyes Unconquered, turn the stone in to
---      Ivory Flume.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Enter Mearatas'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

--- The correct Udex self-identifies with this exact line; the others stay silent.
local UDEX_REPLY = 'I will not speak about anyone appearing before me in my capacity as Udex.'

---@type doprog.SpawnQuery
local GIVER = { name = 'Blazing Sorrows Darkness', npc = true }
local GLANCE = { name = 'Glance of Sky', npc = true }
local OBSIDIAN = { name = 'Obsidian Bitterness', npc = true }
local UDEX = { name = 'Udex', npc = true }
local EYES = { name = 'Eyes Unconquered', npc = true }
local IVORY = { name = 'Ivory Flume', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'aalishai',
    completionTask = TASK,
    -- Chain: Royal Visits -> Tyrant of Fire (Doomfire ring) -> Enter Mearatas.
    prereq = { tasks = { 'Royal Visits', 'Tyrant of Fire' } },
    steps = {
        -- Accept from Blazing Sorrows Darkness (say the offer keyword).
        S.pickup({ zone = 'aalishai', npc = GIVER, taskName = TASK, request = 'require',
            desc = 'accept Enter Mearatas (say "require")' }),
        -- 1: say "enter mearatas" to the eastern earth mobs (do this ungrouped).
        S.click({ zone = 'aalishai', npc = { name = 'earth', npc = true },
            action = '/say enter mearatas', objective = 1, condition = objDone(1),
            desc = 'say "enter mearatas" to an eastern earth mob (ungrouped)' }),
        -- 2: Glance of Sky chain — Dread Last Guardian head.
        S.combat({ zone = 'aalishai', target = { name = 'Dread Last Guardian', npc = true },
            desc = 'defeat Dread Last Guardian' }),
        S.loot({ zone = 'aalishai', item = 'head', desc = 'loot the Dread Last Guardian head' }),
        S.handin({ zone = 'aalishai', npc = GLANCE, taskName = TASK, objective = 2,
            items = { 'head' }, desc = 'turn the head in to Glance of Sky' }),
        -- 3: Obsidian Bitterness / Udex note chain. UDEX_REPLY marks the right Udex.
        S.click({ zone = 'aalishai', npc = OBSIDIAN, action = '/say Hail',
            condition = function(ctx) return ctx.mq:findSpawn(UDEX) ~= nil or objDone(3)(ctx) end,
            desc = 'hail Obsidian Bitterness to start the Udex search (' .. UDEX_REPLY .. ')' }),
        S.handin({ zone = 'aalishai', npc = UDEX, taskName = TASK,
            items = { 'note' }, desc = 'give the note to the correct Udex (get Opened Copper Note)' }),
        S.handin({ zone = 'aalishai', npc = OBSIDIAN, taskName = TASK, objective = 3,
            items = { 'Opened Copper Note' },
            desc = 'return the Opened Copper Note to Obsidian Bitterness' }),
        -- 4: Ivory Flume chain — Hidden Dust head -> Eyes Unconquered -> stone.
        S.combat({ zone = 'aalishai', target = { name = 'Hidden Dust', npc = true },
            desc = 'defeat Hidden Dust' }),
        S.loot({ zone = 'aalishai', item = 'head', desc = 'loot the Hidden Dust head' }),
        S.handin({ zone = 'aalishai', npc = EYES, taskName = TASK,
            items = { 'head' }, desc = 'turn the head in to Eyes Unconquered (get the stone)' }),
        S.handin({ zone = 'aalishai', npc = IVORY, taskName = TASK, objective = 4,
            items = { 'stone' }, desc = 'turn the stone in to Ivory Flume' }),
    },
})
