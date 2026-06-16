--- doprog.zones.plane_of_smoke.trials.trial_ashes_of_rusted_cliffs_glory
---
--- Trial of the Ashes of Rusted Cliff's Glory (group trial, 1-6). Source:
--- tbl.eqresource.com/trialoftheashesofrustedcliffsglory
--- Started by saying "prepared" to Waves of Saffron Sky (small black box on the
--- map) inside the Trials of Smoke instance. One of five trials; any one you have
--- not already beaten progresses you. Single 0/1 objective: "Defeat any trial
--- that you have not already defeated and claim your reward."
---
--- Event loop (x3): the boss despawns, yellow-con adds pop (stunnable) — clear
--- them, then defeat the correct green-con mobs until the boss re-pops in a new
--- elemental form. A Fireball aura targets one random player and follows them;
--- doprog flees the live aura spawn so the lead is not the one standing in it.
--- After the third form dies, open the chest. doprog drives targets + positions;
--- the host deals all damage.

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
            desc = 'speak with Waves of Saffron Sky to start the trial (say "prepared")' }),
        -- Single 0/1 objective: doprog advertises NEED_COMBAT so the host clears
        -- the yellow-con adds then the green-con mobs each cycle until the shifting
        -- boss is downed (3 forms). Fleeing the Fireball aura keeps the lead clear.
        S.combat({
            zone = 'smoke',
            taskName = TASK,
            mechanics = {
                { react = 'flee', spawn = { name = 'a_swirl_of_disturbed_crust' }, distance = 40,
                  desc = 'flee the Fireball aura (it follows one random player)' },
            },
            desc = 'clear yellow adds then green-con mobs each cycle; defeat the shifting boss (x3)',
        }),
        S.click({ zone = 'smoke', action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest to complete the trial' }),
    },
})
