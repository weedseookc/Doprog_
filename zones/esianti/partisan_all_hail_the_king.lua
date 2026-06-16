--- doprog.zones.esianti.partisan_all_hail_the_king
---
--- All Hail the King (group task 1-6). Source: tbl.eqresource.com/allhailtheking
--- Giver: Great Sky Ocean (Stratos); objectives are in Esianti. Request: "work".
--- A long 14-objective quest. doprog acts where it can (say-phrases, named-mob
--- combat, the council fight, the note turn-in) and gates the clicky/tradeskill
--- objectives on their counter, with the exact recipe documented for the host.
---
--- Objectives:
---   1.  Speak with Silent White Sky -> say "support for the king" (faction/sneak).
---   2.  Deliver 3 writs to Silent White Sky. 0/3 -> defeat Still Sky's Scholar,
---       Hidden Winds, Wistful Silken Fist; loot their writs; return them.
---   3.  Speak with Maiden of Nine Roses -> say "support for the king".
---   4.  Light a Fire in the Boldness of Great Substantiveness -> kill a jopal in
---       the NW, loot the clicky, use it in the SW building.
---   5.  Flavor the water on Isle of Radiant Mist under the falls -> right-click
---       Nine Rose Dust at the waterfall.
---   6.  Improve 5 brume armors. 0/5 -> right-click Nine Rose Dust on 5 Brume Armors.
---   7.  Give a mortal a hot foot -> kill a jopal, loot the clicky, use it on the
---       Norrathians in the SE building.
---   8.  Return the Rose Dust to Maiden of Nine Roses.
---   9.  Speak with Daughter of the Invincible Sun -> say "support for the king".
---   10. Defeat a council member in a sanctioned fight -> near the Daughter, say
---       "insult" by a Council Member (e.g. Rememberance Consuming Sage) and DPS
---       it to ~9%. (If insult fails, drag a trash NPC over and re-say.)
---   11. Tell Daughter of the Invincible Sun -> hail.
---   12. Speak with Dance of Metal and Ivory -> say "support for the king".
---   13. Deliver a crafted item to Dance of Metal and Ivory -> ONE tradeskill path:
---         Baking: 4 Phoenix Dough + 2 Unebbing Embers + Bread Tin -> Everwarm Bread
---         Jewelcraft: Emblem of Storms + Platinum Bar + 2 Lightning Essences
---                     -> Jagged Emblem Platinum Amulet (Lightning Essences drop
---                     from brume armors). doprog waits on the objective; the host
---                     supplies the combine (cross-zone mats, high skill).
---   14. Hand over 4 notes to Sky Orchid Understanding. 0/4.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'All Hail the King'
---@param n integer
local function objDone(n)
    return function(ctx) return ctx.task:objectiveDone(TASK, n) end
end

---@type doprog.SpawnQuery
local GIVER = { name = 'Great Sky Ocean', npc = true }
local SILENT_WHITE = { name = 'Silent White Sky', npc = true }
local MAIDEN = { name = 'Maiden of Nine Roses', npc = true }
local DAUGHTER = { name = 'Daughter of the Invincible Sun', npc = true }
local DANCE = { name = 'Dance of Metal and Ivory', npc = true }
local ORCHID = { name = 'Sky Orchid Understanding', npc = true }

--- A "say phrase to NPC, gated on its objective" step.
---@param npc doprog.SpawnQuery
---@param phrase string
---@param n integer
---@param desc string
local function say(npc, phrase, n, desc)
    return S.click({ zone = 'esianti', npc = npc, action = '/say ' .. phrase,
        condition = objDone(n), desc = desc })
end

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'esianti',
    completionTask = TASK,
    steps = {
        S.pickup({ zone = 'stratos', npc = GIVER, taskName = TASK, request = 'work',
            desc = 'accept All Hail the King (say "work")' }),
        -- 1
        say(SILENT_WHITE, 'support for the king', 1, 'pledge Silent White Sky (obj 1)'),
        -- 2: three writ mobs, loot, deliver.
        S.combat({ zone = 'esianti', target = { name = "Still Sky's Scholar", npc = true },
            desc = "defeat Still Sky's Scholar for a writ" }),
        S.combat({ zone = 'esianti', target = { name = 'Hidden Winds', npc = true },
            desc = 'defeat Hidden Winds for a writ' }),
        S.combat({ zone = 'esianti', target = { name = 'Wistful Silken Fist', npc = true },
            desc = 'defeat Wistful Silken Fist for a writ' }),
        S.handin({ zone = 'esianti', npc = SILENT_WHITE, taskName = TASK, objective = 2,
            items = { 'Writ', 'Writ', 'Writ' }, desc = 'deliver the 3 writs to Silent White Sky' }),
        -- 3
        say(MAIDEN, 'support for the king', 3, 'pledge Maiden of Nine Roses (obj 3)'),
        -- 4: light the fire (kill jopal NW, loot clicky, use SW building).
        S.combat({ zone = 'esianti', target = { name = 'jopal', npc = true },
            desc = 'kill a jopal (NW) for the fire clicky (obj 4)' }),
        S.wait({ condition = objDone(4),
            desc = 'use the fire clicky in the SW building to light the fire (obj 4)' }),
        -- 5: flavor the water under the falls (right-click Nine Rose Dust there).
        S.click({ zone = 'esianti', action = '/itemnotify "Nine Rose Dust" rightmouseup',
            condition = objDone(5),
            desc = 'right-click Nine Rose Dust at the Isle of Radiant Mist waterfall (obj 5)' }),
        -- 6: improve 5 brume armors — right-click Nine Rose Dust on each (0/5).
        S.click({ zone = 'esianti', npc = { name = 'Brume Armor', npc = true },
            action = '/itemnotify "Nine Rose Dust" rightmouseup', condition = objDone(6),
            desc = 'right-click Nine Rose Dust on 5 Brume Armors around the zone (obj 6)' }),
        -- 7: hot foot a mortal (kill jopal, loot clicky, use SE building).
        S.combat({ zone = 'esianti', target = { name = 'jopal', npc = true },
            desc = 'kill a jopal for the hot-foot clicky (obj 7)' }),
        S.wait({ condition = objDone(7),
            desc = 'use the clicky on the Norrathians in the SE building (obj 7)' }),
        -- 8: return Rose Dust to the Maiden.
        S.handin({ zone = 'esianti', npc = MAIDEN, taskName = TASK, objective = 8,
            items = { 'Rose Dust' }, desc = 'return the Rose Dust to Maiden of Nine Roses' }),
        -- 9
        say(DAUGHTER, 'support for the king', 9, 'pledge Daughter of the Invincible Sun (obj 9)'),
        -- 10: sanctioned council fight (say insult, DPS to ~9%).
        S.click({ zone = 'esianti', npc = { name = 'Rememberance Consuming Sage', npc = true },
            action = '/say insult', condition = objDone(10),
            desc = 'start the sanctioned council fight (say "insult")' }),
        S.combat({ zone = 'esianti', taskName = TASK, objective = 10,
            target = { name = 'Rememberance Consuming Sage', npc = true },
            desc = 'defeat the council member in the sanctioned fight (to ~9%)' }),
        -- 11
        S.handin({ zone = 'esianti', npc = DAUGHTER, taskName = TASK, objective = 11,
            desc = 'tell Daughter of the Invincible Sun of your success' }),
        -- 12
        say(DANCE, 'support for the king', 12, 'pledge Dance of Metal and Ivory (obj 12)'),
        -- 13: tradeskill the crafted item (host supplies the combine).
        S.wait({ condition = objDone(13),
            desc = 'craft + deliver the item to Dance of Metal and Ivory (Everwarm Bread / Jagged Emblem amulet)' }),
        -- 14: hand 4 notes to Sky Orchid Understanding.
        S.handin({ zone = 'esianti', npc = ORCHID, taskName = TASK,
            items = { 'Note', 'Note', 'Note', 'Note' }, desc = 'hand the 4 notes to Sky Orchid Understanding' }),
    },
})
