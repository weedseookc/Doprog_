--- doprog.zones.aalishai.partisan_fragmented_coterie
---
--- Fragmented Coterie (solo task). Source: tbl.eqresource.com/fragmentedcoterie
--- Giver/turn-in: Spear Sundering Ivory (Aalishai). Request: "exile". Prereqs:
--- Soldier of Air, Fight Fire, any Trials of Smoke, Prisoner's Dilemma, Palace
--- of Embers. 5h lockout.
---
--- A courier run: deliver four confessions to NPCs in CLASSIC zones, then return.
--- (Those zones are outside the bundled TBL zone graph — travel to them is via
--- Plane of Knowledge books; the steps carry the right zone short names so once
--- the graph is extended with PoK routing they route automatically.)
---
--- Objectives:
---   1. Deliver the First Confession to Ebon Ice Servant (Timorous Deep).
---   2. Deliver the Second Confession to Towering Silhouette (South Desert of Ro).
---   3. Deliver the Third Confession to Alabaster Rose Moon (Barren Coast).
---   4. Deliver the Final Confession to Shadow Metal Guardian (Stonebrunt Mtns).
---   5. Return to Spear Sundering Ivory and hail.

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
        S.pickup({ zone = 'aalishai', npc = GIVER, taskName = TASK, request = 'exile',
            desc = 'accept Fragmented Coterie (say "exile")' }),
        S.handin({ zone = 'timorous', npc = { name = 'Ebon Ice Servant', npc = true }, taskName = TASK,
            objective = 1, items = { "Spear Sundering Ivory's First Confession" },
            desc = 'deliver the First Confession (Timorous Deep)' }),
        S.handin({ zone = 'sro', npc = { name = 'Towering Silhouette', npc = true }, taskName = TASK,
            objective = 2, items = { "Spear Sundering Ivory's Second Confession" },
            desc = 'deliver the Second Confession (South Desert of Ro)' }),
        S.handin({ zone = 'barren', npc = { name = 'Alabaster Rose Moon', npc = true }, taskName = TASK,
            objective = 3, items = { "Spear Sundering Ivory's Third Confession" },
            desc = 'deliver the Third Confession (Barren Coast)' }),
        S.handin({ zone = 'stonebrunt', npc = { name = 'Shadow Metal Guardian', npc = true }, taskName = TASK,
            objective = 4, items = { "Spear Sundering Ivory's Final Confession" },
            desc = 'deliver the Final Confession (Stonebrunt Mountains)' }),
        S.handin({ zone = 'aalishai', npc = GIVER, taskName = TASK,
            desc = 'return to Spear Sundering Ivory and hail' }),
    },
})
