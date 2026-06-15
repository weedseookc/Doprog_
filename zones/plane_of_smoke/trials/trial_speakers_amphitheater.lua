--- doprog.zones.plane_of_smoke.trials.trial_speakers_amphitheater
---
--- Trial of the Speaker's Amphitheater (group trial). Source:
--- tbl.eqresource.com/trialofthespeakersamphitheater
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; any one progresses you.
---
--- Timed waves drop sigils (clickies) that teleport up to three members to a
--- named boss platform. Defeat the four named (random pairs), then use the
--- "sigil of the overlord of ash" to reach the final boss; the final boss heals
--- to full if anyone remains below. Then open the chest.
---   Alabaster Moonbreeze (blue, SE), Sunbird of the Dawn (red, NW),
---   Grinning Monsoon (purple, SW), Diamond Earthshaker (orange, NE).

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = "Trial of the Speaker's Amphitheater"
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }

-- The four named spawn in RANDOM pairs, so there is no fixed order: doprog
-- targets whichever named is currently up.
local NAMED = {
    'Alabaster Moonbreeze',  -- blue sigil, SE
    'Sunbird of the Dawn',   -- red sigil, NW
    'Grinning Monsoon',      -- purple sigil, SW
    'Diamond Earthshaker',   -- orange sigil, NE
}

--- Pick any living named; once all four are down, the final boss; then nil.
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
            desc = "start Trial of the Speaker's Amphitheater (say \"prepared\")" }),
        -- Clear the four sigil-platform named in whatever order they come up.
        S.combat({ zone = 'smoke', target = nextNamed,
            desc = 'defeat the 4 sigil named (random pairs): Moonbreeze/Sunbird/Monsoon/Earthshaker' }),
        -- Then the final boss (heals to full if anyone is left below).
        S.combat({ zone = 'smoke', taskName = TASK,
            target = { name = 'overlord of ash', npc = true },
            desc = 'use the sigil of the overlord of ash and defeat the final boss' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
