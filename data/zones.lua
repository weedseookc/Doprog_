--- doprog.data.zones
---
--- The Burning Lands inter-zone connection graph, consumed by TravelService.
--- Edges are directed; add the reverse edge where back-travel is possible.
---
--- IMPORTANT (data entry): the `loc` coordinates and portal `action` strings
--- below are PLACEHOLDERS marked with TODO. They must be filled from in-game
--- /loc readings and the actual zone-in mechanics (most TBL zones are reached by
--- clicking a teleporter or hailing a porter NPC once progression is unlocked).
--- The graph SHAPE is correct; only the numbers/commands need confirming. Until
--- then, TravelService will route correctly between adjacent zones but may need
--- the right interaction to actually cross.
---
--- Zone short names (confirm in-game with ${Zone.ShortName}):
---   potranquility, stratos, smoke (Plane of Smoke), esianti, empyr,
---   aalishai, mearatas, doomfire, chamberoftears

---@type doprog.ZoneGraph
local ZoneGraph = {
    edges = {
        -- Entry: Plane of Tranquility -> Stratos via the TBL portal.
        potranquility = {
            { to = 'stratos', kind = 'portal', loc = nil,
              action = '/say burning lands', note = 'TODO: confirm TBL portal mechanic in PoT' },
        },

        -- Stratos: Zephyr's Flight is the hub. Plane of Smoke trials are
        -- instanced off the Fight Fire mission; treat as a portal from here.
        stratos = {
            { to = 'potranquility', kind = 'zoneline', loc = nil, note = 'TODO: PoT exit loc' },
            { to = 'smoke', kind = 'portal', loc = nil,
              action = '/say enter the trials', note = 'TODO: Trials of Smoke entry' },
            { to = 'esianti', kind = 'portal', loc = nil, note = 'TODO: unlocked after Fight Fire' },
        },

        smoke = {
            { to = 'stratos', kind = 'zoneline', loc = nil, note = 'TODO: trial exit' },
        },

        esianti = {
            { to = 'stratos', kind = 'portal', loc = nil, note = 'TODO' },
            { to = 'empyr', kind = 'portal', loc = nil, note = 'TODO: tier-2 unlock' },
        },

        empyr = {
            { to = 'esianti', kind = 'portal', loc = nil, note = 'TODO' },
            { to = 'aalishai', kind = 'portal', loc = nil, note = 'TODO: after Palace of Embers' },
        },

        aalishai = {
            { to = 'empyr', kind = 'portal', loc = nil, note = 'TODO' },
            { to = 'mearatas', kind = 'portal', loc = nil, note = 'TODO: after Enter Mearatas' },
        },

        mearatas = {
            { to = 'aalishai', kind = 'portal', loc = nil, note = 'TODO' },
        },

        -- Doomfire / Chamber of Tears are side hubs reachable from Stratos/PoK.
        doomfire = {
            { to = 'stratos', kind = 'portal', loc = nil, note = 'TODO' },
        },
        chamberoftears = {
            { to = 'stratos', kind = 'portal', loc = nil, note = 'TODO' },
        },
    },
}

return ZoneGraph
