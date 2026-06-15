# Field calibration checklist

All 46 TBL quests/missions are encoded from their individual tbl.eqresource.com
pages: real giver NPCs, request phrases, objective counts and indices, named
mobs, item turn-ins, say-phrase puzzles and porter hops. The only things that
still need an in-game read are listed below — the framework runs and routes
without them (it navigates to NPCs/targets by spawn name), and these just sharpen
inter-zone travel and a couple of edges.

Use `/loc` in-game for coordinates and confirm zone short names with
`${Zone.ShortName}`.

## 1. Inter-zone travel — `data/zones.lua`

For each edge set `loc` (where to stand) and, for portals, the exact `action`.
The graph shape (which zones connect) is correct; only these values are blank:

- [ ] potranquility ↔ stratos (entry portal command + loc)
- [ ] stratos → smoke (Trials of Smoke entry) and back
- [ ] stratos ↔ esianti ↔ empyr ↔ aalishai ↔ mearatas (portal loc/action each)
- [ ] doomfire → stratos, chamberoftears → stratos return portals
- [ ] (optional) PoK-book routing to the classic zones used by Fragmented Coterie
      (timorous, sro, barren, stonebrunt) and to `relic` for Strange Magic.

## 2. A few unconfirmed NPC names

- [ ] **Plane of Smoke** mercenary giver — not on eqresource's NPC list; the
      `mercenary_plane_of_smoke` quest is intentionally left out of that zone's
      index so it can't block progression. Fill the name and re-add it.
- [ ] **Doomfire** "Strange Magic" — started by clicking the door in Relic, the
      Artifact City; confirm the zone short name (`relic`) and door targeting.
- [ ] **Aalishai** "Enter Mearatas" giver — eqresource lists it ambiguously
      ("Ring or Blazing Sorrows Darkness"); encoded as *Blazing Sorrows Darkness*.

## 3. Combat positioning locs (the only blanks in the mechanics)

These mission/trial positioning spots are encoded as real `doprog.Mechanic`
reactions but need their `/loc` filled in-game (search `TODO(calibrate)`). The
flee mechanics (Iron Heart boulder, etc.) already work without any loc.

- [ ] **Prince Ralaifin** — `HIDE_LOC` (the valley LoS-break spot for the
      "reaching rapture" emote) and `AURA_LOC` (where the tank holds in the fire
      aura). `zones/empyr/mission_prince_ralaifin.lua`.
- [ ] **Trial of the Wending Ways** — `BRAZIER` loc(s) to drag the fire boss to.
      `zones/plane_of_smoke/trials/trial_wending_ways.lua`.

## 5. In-game tuning that can't be pre-baked

- **Trial of Three / Wending Ways** kill order IS solved at run time
  (`clue_solver.lua` decodes the clue emotes via Spawn.Height/position;
  `portal_solver.lua` counts portals per element). The only calibration is if the
  in-game clue phrasing or portal spawn names differ from the decode tables —
  adjust `DECODE` / `portalSearch` there. Speaker's Amphitheater targets whichever
  named is up (random pairs).
- **Window automations** (task-accept, give/trade, ground-spawn `/itemtarget`,
  chest open) use standard UI/notify commands; confirm the window/button names
  match your client/server build. All such commands are localized to the step
  files and `services/mq_adapter.lua` for easy adjustment.
- **Faction/sneak gates** (e.g. Earning One's Place, several "say to NPC" steps)
  are noted in comments but not automated; ensure standing or use sneak.

## 6. Task-name spelling

Quest completion is matched by name (`completionTask`). If a `taskExists` lookup
ever fails in-game, reconcile the spelling/capitalization in the quest file with
the exact in-game task journal title.
