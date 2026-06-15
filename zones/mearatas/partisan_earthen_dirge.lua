--- doprog.zones.mearatas.partisan_earthen_dirge
---
--- Earthen Dirge (solo task; group gets credit if all are in Esianti for the
--- head turn-in). Source: tbl.eqresource.com/earthendirge
--- Giver/turn-in: Obsidian Sundering Master (Esianti). Request: "forget".
---
--- Objectives:
---   1. Convince Dirge in the Catacomb to let you use his portal (Esianti).
---   2. Defeat Funereal Dust Warrior and recover his head (Mearatas).
---   3. Deliver the Head of Funereal Dust Warrior to Dirge in the Catacomb.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Earthen Dirge'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local MASTER = { name = 'Obsidian Sundering Master', npc = true }
local DIRGE = { name = 'Dirge', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'mearatas',
    completionTask = TASK,
    prereq = { tasks = { 'Enter Mearatas' } },
    steps = {
        S.pickup({ zone = 'esianti', npc = MASTER, taskName = TASK, request = 'forget',
            desc = 'accept Earthen Dirge (say "forget")' }),
        S.click({ zone = 'esianti', npc = DIRGE, action = '/say Hail',
            condition = objDone(1), desc = 'convince Dirge in the Catacomb for portal access' }),
        S.combat({ zone = 'mearatas', target = { name = 'Funereal Dust Warrior', npc = true },
            desc = 'defeat Funereal Dust Warrior' }),
        S.loot({ zone = 'mearatas', item = 'Head of Funereal Dust Warrior', desc = 'loot the head' }),
        S.handin({ zone = 'esianti', npc = DIRGE, taskName = TASK, objective = 3,
            items = { 'Head of Funereal Dust Warrior' }, desc = 'deliver the head to Dirge' }),
    },
})
