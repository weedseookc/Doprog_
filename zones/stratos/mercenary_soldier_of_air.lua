--- doprog.zones.stratos.mercenary_soldier_of_air
---
--- Soldier of Air — the first solo mercenary task, given by Grieving Soul Scent.
--- Completing it (alongside the Fight Fire mission) opens the Plane of Smoke
--- trials, so this is the very first thing doprog works in a fresh TBL run.
---
--- This file is the REFERENCE implementation: it shows the full pickup -> combat
--- -> handin shape with a real giver NPC. The kill target name and objective
--- index are marked TODO and should be confirmed in-game; everything else is
--- production-shaped. doprog never fights the target itself — the CombatStep
--- hands it to the host combat system and waits for the objective to tick.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

--- The giver is reused for pickup and hand-in; spawn-name nav until /loc known.
---@type doprog.SpawnQuery
local GIVER = { name = 'Grieving Soul Scent', npc = true }

---@type doprog.Quest
return Quest.new({
    name = 'Soldier of Air',
    type = 'mercenary',
    zone = 'stratos',
    completionTask = 'Soldier of Air',
    steps = {
        S.pickup({
            zone = 'stratos',
            npc = GIVER,
            taskName = 'Soldier of Air',
            desc = 'accept Soldier of Air from Grieving Soul Scent',
        }),
        S.combat({
            zone = 'stratos',
            -- TODO(data): confirm the actual mob name/objective from eqresource.
            target = { name = 'an air', npc = true },
            taskName = 'Soldier of Air',
            objective = 1,
            desc = 'Soldier of Air: clear the kill objective',
        }),
        S.handin({
            zone = 'stratos',
            npc = GIVER,
            taskName = 'Soldier of Air',
            desc = 'complete Soldier of Air',
        }),
    },
})
