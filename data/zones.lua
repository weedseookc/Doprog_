--- doprog.data.zones
---
--- The Burning Lands inter-zone connection graph (consumed by TravelService),
--- built from the eqresource zone overview pages. Topology is the real one:
--- TBL has TWO branches off the Stratos hub (eqresource "Zone Connections"):
---     Stratos -> Plane of Smoke -> Empyr -> Aalishai
---     Stratos -> Esianti -> Mearatas
--- with Stratos itself reached from the Plane of Tranquility portal.
---
--- Coordinate conventions (as published per page, noted on each edge):
---   * Stratos & Plane of Smoke pages quote human /loc style -> stored as {y, x}
---     (2D); MqAdapter navs `/nav loc Y X` and the mesh resolves Z.
---   * Empyr / Aalishai / Mearatas pages quote raw map points "P x, y, z" ->
---     stored as {x, y, z}; MqAdapter navs `/nav locxyz X Y Z`.
--- Each `loc` is on the SOURCE side (where you stand to cross into `to`).
---
--- Shortcuts not modelled as edges (host/char-specific): a Fellowship Campfire or
--- Guild Banner bypasses zone-lock requirements, and the wizard port vendor
--- "Faistwan Toothri" in Esianti (~ /loc 1529, 880) sells teleports to TBL zones.
---
--- Zone short names (verify in-game with ${Zone.ShortName}):
---   potranquility, stratos, smoke, esianti, empyr, aalishai, mearatas,
---   doomfire, chamberoftears

---@type doprog.ZoneGraph
local ZoneGraph = {
    edges = {
        -- Entry: click the Burning Lands portal in the Plane of Tranquility.
        potranquility = {
            { to = 'stratos', kind = 'portal', loc = nil,
              action = '/click left door', note = 'click the TBL portal in PoT (also reachable via Guild Portal)' },
        },

        -- Stratos hub: PoT, Esianti (up the bridges), and the Trials of Smoke.
        stratos = {
            { to = 'potranquility', kind = 'zoneline', loc = { y = -120, x = 80 },
              note = 'Stratos-side PoT entrance' },
            { to = 'esianti', kind = 'zoneline', loc = { y = 8, x = 1111 },
              note = 'follow the floating-island bridges up to the Esianti portal' },
            { to = 'smoke', kind = 'zoneline', loc = { y = -1450, x = 700 },
              note = 'Trial of Smoke passage (after Fight Fire + a Trial)' },
        },

        -- Plane of Smoke: back to Stratos, onward to Empyr.
        smoke = {
            { to = 'stratos', kind = 'zoneline', loc = { y = 5.1974, x = 100 } },
            { to = 'empyr', kind = 'zoneline', loc = { y = -93.9017, x = -950 } },
        },

        -- Empyr: back to Smoke, onward to Aalishai.
        empyr = {
            { to = 'smoke', kind = 'zoneline', loc = { x = -1322.1377, y = -1350.1448, z = -29.4512 } },
            { to = 'aalishai', kind = 'zoneline', loc = { x = 0.0, y = -134.3474, z = -45.2888 } },
        },

        -- Aalishai: terminus of branch 1, back to Empyr.
        aalishai = {
            { to = 'empyr', kind = 'zoneline', loc = { x = 1244.5667, y = -808.3391, z = 159.9864 } },
        },

        -- Esianti: back to Stratos, onward to Mearatas.
        esianti = {
            { to = 'stratos', kind = 'zoneline', loc = nil,
              note = 'descend the bridges to Stratos (Esianti-side loc not published)' },
            { to = 'mearatas', kind = 'zoneline', loc = nil,
              note = 'Esianti-side Mearatas line not published; or use Faistwan Toothri ports' },
        },

        -- Mearatas: terminus of branch 2, back to Esianti.
        mearatas = {
            { to = 'esianti', kind = 'zoneline', loc = { x = -272.5914, y = -682.5793, z = -0.2639 } },
        },

        -- Side hubs (mission-instanced, not physically wired into the branches).
        -- Doomfire is entered via the Tyrant of Fire ring (Old Plane of Fire);
        -- exit by campfire/return to Stratos.
        doomfire = {
            { to = 'stratos', kind = 'portal', loc = nil, action = '/say leave',
              note = 'Doomfire is mission-instanced (Tyrant of Fire ring); campfire out' },
        },
        chamberoftears = {
            { to = 'stratos', kind = 'portal', loc = nil, note = 'side hub; campfire/return to Stratos' },
        },
    },
}

return ZoneGraph
