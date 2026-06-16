--- doprog.zones.plane_of_smoke.trials.trial_speakers_amphitheater
---
--- Trial of the Speaker's Amphitheater (group trial, 1-6). Source:
--- tbl.eqresource.com/trialofthespeakersamphitheater
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; defeating any one progresses you.
--- 6h limit, 60h lockout, repeatable.
---
--- FLOW (per eqresource walkthrough): timed trash waves drop sigil clickies that
--- port a few members to the four named mini-boss platforms — "wait to use the
--- sigils until the trash waves are done, there are 3 waves between" them. The
--- four named each pair with a sigil:
---   Alabaster Moonbreeze  - Sigil of the Soaring Heart  (blue,   SE)
---   Sunbird of the Dawn   - Sigil of the Golden Flame   (red,    NW)
---   Grinning Monsoon      - Sigil of the Darkening Depths(purple, SW)
---   Diamond Earthshaker   - Sigil of the Hardening Heart (orange, NE)
--- After all four minis fall, the final sigil ports to the ultimate boss; defeat
--- it to complete the task, then open the chest.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = "Trial of the Speaker's Amphitheater"
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }

-- The four sigil-platform named. They are reached by clicking the matching dropped
-- sigil; doprog targets whichever named is currently up (waves spawn them in no
-- fixed order, so this drives both the trash-wave clears and the minis).
local NAMED = {
    'Alabaster Moonbreeze', -- Sigil of the Soaring Heart   (blue, SE)
    'Sunbird of the Dawn',  -- Sigil of the Golden Flame    (red, NW)
    'Grinning Monsoon',     -- Sigil of the Darkening Depths (purple, SW)
    'Diamond Earthshaker',  -- Sigil of the Hardening Heart (orange, NE)
}

--- Target any living named mini; once all four are down, return nil.
---@param ctx doprog.StepContext
---@return doprog.SpawnQuery|false|nil
local function nextNamed(ctx)
    for _, n in ipairs(NAMED) do
        if ctx.mq:findSpawn({ name = n, npc = true }) ~= nil then
            return { name = n, npc = true }
        end
    end
    return nil
end

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = TASK, request = 'prepared',
            desc = "start Trial of the Speaker's Amphitheater (say \"prepared\" inside)" }),
        -- Defeat the four sigil-platform named in whatever order they come up.
        S.combat({ zone = 'smoke', target = nextNamed,
            desc = 'defeat the 4 sigil named: Moonbreeze/Sunbird/Monsoon/Earthshaker' }),
        -- All four down: the final sigil ports to the ultimate boss; complete the
        -- task by defeating it (final boss name is unpublished, so completion is
        -- gated on the task objective rather than a fabricated spawn name).
        S.combat({ zone = 'smoke', taskName = TASK,
            desc = 'use the final sigil and defeat the ultimate boss' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest to complete the trial' }),
    },
})
