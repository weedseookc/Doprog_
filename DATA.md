# Field calibration checklist

doprog ships with the full TBL progression structure and real quest-giver names
(from tbl.eqresource.com). A short list of values can only be read in-game; the
framework runs and routes without them (it navigates to NPCs and targets by spawn
name), but filling these in sharpens inter-zone travel and a couple of edges.

Use `/loc` in-game for coordinates and confirm zone short names with
`${Zone.ShortName}`.

## 1. Inter-zone travel — `data/zones.lua`

For each edge, set `loc` (where to stand) and, for portals, the exact `action`
(the clicky command or hail). These are the only blanks in the zone graph; its
shape (which zones connect) is already correct.

- [ ] potranquility → stratos — entry portal command + loc
- [ ] stratos ↔ potranquility — zone-line loc
- [ ] stratos → smoke — Trials of Smoke entry (after Fight Fire) + loc
- [ ] smoke → stratos — trial exit loc
- [ ] stratos ↔ esianti — portal loc/action
- [ ] esianti ↔ empyr — portal loc/action
- [ ] empyr ↔ aalishai — portal loc/action
- [ ] aalishai ↔ mearatas — portal loc/action
- [ ] doomfire → stratos, chamberoftears → stratos — return portals

## 2. Unconfirmed NPC names

- [ ] **Plane of Smoke** mercenary task giver — name not on eqresource's NPC list.
      Set in `zones/plane_of_smoke/mercenary_plane_of_smoke.lua`, then add it back
      to that zone's `index.lua` (it is intentionally omitted so it can't block
      progression).
- [ ] **Doomfire** "Strange Magic" giver — currently assumed to be
      *Unrepentant Sunrise* (confirmed giver of Delivery and Remodeling). Verify.
- [ ] **Aalishai** "Enter Mearatas" giver — eqresource lists it ambiguously
      ("Ring or Blazing Sorrows Darkness"); encoded as *Blazing Sorrows Darkness*.

## 3. Objective indices (multi-objective tasks)

Generated quests model the common two-objective shape: objective 1 = combat,
hand-in = the "return and report" objective. Tasks with several distinct kill
objectives need one CombatStep per objective with the right `objective = N`.
Confirm per task on its eqresource page and edit `tools/gen_quests.lua` (or the
generated file) accordingly. Known so far:

- Soldier of Air: obj1 = defeat 5 invading forces (Brass Phoenix Brigade in the
  smoke area), obj2 = return to Grieving Soul Scent.
- Do Unto Them: obj1 = defeat 9 (blue-con near the PoT zone line), obj2 = return.

## 4. Task name spelling

The Task TLO is matched by name (`completionTask`). If a `taskExists` lookup ever
fails in-game, reconcile the spelling/capitalization in the quest file with the
exact in-game task journal title.
