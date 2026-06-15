--- doprog.zones.mearatas.partisan_slippery_slope
---
--- Slippery Slope (solo task). Source: tbl.eqresource.com/slipperyslope
--- Giver/turn-in: Flexing Devout Purpose (Mearatas). Request: "clues". Long
--- prereq chain (through Serving Another Master). A missive-courier chain that
--- bounces between Flexing Devout Purpose and Emli Widgetton, ending in a kill.
---
--- Objectives:
---   1. Loot a Damp Missive from aqua envoys (SE zone area).
---   2. Deliver the Damp Missive to Flexing Devout Purpose.
---   3. Give the Intriguing Damp Missive to Emli Widgetton.
---   4. Bring the Translated Damp Missive back to Flexing Devout Purpose.
---   5. Confront Unrepentant Bronze Temper with the Cryptic Damp Missive (she
---      aggros after the turn-in).
---   6. Defeat her and loot the Soggy Journal.
---   7. Take the Soggy Journal to Flexing Devout Purpose.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Slippery Slope'
---@type doprog.SpawnQuery
local GIVER = { name = 'Flexing Devout Purpose', npc = true }
local EMLI = { name = 'Emli Widgetton', npc = true }
local TEMPER = { name = 'Unrepentant Bronze Temper', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'mearatas',
    completionTask = TASK,
    prereq = { tasks = { 'Enter Mearatas', 'Serving Another Master' } },
    steps = {
        S.pickup({ zone = 'mearatas', npc = GIVER, taskName = TASK, request = 'clues',
            desc = 'accept Slippery Slope (say "clues")' }),
        S.combat({ zone = 'mearatas', target = { name = 'aqua envoy', npc = true },
            desc = 'defeat aqua envoys (SE) for a Damp Missive' }),
        S.loot({ zone = 'mearatas', item = 'Damp Missive', desc = 'loot the Damp Missive' }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 2,
            items = { 'Damp Missive' }, desc = 'deliver the Damp Missive to Flexing Devout Purpose' }),
        S.handin({ zone = 'mearatas', npc = EMLI, taskName = TASK, objective = 3,
            items = { 'Intriguing Damp Missive' }, desc = 'give the Intriguing Damp Missive to Emli Widgetton' }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 4,
            items = { 'Translated Damp Missive' }, desc = 'bring the Translated Damp Missive back' }),
        S.handin({ zone = 'mearatas', npc = TEMPER, taskName = TASK, objective = 5,
            items = { 'Cryptic Damp Missive' }, desc = 'confront Unrepentant Bronze Temper (she aggros)' }),
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 6, target = TEMPER,
            desc = 'defeat Unrepentant Bronze Temper' }),
        S.loot({ zone = 'mearatas', item = 'Soggy Journal', desc = 'loot the Soggy Journal' }),
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 7,
            items = { 'Soggy Journal' }, desc = 'take the Soggy Journal to Flexing Devout Purpose' }),
    },
})
