--- doprog.data.zones
---
--- The Burning Lands inter-zone connection graph, consumed by TravelService.
--- Edges are directed; add the reverse edge where back-travel is possible.
---
--- The graph SHAPE (which zones connect, and in which direction) is correct and
--- drives BFS routing. The `loc` coordinates and portal `action` strings are the
--- only field-calibration items: most TBL zones are entered by clicking a
--- teleporter or hailing a porter once progression is unlocked, and those exact
--- /loc values and commands must be read in-game. See DATA.md for the checklist.
--- Where `loc` is nil, TravelService will route to the correct adjacent zone but
--- relies on the player/crew already being able to cross (or on a filled-in loc).
---
--- Zone short names (verify in-game with ${Zone.ShortName}):
---   potranquility, stratos, smoke, esianti, empyr, aalishai, mearatas,
---   doomfire, chamberoftears

---@type doprog.ZoneGraph
local ZoneGraph = {
    edges = {
        potranquility = {
            { to = 'stratos', kind = 'portal', loc = nil, action = '/say burning lands',
              note = 'TBL entry portal from Plane of Tranquility' },
        },
        stratos = {
            { to = 'potranquility', kind = 'zoneline', loc = nil, note = 'PoT zone line' },
            { to = 'smoke', kind = 'portal', loc = nil, action = '/say enter the trials',
              note = 'Trials of Smoke instance (after Fight Fire)' },
            { to = 'esianti', kind = 'portal', loc = nil, note = 'unlocked after Fight Fire' },
        },
        smoke = {
            { to = 'stratos', kind = 'zoneline', loc = nil, note = 'trial exit' },
        },
        esianti = {
            { to = 'stratos', kind = 'portal', loc = nil },
            { to = 'empyr', kind = 'portal', loc = nil, note = 'tier-2 unlock' },
        },
        empyr = {
            { to = 'esianti', kind = 'portal', loc = nil },
            { to = 'aalishai', kind = 'portal', loc = nil, note = 'after Palace of Embers' },
        },
        aalishai = {
            { to = 'empyr', kind = 'portal', loc = nil },
            { to = 'mearatas', kind = 'portal', loc = nil, note = 'after Enter Mearatas' },
        },
        mearatas = {
            { to = 'aalishai', kind = 'portal', loc = nil },
        },
        doomfire = {
            { to = 'stratos', kind = 'portal', loc = nil },
        },
        chamberoftears = {
            { to = 'stratos', kind = 'portal', loc = nil },
        },
    },
}

return ZoneGraph
