--- doprog.zones.aalishai.partisan_enter_mearatas
---
--- Enter Mearatas (group task). Source: tbl.eqresource.com/entermearatas
--- Giver: Blazing Sorrows Darkness (Aalishai) — or granted automatically during
--- Tyrant of Fire. Request: "require". Objectives 2-4 appear in random order;
--- the engine fast-forwards completed ones, so the listed order is fine.
---
--- Objectives:
---   1. Find a way into Mearatas. 0/1 -> say "enter mearatas" to earth mobs on the
---      eastern side (do this UNGROUPED; it bugs in a group).
---   2. Convince Glance of Sky. 0/1 -> defeat Dread Last Guardian, loot its head,
---      turn the head in to Glance of Sky.
---   3. Convince Obsidian Bitterness. 0/1 -> hail Obsidian Bitterness, hail the
---      correct Udex, turn Copper Note in (receive Opened Copper Note), return it
---      to Obsidian Bitterness.
---   4. Convince Ivory Flume. 0/1 -> defeat Hidden Dust, loot its head, turn it in
---      to Eyes Unconquered, then turn the Stone in to Ivory Flume.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Enter Mearatas'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

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
    -- Chain: Royal Visits -> Tyrant of Fire -> Enter Mearatas (Tyrant of Fire is
    -- in Doomfire; the registry soft-skips this until it is done).
    prereq = { tasks = { 'Royal Visits', 'Tyrant of Fire' } },
    steps = {
        S.pickup({ zone = 'aalishai', npc = GIVER, taskName = TASK, request = 'require',
            desc = 'accept Enter Mearatas (say "require")' }),
        -- 1: say "enter mearatas" to eastern earth mobs (ungrouped).
        S.click({ zone = 'aalishai', npc = { name = 'earth', npc = true },
            action = '/say enter mearatas', condition = objDone(1),
            desc = 'say "enter mearatas" to the eastern earth mobs' }),
        -- 2: Glance of Sky via Dread Last Guardian head.
        S.combat({ zone = 'aalishai', target = { name = 'Dread Last Guardian', npc = true },
            desc = 'defeat Dread Last Guardian' }),
        S.loot({ zone = 'aalishai', item = 'head', desc = 'loot the Guardian head' }),
        S.handin({ zone = 'aalishai', npc = GLANCE, taskName = TASK, objective = 2,
            items = { 'head' }, desc = 'turn the head in to Glance of Sky' }),
        -- 3: Obsidian Bitterness / Udex copper-note chain.
        S.click({ zone = 'aalishai', npc = OBSIDIAN, action = '/say Hail',
            condition = function(ctx) return ctx.mq:findSpawn(UDEX) ~= nil or objDone(3)(ctx) end,
            desc = 'hail Obsidian Bitterness' }),
        S.handin({ zone = 'aalishai', npc = UDEX, taskName = TASK,
            items = { 'Copper Note' }, desc = 'turn Copper Note in to the correct Udex' }),
        S.handin({ zone = 'aalishai', npc = OBSIDIAN, taskName = TASK, objective = 3,
            items = { 'Opened Copper Note' }, desc = 'return the Opened Copper Note to Obsidian Bitterness' }),
        -- 4: Ivory Flume via Hidden Dust head + stone.
        S.combat({ zone = 'aalishai', target = { name = 'Hidden Dust', npc = true },
            desc = 'defeat Hidden Dust' }),
        S.loot({ zone = 'aalishai', item = 'head', desc = 'loot the Hidden Dust head' }),
        S.handin({ zone = 'aalishai', npc = EYES, taskName = TASK,
            items = { 'head' }, desc = 'turn the head in to Eyes Unconquered' }),
        S.handin({ zone = 'aalishai', npc = IVORY, taskName = TASK, objective = 4,
            items = { 'Stone' }, desc = 'turn the Stone in to Ivory Flume' }),
    },
})
