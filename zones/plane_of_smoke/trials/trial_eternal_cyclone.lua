--- doprog.zones.plane_of_smoke.trials.trial_eternal_cyclone
---
--- Trial of the Eternal Cyclone (group trial, 1-6). Source:
--- tbl.eqresource.com/trialoftheeternalcyclone
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; defeating any one progresses you.
--- 6h limit, 60h lockout, repeatable.
---
--- MECHANIC (per eqresource comments): the boss "Disappointed Heart's Torrent"
--- sits rooted at the top, never summons, and is HP-LOCKED while any add is up.
--- "Gust" and "Gritty" adds spawn periodically below; you must clear the adds to
--- unlock the boss's health, then burn the boss. doprog encodes this kill logic
--- with a dynamic target: any living add first, otherwise the boss. If the fight
--- runs long the boss powers up (~45 min) and emotes that it "growls with rage and
--- boredom and tries to end this fight", then casts Gathering Torrent (a -105959
--- HP nuke ~30 min in) — a damage race, no positioning required. Then the chest.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Trial of the Eternal Cyclone'
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }
local BOSS = "Disappointed Heart's Torrent"

--- Adds first (boss is HP-locked while any add is up), then the boss, then nil.
---@param ctx doprog.StepContext
---@return doprog.SpawnQuery|false|nil
local function nextTarget(ctx)
    for _, add in ipairs({ 'Gust', 'Gritty' }) do
        if ctx.mq:findSpawn({ name = add, npc = true }) ~= nil then
            return { name = add, npc = true }
        end
    end
    if ctx.mq:findSpawn({ name = BOSS, npc = true }) ~= nil then
        return { name = BOSS, npc = true }
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
            desc = 'start Trial of the Eternal Cyclone (say "prepared" inside the instance)' }),
        -- Clear adds to unlock the HP-locked boss, then burn the rooted boss.
        S.combat({
            zone = 'smoke',
            target = nextTarget,
            desc = "clear Gust/Gritty adds, then defeat " .. BOSS,
        }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest to complete the trial' }),
    },
})
