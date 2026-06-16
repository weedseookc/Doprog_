--- doprog.zones.doomfire.task_strange_magic
---
--- Strange Magic (group task 1-6). Source: tbl.eqresource.com/strangemagic.php
--- STARTED by clicking the door in Relic, the Artifact City (not a hail): target
--- the door with /doortarget, /click left door, then accept the task window. The
--- task then plays out inside that instance. 6h limit, 5h lockout, repeatable.
---
--- Objectives (in order):
---   1. Use the Infused Sandstone Siphon to gather magic from the room. 0/1
---      -> right-click the Infused Sandstone Siphon provided at task start.
---   2. Defeat the guardians. 0/4 -> four guardians; each death spawns adds
---      (2, 3, 4, 5 respectively). One applies "Life and Death" (players must hug
---      together), one applies "Static" (players must spread apart), and the
---      Spellbinding Guardian casts a zone-wide AE negating spell haste. All are
---      rootable / stunnable / mezzable; adds are mezzable.
---   3. Use the Infused Sandstone Siphon again. 0/1 (clear adds first).
---   4. Open the chest. 0/1.
---
--- Note: doprog flees the live guardian on the "Static" emote (spread) and gathers
--- the lead in on "Life and Death" (hug) via a moveTo onto the group; the precise
--- hug loc is calibrated in-game, so until then those reactions are best-effort
--- positioning and the host still owns CC/damage.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Strange Magic'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local GUARDIAN = { name = 'Guardian', npc = true, radius = 1000 }
---@type doprog.SpawnQuery
local ADDS = { name = 'shardling', npc = true, radius = 1000 }

-- Door start: target the door, click it, accept the offered task window.
local START_DOOR = '/multiline ; /doortarget ; /click left door'
    .. ' ; /notify TaskSelectWnd TSEL_AcceptButton leftmouseup'

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'relic',
    completionTask = TASK,
    steps = {
        -- Start: click the door in Relic, the Artifact City, then accept the task.
        S.click({ zone = 'relic', action = START_DOOR,
            condition = function(ctx) return ctx.task:has(TASK) end,
            desc = 'click the door in Relic, the Artifact City to start Strange Magic' }),
        -- Obj 1: right-click the provided siphon to gather magic.
        S.click({ action = '/itemnotify "Infused Sandstone Siphon" rightmouseup',
            condition = objDone(1), desc = 'use the Infused Sandstone Siphon (obj 1)' }),
        -- Obj 2: defeat the 4 guardians (host CCs/mezzes; doprog targets + positions).
        S.combat({ taskName = TASK, objective = 2, target = GUARDIAN,
            mechanics = {
                { react = 'flee', emote = 'Static', window = 10, distance = 40,
                  desc = 'Static: spread the lead away from the others' },
                { react = 'aura', emote = 'Life and Death', window = 10,
                  desc = 'Life and Death: hug together (loc calibrated in-game)' },
            },
            desc = 'defeat the 4 guardians (Spellbinding zone-wide AE; hug/spread emotes)' }),
        -- Step 3 prep: clear the shardling adds the guardians spawned on death.
        S.combat({ target = ADDS, desc = 'clear the shardling adds (mezzable)' }),
        -- Obj 3: use the siphon again now the room is clear.
        S.click({ action = '/itemnotify "Infused Sandstone Siphon" rightmouseup',
            condition = objDone(3), desc = 'use the Infused Sandstone Siphon again (obj 3)' }),
        -- Obj 4: open the chest.
        S.click({ action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
