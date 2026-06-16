--- doprog.zones.doomfire.task_delivery
---
--- Delivery (group task 1-6). Source: tbl.eqresource.com/delivery.php
--- Giver / turn-in: Unrepentant Sunrise (Doomfire). Request phrase: "delivery".
--- Zone-in phrase: "ready". 6h limit, 5h lockout, repeatable.
---
--- Objective 1 ("fight your way to the throne room to speak with Fennin Ro" 0/3)
--- is the three gating kills on the route, driven one target type at a time:
---   jopal see-invis (zone-in) -> Guardian of Doomfire -> 2 snails (continue east).
--- The Guardian applies "Doom" to a random player; that player likely dies when it
--- fades, so doprog runs the afflicted lead clear of the group on the emote.
--- Then deliver the duende mold to Fennin Ro (obj 2) and open the chest (obj 3).
---
--- Note: comments report the mold can be stripped on zoning and Fennin sometimes
--- fails to spawn; the published fix is to destroy a stale mold and let
--- Unrepentant Sunrise re-issue one. doprog cannot script a manual destroy, so the
--- mold hand-in is gated on objective 2 and simply retries until it ticks.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Delivery'
---@type doprog.SpawnQuery
local GIVER = { name = 'Unrepentant Sunrise', npc = true }
---@type doprog.SpawnQuery
local FENNIN = { name = 'Fennin Ro', npc = true }

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'task',
    zone = 'doomfire',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'doomfire', npc = GIVER, taskName = TASK, request = 'delivery',
            desc = 'accept Delivery from Unrepentant Sunrise (say "delivery")' }),
        S.click({ zone = 'doomfire', npc = GIVER, action = '/say ready',
            desc = 'enter the instance (say "ready" to Unrepentant Sunrise)' }),
        -- Obj 1 (0/3): clear the route to the throne room, one kind at a time.
        S.combat({ target = { name = 'jopal', npc = true, radius = 1000 },
            desc = 'zone-in: defeat the jopal see-invis mobs' }),
        S.combat({ target = { name = 'Guardian of Doomfire', npc = true, radius = 1000 },
            mechanics = {
                { react = 'flee', emote = 'Doom', window = 10, distance = 50,
                  desc = 'Doom debuff: run the afflicted lead clear of the group (flees the Guardian)' },
            },
            desc = 'defeat Guardian of Doomfire (random Doom debuff)' }),
        S.combat({ taskName = TASK, objective = 1, target = { name = 'snail', npc = true, radius = 1000 },
            desc = 'continue east: defeat the 2 snails (completes obj 1)' }),
        -- Obj 2: hand the duende mold to Fennin Ro in the throne room.
        S.handin({ zone = 'doomfire', npc = FENNIN, taskName = TASK, objective = 2,
            items = { 'duende mold' }, desc = 'deliver the duende mold to Fennin Ro' }),
        -- Obj 3: open the resulting chest.
        S.click({ zone = 'doomfire', action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
