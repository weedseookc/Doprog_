--- doprog.zones.plane_of_smoke.trials.trial_ashes_of_rusted_cliffs_glory
---
--- Trial of the Ashes of Rusted Cliff's Glory (group trial). Source:
--- tbl.eqresource.com/trialoftheashesofrustedcliffsglory
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; any one progresses you.
---
--- Loop (x3): when the boss despawns, defeat the yellow-con mobs that pop, then
--- defeat the correct green-con mobs until the boss re-pops in a different
--- elemental form. Avoid the Fireball auras (target a random player and follow).
--- Then open the chest. (Single 0/1 objective; doprog drives kills, host fights.)

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = "Trial of the Ashes of Rusted Cliff's Glory"
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = TASK, request = 'prepared',
            desc = "start Trial of the Ashes of Rusted Cliff's Glory (say \"prepared\")" }),
        -- Single objective: doprog advertises NEED_COMBAT and the host clears the
        -- yellow/green-con waves until the shifting boss is defeated (repeat x3).
        S.combat({ zone = 'smoke', taskName = TASK,
            desc = 'clear yellow/green-con waves; defeat the shifting boss (x3); avoid Fireball auras' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
