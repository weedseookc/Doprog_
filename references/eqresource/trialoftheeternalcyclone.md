# Trial of the Eternal Cyclone

Expansion: **The Burning Lands (TBL)** — Zone: **The Plane of Smoke** (Trials of Smoke instance)
Trial type: One of the five **Trials of Smoke** group missions.

**Primary source:** https://tbl.eqresource.com/trialoftheeternalcyclone.php
**Additional sources:**
- ZAM / Allakhazam quest 9336: https://everquest.allakhazam.com/db/quest.html?quest=9336
- EQ Freelance T1 Plane of Smoke guide: https://forums.eqfreelance.net/index.php?topic=21470.0
- RedGuides "Anyone done Trial of the Eternal Cyclone?": https://www.redguides.com/community/threads/anyone-done-trial-of-the-eternal-cyclone.69416/
- RedGuides "Trial of the Eternal Cyclone questions": https://www.redguides.com/community/threads/trial-of-the-eternal-cyclone-questions.78697/
- Achievements (subcategory): https://achievements.eqresource.com/subcategories.php?id=2607
- Savior of The Plane of Smoke achievement: https://achievements.eqresource.com/achievements.php?id=2681770
- Rasper's Realm TBL progression: https://www.raspersrealm.com/Everquest/TBL/miscProgression.html

---

## Start / Logistics

| Field | Value |
|---|---|
| Start NPC | **Waves of Saffron Sky** (Plane of Smoke, in the instanced Trials of Smoke area / "2nd Tunnel" per ZAM) |
| Request Phrase | **`prepared`** |
| Task Type | Group — 1 minimum, 6 maximum players |
| Time Limit | 6 Hours |
| Lockout | 60 Hours |
| Repeatable | Yes |
| Objective | "Defeat any trial that you have not already defeated and claim your reward. 0/1 (Plane of Smoke)" |
| Coin Reward | 212 Platinum, 5 Gold |
| Other Reward | Experience |

> Note: Saying `prepared` to the NPC spawns/starts the event. Pre-position the group **before** triggering — see Strategy.

---

## Boss

**Disappointed Heart's Torrent** — a large cyclone/tornado-type boss.

Key behaviors (multiple posters confirm):
- **Permanently rooted.** Spawns on a platform at the top of a spiral ramp (west/southwest area of the map).
- **Does not summon.** "The boss up top is rooted, does not summon, completely does nothing if you stay away from it." (Vumad)
- **HP-locked while any add is alive.** "The boss is HP locked anytime an add is up so don't waste mana during that time. The faster the adds die the longer you have to DPS boss." (Vumad) Confirmed by Satellite and the RedGuides threads: "He is only able to be attacked when all adds down below are killed."
- Because it does not summon and is rooted, it can be **ranged down** safely — melee/pets sent to it get killed. "This got stupid easy when I realized you can just range DPS the boss instead of tanking him." (Tucoh)

### Boss abilities / emotes

- **Gathering Torrent** — `Decrease Hitpoints by 105959` (i.e. ~105,959 raid-wide AE damage). Begins roughly **30 minutes** into the fight and **ramps up in frequency and intensity** the longer the fight runs. "The AE isn't too bad to start, but the longer you take the faster and faster you get AEs." (Grau)
- **Enrage / power-up emote (verbatim):**
  > "Disappointed Heart's Torrent growls with rage and boredom and tries to end this fight."
- **Power-up timer:** the event escalates if the fight drags on. TenkenT: "event Powers up if take to long (45mins or so give or take some)." So there are effectively two escalation points: AEs begin ~30 min, and a stronger power-up ~45 min.

---

## Adds (the core of the fight)

The fight is fundamentally an **add-control puzzle**, not a tank-and-spank. The boss is locked until adds are dead, so you cycle: kill adds → DPS boss in the gap → repeat.

### Base ("Gust" / "Gritty") elemental adds — yellow con
Named on the live page generically as **Gust** and **Gritty** adds; the actual in-game mob names are:
- **A Freezing Wind**
- **A Gritty Blast**
- **A Blazing Breeze**

### The MERGE mechanic (do NOT let them combine)
If **two** of the yellow-con adds touch / come into contact, they **merge into a stronger being** (an **Ashen Terror**), and the combined add is much harder — enough that an early/under-geared group can wipe or run out of DPS.

- **Merge emote (verbatim):**
  > "A gritty blast and a blazing breeze collide and merge into a stronger being."
- "the trick is to keep the first set of adds from combining, after that they spawn at different intervals so you can just kill the gust or the gritty as they spawn."
- "If you can't keep adds from merging, then you might not have enough DPS to win. **The only way to get a merge is if 2 adds are up at the same time**, and if you aren't getting adds down, you can't DPS the boss."

### Higher adds — Phoenix and Eggs
- **A Phoenix Supernova** — spawns and in turn **spawns Eggs**. Kill the Phoenix to stop egg production entirely. ("Killing the Phoenix Supernova prevents egg spawns and stops player targeting emotes.")
- **An Egg** — targets a random player and detonates with a large AE unless killed first.
  - **Egg emote (verbatim):**
    > "An egg shouts, 'Look out, Soandso, here I come!'"
  - Egg detonation = **Massive Eggsplosion**: ~234k AE direct damage + knockback, ~150' range. Destroy the named/emoted egg immediately.

### Spawn timing
- **Only the FIRST set of adds spawns together** (simultaneously) — this is the critical phase where a merge is possible. Kill that first pair fast and apart.
- After the first set, adds spawn **staggered, individually, roughly every 1–2 minutes** (one poster cited "every 50ish seconds"). Single staggered adds can't merge with each other, so the back half of the fight is much simpler.

### Recommended kill priority
Phoenix Supernova → Egg (if emoted/up) → Gritty Blast / Blazing Breeze / Freezing Wind (kept apart) → then DPS **Disappointed Heart's Torrent** in the open window.

---

## Knockback + Mount tip

- There is a **wind/cyclone knockback (slide)** on the lower area near the boss/cyclone. It is described as **"very minimal."**
- **Mounts negate the slide:** "Mounts eliminate the slide from the wind on the bottom." Being mounted lets the lower group hold position and chase adds without being pushed around. Mounts are strongly recommended for everyone working the adds.

---

## Split-Group Strategy

The standard, widely-confirmed approach is to **split the group into a top team (boss) and a bottom team (adds)**:

**Top of the ramp/platform — Ranged DPS on boss:**
- Park 1–2 **ranged DPS** (wizards, enchanters, casters, rangers) on the ramp to range the rooted boss.
- Do **not** send pets or melee at the boss — they get killed. "Don't send the pet at all." Pet classes keep their pets **below** with the add team.
- Some box setups: `AssistRange=200`, `AutoAssistAt=100`, `UseSmartAssist=0` for the top assistants (so they hold range and don't melee-charge).
- The boss is HP-locked anyway, so top DPS only does real work during the windows when all adds are dead — switch them to assist the boss then.

**Bottom — Add control + tank + healer:**
- Tank/cleric/pets/remaining DPS handle the spawning adds. Box setups commonly use `UseSmartAssist=1` here.
- Tank the adds **just inside the start area, away from the cyclone** ("We tanked just inside the start away from the cyclone"). Keep adds **separated** so they can't merge.
- Use **mounts** to ignore the slide and reposition/chase adds.
- Keep the healer out of the worst of the wind effects; the tank+healer can pre-position up top before the pull if desired (TenkenT), then move down.

**Reset / pre-position trick:** trigger the event with one character saying `prepared` while the rest stay outside the arena, then move everyone into position — this avoids being forced to climb into place under the AE timer.

**Difficulty notes:** add spawning accelerates at the start, then becomes manageable after roughly 4–6 add kills (TenkenT). Under-geared early-progression groups struggle; recommended ~full GMM non-visible + T1 TBL visible gear before attempting.

---

## Achievements

This trial feeds the **Trials of Smoke (Group)** completion and the **Savior of The Plane of Smoke** (40 pts; rewards AA: Hero's Vitality + AA: Hero's Fortitude) meta. The three trial-specific challenge achievements (10 points each) map directly to the three add mechanics:

| Achievement | Points | Maps to mechanic |
|---|---|---|
| **Keep Them Separated** | 10 | Win without letting any of the elemental adds merge (never trigger the "collide and merge" Ashen Terror). |
| **Mix and Match** | 10 | Inverse — deliberately cause the merge / make the Ashen Terror (the "Mix" of two adds). |
| **No Eggsplanations** | 10 | Win without letting an Egg detonate (Massive Eggsplosion) — kill emoted eggs in time, or kill the Phoenix Supernova so no eggs spawn. |

> Source note: eqresource/ZAM list the names and 10-point values but do not publish full requirement text; the mechanic mapping above is inferred from the corresponding add mechanics and is consistent across sources. "Keep Them Separated" and "Mix and Match" are mutually exclusive in a single run.

Also part of **Trials of Smoke (Group)**: https://achievements.eqresource.com/achievements.php?id=2600100

---

## Chest / Loot

The eqresource page does not enumerate specific chest drops beyond the coin (**212 Platinum, 5 Gold**) and **Experience**. As a Trials of Smoke group mission, the meaningful reward is progression/achievement credit toward Plane of Smoke and TBL progression rather than a distinct named-loot table on this page.

---

## Comments (eqresource, verbatim-as-reported)

- **Riou** (Dec 9, 2018): "Questions? Comments? Post them here!"
- **Satellite** (Dec 12, 2018): initial add spawn is the critical phase requiring coordinated kills to prevent combining; subsequent adds spawn individually at 1–2 minute intervals; boss HP-locks whenever adds are present.
- **TenkenT** (Dec 13, 2018): tank+healer can pre-position above before starting (healer away from wind); pets/DPS handle adds below; add spawning accelerates initially but is manageable after 4–6 kills; "event Powers up if take to long (45mins or so give or take some)."
- **Tucoh** (Dec 15, 2018): "This got stupid easy when I realized you can just range DPS the boss instead of tanking him."
- **Vumad** (Dec 17, 2018): position ranged DPS up top on the rooted, non-summoning boss; mounts prevent wind knockback; boss HP-locked when adds spawn; merging adds indicate insufficient DPS; pet classes keep pets below rather than on the named.
- **Grau** (Dec 28, 2018): ~30 minutes before the boss begins AEs; mild at first, intensifying; boss enters aggressive phase casting "Gathering Torrent" for ~105,959 damage.

---

## Quick TL;DR

1. Say `prepared` to **Waves of Saffron Sky**; pre-position first.
2. Park 1–2 **ranged** DPS up top to range the **rooted, non-summoning** boss; never send melee/pets at it.
3. Everyone else tanks/kills **adds below on mounts** (mounts cancel the wind slide).
4. **Boss is HP-locked while any add is up** — only DPS the boss in the gaps between adds.
5. **Do not let the first (simultaneous) add pair merge** into an Ashen Terror ("collide and merge into a stronger being"). Later adds spawn solo every 1–2 min and can't merge.
6. Kill the **Phoenix Supernova** to stop **Eggs**; nuke any emoted egg before it triggers **Massive Eggsplosion** (~234k AE + KB).
7. Don't stall: AEs (**Gathering Torrent**, ~106k) start ~30 min and the boss **powers up ~45 min** ("growls with rage and boredom and tries to end this fight").
