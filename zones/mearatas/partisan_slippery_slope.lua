--- doprog.zones.mearatas.partisan_slippery_slope
---
--- Slippery Slope. Source: https://tbl.eqresource.com/slipperyslope.php
--- Solo task, 30m lockout, repeatable. Giver/turn-in: Flexing Devout Purpose
--- (Mearatas), request "clues". A missive-courier chain that bounces between
--- Flexing Devout Purpose and Emli Widgetton (the translator), then ends with
--- confronting and defeating Unrepentant Bronze Temper.
---
--- Objectives (in order):
---   1. "Convince" aqua envoys (SE zone) -> loot a Damp Missive from them.
---   2. Deliver the Damp Missive to Flexing Devout Purpose.
---   3. Locate Emli Widgetton and give her the Intriguing Damp Missive.
---   4. Bring the Translated Damp Missive back to Flexing Devout Purpose.
---   5. Confront Unrepentant Bronze Temper with the Cryptic Damp Missive (she
---      aggros after the confrontation).
---   6. Find evidence of her scheme -> defeat her and loot the Soggy Journal.
---   7. Take the Soggy Journal to Flexing Devout Purpose.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Slippery Slope'
---@type doprog.SpawnQuery
local GIVER = { name = 'Flexing Devout Purpose', npc = true }
---@type doprog.SpawnQuery
local EMLI = { name = 'Emli Widgetton', npc = true }
---@type doprog.SpawnQuery
local TEMPER = { name = 'Unrepentant Bronze Temper', npc = true }
---@type doprog.SpawnQuery
local ENVOY = { name = 'aqua envoy', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'mearatas',
    completionTask = TASK,
    prereq = { tasks = { 'Enter Mearatas', 'Serving Another Master' } },
    steps = {
        S.pickup({ zone = 'mearatas', npc = GIVER, taskName = TASK, request = 'clues',
            desc = 'accept Slippery Slope from Flexing Devout Purpose (say "clues")' }),
        -- 1: "convince" the SE aqua envoys -- defeat them until a Damp Missive drops.
        S.combat({ zone = 'mearatas', target = ENVOY, untilItem = 'Damp Missive',
            desc = 'defeat aqua envoys (SE) until a Damp Missive drops' }),
        S.loot({ zone = 'mearatas', item = 'Damp Missive', desc = 'loot the Damp Missive' }),
        -- 2: deliver the Damp Missive (returns the Intriguing Damp Missive).
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 2,
            items = { 'Damp Missive' }, desc = 'deliver the Damp Missive to Flexing Devout Purpose' }),
        -- 3: give the Intriguing Damp Missive to Emli (returns the Translated one).
        S.handin({ zone = 'mearatas', npc = EMLI, taskName = TASK, objective = 3,
            items = { 'Intriguing Damp Missive' }, desc = 'give the Intriguing Damp Missive to Emli Widgetton' }),
        -- 4: bring the Translated Damp Missive back (returns the Cryptic one).
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 4,
            items = { 'Translated Damp Missive' }, desc = 'bring the Translated Damp Missive back to the giver' }),
        -- 5: confront Temper with the Cryptic Damp Missive -- she aggros.
        S.handin({ zone = 'mearatas', npc = TEMPER, taskName = TASK, objective = 5,
            items = { 'Cryptic Damp Missive' }, desc = 'confront Unrepentant Bronze Temper (she aggros)' }),
        -- 6: defeat her for the evidence, then loot the Soggy Journal.
        S.combat({ zone = 'mearatas', taskName = TASK, objective = 6, target = TEMPER,
            desc = 'defeat Unrepentant Bronze Temper' }),
        S.loot({ zone = 'mearatas', item = 'Soggy Journal', desc = 'loot the Soggy Journal' }),
        -- 7: return the Soggy Journal to the giver.
        S.handin({ zone = 'mearatas', npc = GIVER, taskName = TASK, objective = 7,
            items = { 'Soggy Journal' }, desc = 'take the Soggy Journal to Flexing Devout Purpose' }),
    },
})
