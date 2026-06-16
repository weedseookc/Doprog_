--- doprog.zones.doomfire.task_remodeling
---
--- Remodeling (group task 1-6). Source: tbl.eqresource.com/remodeling.php
--- Giver / turn-in: Unrepentant Sunrise (Doomfire). Request phrase: "remodeling".
--- Zone-in phrase: "ready". 6h limit, 5h lockout, repeatable.
---
--- Objective 1 ("fight your way to the throne room to speak with Fennin Ro" 0/4)
--- is the four gating kills, driven one target type at a time:
---   jopal see-invis -> Guardian of Doomfire -> 2 snails -> General Reparm.
--- Guardian of Doomfire is leashed (regens if pulled out of range) and Dooms a
--- random player who likely dies when it fades; doprog runs the afflicted lead
--- clear on the emote. General Reparm emotes a viral effect — the affected player
--- must run away from the group, so doprog flees on that emote too.
--- Then deliver 1 Saturated Infused Sandstone Siphon to Fennin Ro (obj 2) and
--- open the chest (obj 3).

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Remodeling'
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
        S.pickup({ zone = 'doomfire', npc = GIVER, taskName = TASK, request = 'remodeling',
            desc = 'accept Remodeling from Unrepentant Sunrise (say "remodeling")' }),
        S.click({ zone = 'doomfire', npc = GIVER, action = '/say ready',
            desc = 'enter the instance (say "ready" to Unrepentant Sunrise)' }),
        -- Obj 1 (0/4): clear the route to the throne room, one kind at a time.
        S.combat({ target = { name = 'jopal', npc = true, radius = 1000 },
            desc = 'zone-in: defeat the jopal see-invis mobs' }),
        S.combat({ target = { name = 'Guardian of Doomfire', npc = true, radius = 1000 },
            mechanics = {
                { react = 'flee', emote = 'Doom', window = 10, distance = 50,
                  desc = 'Doom debuff: run the afflicted lead clear (leashed boss; keep it in range)' },
            },
            desc = 'defeat Guardian of Doomfire (leashed; regens if out of range)' }),
        S.combat({ target = { name = 'snail', npc = true, radius = 1000 },
            desc = 'continue east: defeat the 2 snails' }),
        S.combat({ taskName = TASK, objective = 1, target = { name = 'General Reparm', npc = true, radius = 1000 },
            mechanics = {
                { react = 'flee', emote = 'Reparm', window = 12, distance = 60,
                  desc = 'viral emote: run the afflicted lead away so it does not spread' },
            },
            desc = "defeat General Reparm in Fennin's room (completes obj 1)" }),
        -- Obj 2: hand the siphon to Fennin Ro in the throne room.
        S.handin({ zone = 'doomfire', npc = FENNIN, taskName = TASK, objective = 2,
            items = { 'Saturated Infused Sandstone Siphon' },
            desc = 'deliver 1 Saturated Infused Sandstone Siphon to Fennin Ro' }),
        -- Obj 3: open the resulting chest.
        S.click({ zone = 'doomfire', action = '/multiline ; /itemtarget chest ; /click left item',
            condition = function(ctx) return ctx.task:isComplete(TASK) end, desc = 'open the chest' }),
    },
})
