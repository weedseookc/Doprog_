--- doprog.zones.mearatas.partisan_earthen_dirge
---
--- Earthen Dirge. Source: https://tbl.eqresource.com/earthendirge.php
--- Solo task, 30m lockout, repeatable. Giver/turn-in chain spans two zones:
--- accepted from the Obsidian Sundering Master in Esianti (request "forget"),
--- but the portal-access and head turn-in are done with Dirge in the Catacomb.
--- Group note: everyone must be in Esianti at the head turn-in to get credit.
---
--- Objectives (in order):
---   1. Convince Dirge in the Catacomb to let you use his portal (Esianti).
---   2. Defeat Funereal Dust Warrior and recover his head (Mearatas).
---   3. Deliver 1 Head of Funereal Dust Warrior to Dirge in the Catacomb.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Earthen Dirge'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local MASTER = { name = 'Obsidian Sundering Master', npc = true }
---@type doprog.SpawnQuery
local DIRGE = { name = 'Dirge', npc = true }
---@type doprog.SpawnQuery
local WARRIOR = { name = 'Funereal Dust Warrior', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'mearatas',
    completionTask = TASK,
    prereq = { tasks = { 'Enter Mearatas' } },
    steps = {
        -- Accept from the Obsidian Sundering Master in Esianti (say "forget").
        S.pickup({ zone = 'esianti', npc = MASTER, taskName = TASK, request = 'forget',
            desc = 'accept Earthen Dirge from the Obsidian Sundering Master (say "forget")' }),
        -- 1: hail Dirge in the Catacomb to gain portal access. The convince phrase
        -- is unpublished, so we hail him; doprog targets Dirge before the /say.
        S.click({ zone = 'esianti', npc = DIRGE, action = '/say Hail', condition = objDone(1),
            desc = 'convince Dirge in the Catacomb to grant portal access (hail)' }),
        -- 2: defeat Funereal Dust Warrior (Mearatas); host kills, doprog targets.
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 2, target = WARRIOR,
            desc = 'defeat Funereal Dust Warrior' }),
        S.loot({ zone = 'mearatas', item = 'Head of Funereal Dust Warrior',
            desc = 'recover the Head of Funereal Dust Warrior' }),
        -- 3: deliver the head to Dirge back in Esianti.
        S.handin({ zone = 'esianti', npc = DIRGE, taskName = TASK, objective = 3,
            items = { 'Head of Funereal Dust Warrior' }, desc = 'deliver the head to Dirge in the Catacomb' }),
    },
})
