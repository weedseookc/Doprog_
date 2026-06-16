--- doprog.zones.aalishai.partisan_fragmented_coterie
---
--- Fragmented Coterie (solo partisan, repeatable, 5-hour lockout).
--- Source: https://tbl.eqresource.com/fragmentedcoterie.php
--- Giver / final turn-in: Spear Sundering Ivory (Aalishai: Palace of Embers).
--- Request: "exile". Prereqs: Soldier of Air, Fight Fire, any Trial of Smoke,
--- Prisoner's Dilemma, Palace of Embers.
---
--- A courier run: deliver four named confessions to four NPCs in CLASSIC zones,
--- then return and report. Those zones live outside the bundled TBL zone graph
--- (data/zones.lua only models the TBL branches), so travel to them relies on
--- Plane of Knowledge book routing; the steps already carry the correct zone
--- short names, so once the graph is extended they route automatically.
---
--- Objectives (in order):
---   1. Deliver Spear Sundering Ivory's First Confession to Ebon Ice Servant
---      (Timorous Deep). 0/1
---   2. Deliver Spear Sundering Ivory's Second Confession to Towering Silhouette
---      (South Desert of Ro). 0/1
---   3. Deliver Spear Sundering Ivory's Third Confession to Alabaster Rose Moon
---      (Barren Coast). 0/1
---   4. Deliver Spear Sundering Ivory's Final Confession to Shadow Metal Guardian
---      (The Stonebrunt Mountains). 0/1
---   5. Return to Spear Sundering Ivory and tell him what happened (hail). 0/1

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Fragmented Coterie'
---@type doprog.SpawnQuery
local GIVER = { name = 'Spear Sundering Ivory', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'aalishai',
    completionTask = TASK,
    prereq = { tasks = {
        'Soldier of Air', 'Fight Fire', 'Trial of Three', "Prisoner's Dilemma", 'Palace of Embers',
    } },
    steps = {
        -- Accept from Spear Sundering Ivory (say the offer keyword).
        S.pickup({ zone = 'aalishai', npc = GIVER, taskName = TASK, request = 'exile',
            desc = 'accept Fragmented Coterie (say "exile")' }),
        -- 1: First Confession -> Ebon Ice Servant (Timorous Deep).
        S.handin({ zone = 'timorous', npc = { name = 'Ebon Ice Servant', npc = true }, taskName = TASK,
            objective = 1, items = { "Spear Sundering Ivory's First Confession" },
            desc = "deliver the First Confession to Ebon Ice Servant (Timorous Deep)" }),
        -- 2: Second Confession -> Towering Silhouette (South Desert of Ro).
        S.handin({ zone = 'sro', npc = { name = 'Towering Silhouette', npc = true }, taskName = TASK,
            objective = 2, items = { "Spear Sundering Ivory's Second Confession" },
            desc = "deliver the Second Confession to Towering Silhouette (South Ro)" }),
        -- 3: Third Confession -> Alabaster Rose Moon (Barren Coast).
        S.handin({ zone = 'barren', npc = { name = 'Alabaster Rose Moon', npc = true }, taskName = TASK,
            objective = 3, items = { "Spear Sundering Ivory's Third Confession" },
            desc = "deliver the Third Confession to Alabaster Rose Moon (Barren Coast)" }),
        -- 4: Final Confession -> Shadow Metal Guardian (Stonebrunt Mountains).
        S.handin({ zone = 'stonebrunt', npc = { name = 'Shadow Metal Guardian', npc = true }, taskName = TASK,
            objective = 4, items = { "Spear Sundering Ivory's Final Confession" },
            desc = "deliver the Final Confession to Shadow Metal Guardian (Stonebrunt)" }),
        -- 5: return to Spear Sundering Ivory and report (hail, no item).
        S.handin({ zone = 'aalishai', npc = GIVER, taskName = TASK, objective = 5,
            desc = 'return to Spear Sundering Ivory and tell him what happened' }),
    },
})
