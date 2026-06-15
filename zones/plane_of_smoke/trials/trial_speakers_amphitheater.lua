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

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'smoke',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'smoke', npc = STARTER, taskName = TASK, request = 'prepared',
            desc = "start Trial of the Speaker's Amphitheater (say \"prepared\")" }),
        S.combat({ zone = 'smoke', target = { name = 'Alabaster Moonbreeze', npc = true },
            desc = 'defeat Alabaster Moonbreeze (blue sigil, SE)' }),
        S.combat({ zone = 'smoke', target = { name = 'Sunbird of the Dawn', npc = true },
            desc = 'defeat Sunbird of the Dawn (red sigil, NW)' }),
        S.combat({ zone = 'smoke', target = { name = 'Grinning Monsoon', npc = true },
            desc = 'defeat Grinning Monsoon (purple sigil, SW)' }),
        S.combat({ zone = 'smoke', target = { name = 'Diamond Earthshaker', npc = true },
            desc = 'defeat Diamond Earthshaker (orange sigil, NE)' }),
        S.combat({ zone = 'smoke', taskName = TASK,
            target = { name = 'overlord of ash', npc = true },
            desc = 'use the sigil of the overlord of ash and defeat the final boss' }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
