--- doprog.zones.doomfire.task_strange_magic
---
--- Strange Magic (group task 1-6). Source: tbl.eqresource.com/strangemagic
--- Started by CLICKING the door in Relic, the Artifact City (not a hail). The
--- task plays out in that instance.
---
--- Objectives:
---   1. Use the Infused Sandstone Siphon to gather magic from the room. 0/1
---      -> right-click the Infused Sandstone Siphon.
---   2. Defeat the guardians. 0/4 -> Spellbinding Golem, Lifebane Golem, Hex
---      Golem, Arcane Golem (each spawns 2/3/4/5 shardlings on death).
---   3. Use the Infused Sandstone Siphon again. 0/1.
---   4. Open the chest. 0/1.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Strange Magic'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'relic',
    completionTask = TASK,
    steps = {
        -- Request by clicking the door in Relic, the Artifact City.
        S.click({ zone = 'relic',
            action = '/multiline ; /itemtarget door ; /click left door ; /notify TaskSelectWnd TSEL_AcceptButton leftmouseup',
            condition = function(ctx) return ctx.task:has(TASK) end,
            desc = 'click the door in Relic, the Artifact City to start Strange Magic' }),
        S.click({ action = '/itemnotify "Infused Sandstone Siphon" rightmouseup',
            condition = objDone(1), desc = 'use the Infused Sandstone Siphon (obj 1)' }),
        S.combat({ taskName = TASK, objective = 2,
            target = { name = 'Golem', npc = true },
            desc = 'defeat 4 guardians (Spellbinding/Lifebane/Hex/Arcane Golem + shardlings)' }),
        S.click({ action = '/itemnotify "Infused Sandstone Siphon" rightmouseup',
            condition = objDone(3), desc = 'use the Infused Sandstone Siphon again (obj 3)' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
