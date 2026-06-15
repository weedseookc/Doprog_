--- doprog.zones.esianti.partisan_of_mice_and_jann
---
--- Of Mice and Jann (solo task). Source: tbl.eqresource.com/ofmiceandjann
--- Giver/turn-in: Joyous Blossom (Esianti). Request: "this". A pure courier
--- chain — carry the escalating argument between four NPCs, then bring the Stack
--- of Insults back. doprog hand-delivers each item in order (no combat).
---
--- Objectives:
---   1. Crisp stack of papers -> Sadness of Distant Mountains.
---   2. Sadness's rebuttal -> Hammer Testing Strike.
---   3. Hammer Testing Strike's retort -> Lydia Springstrong.
---   4. Lydia's counterargument -> Hammer Tearing Strike.
---   5. Hammer Tearing Strike's protest -> Sadness of Distant Mountains.
---   6. Sadness's grievance -> Hammer Tearing Strike.
---   7. Hammer Tearing Strike's challenge -> Sadness of Distant Mountains.
---   8. Stack of Insults -> Joyous Blossom.

local Quest = require('doprog.domain.quest')
local S = require('doprog.steps')

local TASK = 'Of Mice and Jann'
---@type doprog.SpawnQuery
local GIVER = { name = 'Joyous Blossom', npc = true }
local SADNESS = { name = 'Sadness of Distant Mountains', npc = true }
local TESTING = { name = 'Hammer Testing Strike', npc = true }
local LYDIA = { name = 'Lydia Springstrong', npc = true }
local TEARING = { name = 'Hammer Tearing Strike', npc = true }

--- One delivery: give `item` to `npc`, completing objective `n`.
---@param npc doprog.SpawnQuery
---@param item string
---@param n integer
---@param desc string
local function deliver(npc, item, n, desc)
    return S.handin({ zone = 'esianti', npc = npc, taskName = TASK, objective = n,
        items = { item }, desc = desc })
end

---@type doprog.Quest
return Quest.new({
    name = TASK,
    type = 'partisan',
    zone = 'esianti',
    completionTask = TASK,
    prereq = { tasks = { 'Key to the Kingdom' } },
    steps = {
        S.pickup({ zone = 'esianti', npc = GIVER, taskName = TASK, request = 'this',
            desc = 'accept Of Mice and Jann (say "this")' }),
        deliver(SADNESS, 'Crisp stack of papers', 1, 'deliver the papers to Sadness of Distant Mountains'),
        deliver(TESTING, 'rebuttal', 2, "deliver Sadness's rebuttal to Hammer Testing Strike"),
        deliver(LYDIA, 'retort', 3, "deliver the retort to Lydia Springstrong"),
        deliver(TEARING, 'counterargument', 4, "deliver Lydia's counterargument to Hammer Tearing Strike"),
        deliver(SADNESS, 'protest', 5, "deliver the protest to Sadness of Distant Mountains"),
        deliver(TEARING, 'grievance', 6, "deliver Sadness's grievance to Hammer Tearing Strike"),
        deliver(SADNESS, 'challenge', 7, "deliver the challenge to Sadness of Distant Mountains"),
        S.handin({ zone = 'esianti', npc = GIVER, taskName = TASK,
            items = { 'Stack of Insults' }, desc = 'bring the Stack of Insults to Joyous Blossom' }),
    },
})
