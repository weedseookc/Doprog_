--- doprog.zones.plane_of_smoke.trials.trial_ashes_of_rusted_cliffs_glory
---
--- Trial of the Ashes of Rusted Cliff's Glory (group trial, 1-6). Source:
--- tbl.eqresource.com/trialoftheashesofrustedcliffsglory
--- Started by saying "prepared" to Waves of Saffron Sky (small black box on the
--- map) inside the Trials of Smoke instance. One of five trials; any one you have
--- not already beaten progresses you. Single 0/1 objective: "Defeat any trial
--- that you have not already defeated and claim your reward."
---
--- THE TRICK (per ZAM patch note + RedGuides): the boss is "Indomitable Onyx",
--- a single named that cycles 3 elemental forms. Burn it until it depops; while
--- it is down, KILL "a swirl of disturbed crust" (target a_swirl_of_disturbed_
--- crust05) to instantly re-pop it in the next form; repeat 3 times. Yellow-con
--- "ashen elementals" also pop -- clear them (and for the "All Alone" achievement
--- Onyx must die with zero ashen elementals up). The Fireball aura (~150-175k DD)
--- locks onto a random player and follows; the intended play is to EAT it and heal
--- through, NOT dodge -- so doprog does not flee it. doprog targets the right mob
--- each phase; the host deals damage. Then open the chest.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = "Trial of the Ashes of Rusted Cliff's Glory"
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }
local ONYX = { name = 'Indomitable Onyx', npc = true }
local SWIRL = { name = 'a_swirl_of_disturbed_crust05', npc = true }
local ASHEN = { name = 'ashen elemental', npc = true }

--- Onyx when it is up; otherwise the swirl that re-pops it; otherwise clear the
--- ashen-elemental adds. Returns false (wait) between phases -- completion is
--- driven by the task objective, not by a momentary empty target.
---@param ctx doprog.StepContext
---@return doprog.SpawnQuery|false
local function nextTarget(ctx)
    if ctx.mq:findSpawn(ONYX) then return ONYX end
    if ctx.mq:findSpawn(SWIRL) then return SWIRL end
    if ctx.mq:findSpawn(ASHEN) then return ASHEN end
    return false
end

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = TASK, request = 'prepared',
            desc = 'speak with Waves of Saffron Sky to start the trial (say "prepared")' }),
        -- Burn Onyx -> on depop kill the swirl to re-pop the next form (x3); clear
        -- ashen elementals between. Completion is the trial's single 0/1 objective.
        S.combat({
            zone = 'smoke',
            taskName = TASK,
            target = nextTarget,
            desc = 'burn Indomitable Onyx; kill a_swirl_of_disturbed_crust05 to re-pop each form (x3)',
        }),
        S.click({ zone = 'smoke', action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest to complete the trial' }),
    },
})
