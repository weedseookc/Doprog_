# Trials of Smoke — Overview (The Burning Lands)

The instanced Plane of Smoke trial system. This file consolidates the trial-system
mechanics that the individual per-trial reference files (`trialofthree.md`, etc.) and
the zone/quest pages only cover piecemeal.

Sources:
- https://tbl.eqresource.com/trialsofsmoke.php  (the umbrella "Trials of Smoke" task page)
- https://tbl.eqresource.com/theplaneofsmoke.php
- https://tbl.eqresource.com/progression.php
- https://tbl.eqresource.com/trialofthree.php
- https://tbl.eqresource.com/trialofthespeakersamphitheater.php
- https://achievements.eqresource.com/achievements.php?id=2600100  (Trials of Smoke (Group))
- https://achievements.eqresource.com/achievements.php?id=2681710  (Mercenary of The Plane of Smoke)
- https://www.raspersrealm.com/Everquest/TBL/miscProgression.html
- ZAM: https://everquest.allakhazam.com/wiki/eq:Progression_Through_The_Burning_Lands (403 to fetcher; surfaced in search)

---

## 1. How to ENTER the Trials of Smoke instance

The Trials of Smoke is an **instanced version of The Plane of Smoke**, reached from
**Stratos: Zephyr's Flight** (the only zone unlocked at expansion start).

Prerequisite chain (from `progression.php` and `trialsofsmoke.php`):
1. Complete the solo task **"Soldier of Air"** (given by Grieving Soul Scent in Stratos).
2. Complete the group mission **"Fight Fire"** (also Grieving Soul Scent line).
   - Completing "Fight Fire" is what **enables access to the instanced Plane of Smoke**
     from Stratos. (It also enables the raid version of Fight Fire.)

Entry trigger — the umbrella **"Trials of Smoke"** task page states the task:
- **"Step on the Plane of Smoke zone line or Click Airbound Skystone"** — and it
  **"Locks on Request."**
- The **Airbound Skystone** is the clickable item/object at the portal that ports you
  into the instance. (Item: items.eqresource.com/items.php?id=116844)

So: clear Soldier of Air + Fight Fire, then either walk onto the Plane of Smoke zone
line in Stratos OR click the Airbound Skystone to be ported into your own instanced
Plane of Smoke (the "Trials" version of the zone).

Umbrella task details (`trialsofsmoke.php`):
- Objective: **"Defeat any trial that you have not already defeated and claim your reward"**
- Time Limit: **6 Hours** · Repeatable: **Yes**

---

## 2. How many trials — FIVE or SIX?  → Effectively FIVE.

The discrepancy is real and traces to the zone page wording.

- `theplaneofsmoke.php` says: **"The Plane of Smoke requires players to have completed
  the six Trials of Smoke before they can enter the static zone."** This "six" is the
  source of confusion and appears to be an error / leftover, OR it is counting the two
  prerequisite steps as part of the chain (see the achievement breakdown below).
- Every authoritative source that enumerates the trials lists **exactly FIVE**, and the
  `trialsofsmoke.php` task page itself says **"There are five distinct trials."**

The five trials (with their tunnel locations per rasper's realm):
1. **Trial of Three** — 1st Tunnel
2. **Trial of the Eternal Cyclone** — 2nd Tunnel
3. **Trial of the Speaker's Amphitheater** — 3rd Tunnel
4. **Trial of the Wending Ways** — 5th Tunnel
5. **Trial of the Ashes of Rusted Cliff's Glory** — 6th Tunnel

**Resolution:** There are **five** actual trials. The likely reason "six" appears is
that the **"Trials of Smoke (Group)" achievement** (id=2600100) bundles **seven** steps:
the 2 prerequisites (Soldier of Air, Fight Fire) plus the 5 trials. If one mentally
groups the prereqs as "the rest" plus five trials, or miscounts, "six" results. The
zone page's "six Trials of Smoke" wording is not borne out by any trial enumeration —
treat the count as **five trials** for gameplay purposes.

---

## 3. How each trial is STARTED inside the instance

**Each trial has its own starter NPC, and they ALL share the same name:
"Waves of Saffron Sky."** It is not a single central NPC — there is a
"Waves of Saffron Sky" stationed in each trial's tunnel.

Confirmed across multiple individual trial pages (all identical pattern):
- Trial of Three: Start NPC **"Waves of Saffron Sky"**, request phrase **"prepared"**.
- Trial of the Speaker's Amphitheater: Quest Giver **"Waves of Saffron Sky"**, request
  phrase **"prepared"**.
- Trial of the Ashes of Rusted Cliff's Glory: walkthrough step 1 is verbatim
  **"Speak with Waves of Saffron Sky to start the trial."**

Exact mechanic (verbatim, Speaker's Amphitheater page): players **"must speak with Waves
of Saffron Sky to initiate the event"** by saying **"prepared"**. rasper's realm states
it the same way: players "encounter five trials from NPCs named 'Waves of Saffron Sky,'
located in different tunnels … Each trial is initiated when players are 'prepared' by
the NPC."

So the answer is: **NOT one central "Waves of Saffron Sky."** Each of the five trials
has its own same-named "Waves of Saffron Sky" mob in its tunnel; you `/say prepared`
to that trial's Waves of Saffron Sky to begin that specific trial.

---

## 4. "Mercenary of The Plane of Smoke" task

These are the repeatable mercenary kill tasks available in the **static** Plane of Smoke
zone (after the trials are cleared). The **"Mercenary of The Plane of Smoke"**
achievement (id=2681710, **10 AA points**) is earned by completing all six component
kill tasks, given by **two** NPCs:

**Given by "Darkened Victorious Scholar":**
- Kill **Ash Creatures**
- Kill **Flashfires**
- Kill **Blazes** (True Flames)

**Given by "Emerald Hope of the Stars":**
- Kill **Mephits**
- Kill **Twisters**
- Kill **Breeze Creatures**

Notes / caveats:
- The eqresource quest-by-name / quests-npc pages did not expose the exact **request
  phrases or numeric kill counts** to the fetcher (the detailed sub-pages returned only
  navigation, and the per-task numbers are not quoted in any retrieved source).
  RedGuides thread 95353 only adds that Mephits spawn **"down in the area where there is
  Lava"** of the static zone.
- ZAM lists "Mercenary of The Plane of Smoke" as a **10-point achievement** (quest=9235),
  matching eqresource.
- **Task giver summary:** two givers — **Darkened Victorious Scholar** (Ash/Flashfire/
  Blaze creatures) and **Emerald Hope of the Stars** (Mephit/Twister/Breeze creatures).

---

## 5. Shared trial mechanics, lockouts, and progression

**Per-trial common parameters** (identical across all five trial pages):
- Task Type: **Group**, 1 minimum / 6 maximum players.
- Time Limit: **6 Hours**.
- **Lockout: 60 Hours** (~2.5 days) per individual trial.
- Repeatable: Yes.
- Single objective each: **"Defeat any trial that you have not already defeated and
  claim your reward. 0/1 (Plane of Smoke)"**
- Completion = **open a chest** to finish; rewards include experience and ~**212pp 5gp**.

**Common combat pattern** (e.g. Speaker's Amphitheater): timed **waves of mobs that drop
clickable sigils** which teleport players to named bosses; only **six sigils** drop from
trash waves (insufficient for a full group, so the group must choose who fights bosses);
**four colored sigils** map to four named enemies; players must wait for trash waves to
finish before using sigils; a **"Sigil of the Overlord of Ash"** transports the group to
the final boss.

**One trial vs. all five — progression impact** (from `progression.php`):
- Verbatim: **"If you beat a Single Trial or have its lockout, you will be allowed
  through the Trial zone to Empyr."** → Beating (or being locked out of) just **one**
  trial is enough to **pass through the instanced zone to Empyr: Realms of Ash**, and to
  unlock the **"Rise of Smoke" raid** request.
- However, entering the **static (non-instanced) Plane of Smoke** zone — and thus the
  mercenary tasks and clean travel without juggling instance event-wins/lockouts —
  requires beating **all five** trials.

**"Trials of Smoke (Group)" achievement** (id=2600100, **10 points**) — the bundle that
**grants access to The Plane of Smoke**. Its seven steps:
1. Grieving Soul Scent - **Soldier of Air**
2. Grieving Soul Scent - **Fight Fire**
3. Trial of Smoke: **Trial of Three**
4. Trial of Smoke: **Trial of the Speaker's Amphitheater**
5. Trial of Smoke: **Trial of the Eternal Cyclone**
6. Trial of Smoke: **Trial of the Ashes of Rusted Cliff's Glory**
7. Trial of Smoke: **Trial of the Wending Ways**

(Note this achievement is what most cleanly explains the "five trials + two prereqs"
structure that the zone page loosely summarized as "six.")
