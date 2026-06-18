--- doprog.zones.plane_of_smoke.trials.trial_eternal_cyclone
---
--- Trial of the Eternal Cyclone (group trial, 1-6). Source:
--- tbl.eqresource.com/trialoftheeternalcyclone
--- Started by saying "prepared" to Waves of Saffron Sky inside the Trials of
--- Smoke instance. One of five trials; defeating any one progresses you.
--- 6h limit, 60h lockout, repeatable.
---
--- MECHANIC (per eqresource + ZAM/RedGuides research): the boss "Disappointed
--- Heart's Torrent" sits rooted at the top, never summons, and is HP-LOCKED while
--- any add is up. On the INITIAL spawn three adds appear together -- A Freezing
--- Wind, A Gritty Blast, A Blazing Breeze -- and if two collide they merge into
--- the stronger "An Ashen Terror" ("a gritty blast and a blazing breeze collide
--- and merge into a stronger being"); after that, adds come solo every 1-2 min and
--- cannot merge. "A Phoenix Supernova" spawns Eggs: an egg locks onto a random
--- player ("...here I come!") and detonates as Massive Eggsplosion (~234k AE +
--- ~150' knockback) -- kill the Phoenix to stop eggs, and flee a live egg. The
--- boss is rooted: range it (melee/pets sent at it die). AEs (Gathering Torrent,
--- -105959) begin ~30 min and it powers up ~45 min -- a damage race. Then chest.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Trial of the Eternal Cyclone'
---@type doprog.SpawnQuery
local STARTER = { name = 'Waves of Saffron Sky', npc = true }
local BOSS = "Disappointed Heart's Torrent"

-- Priority order: kill the merged Ashen Terror first (most dangerous), then the
-- Phoenix Supernova (to stop eggs), then the base adds, then the rooted boss.
local ADD_PRIORITY = {
    'An Ashen Terror', 'A Phoenix Supernova',
    'A Freezing Wind', 'A Gritty Blast', 'A Blazing Breeze',
}

---@param ctx doprog.StepContext
---@return doprog.SpawnQuery|false|nil
local function nextTarget(ctx)
    for _, add in ipairs(ADD_PRIORITY) do
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
        -- Clear adds (don't let the first set merge; kill the Phoenix to stop
        -- eggs) to unlock the HP-locked boss, then burn the rooted boss. Flee a
        -- live egg when one locks onto the lead.
        S.combat({
            zone = 'smoke',
            target = nextTarget,
            mechanics = {
                { react = 'flee', emote = 'here I come', spawn = { name = 'egg' }, distance = 60,
                  desc = 'a Phoenix egg locked on: run it clear before Massive Eggsplosion' },
            },
            desc = 'clear adds (Ashen Terror/Phoenix first), then range ' .. BOSS,
        }),
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end,
            desc = 'open the chest to complete the trial' }),
    },
})
