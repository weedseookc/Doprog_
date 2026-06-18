# Trial of the Ashes of Rusted Cliff's Glory

A group Trial of Smoke in **The Plane of Smoke** (The Burning Lands expansion). This
is a shifting-element boss event combined with a "guessing game" repop mechanic and a
chasing fireball aura.

**Primary source:** <https://tbl.eqresource.com/trialoftheashesofrustedcliffsglory.php>

**Additional sources:**
- ZAM / Allakhazam quest entry (quest 9335): <https://everquest.allakhazam.com/db/quest.html?quest=9335>
- ZAM "All Alone" achievement (quest 9293): <https://everquest.allakhazam.com/db/quest.html?quest=9293>
- RedGuides — Trials of Smoke strategy thread: <https://www.redguides.com/community/threads/trials-of-smoke.72766/>
- RedGuides — Test Patch Notes 12 Feb 19 (All Alone bug fix): <https://www.redguides.com/community/threads/test-patch-notes-12-feb-19-qol-edition.68384/>
- EQ Resource — Trials of Smoke (Group) achievement: <https://achievements.eqresource.com/achievements.php?id=2600100>
- EQ Resource — Challenger of The Burning Lands achievement: <https://achievements.eqresource.com/achievements.php?id=2600040>
- EQ Resource — Trials of Smoke overview: <https://tbl.eqresource.com/trialsofsmoke.php>
- EQ Resource — The Plane of Smoke overview: <https://tbl.eqresource.com/theplaneofsmoke.php>

---

## Quick Info

| Field | Value |
|---|---|
| **Starting NPC** | Waves of Saffron Sky (marked with a small black box on the map) |
| **Zone** | The Plane of Smoke (inside the Trials of Smoke instance) |
| **Request Phrase** | "prepared" |
| **Requirements** | Must be inside the Trials of Smoke instance |
| **Type** | Group (1 Minimum, 6 Maximum Players) |
| **Time Limit** | 6 Hours |
| **Lockout** | 60 Hours |
| **Repeatable** | Yes |

### Objective (Exact Wording)
> "Defeat any trial that you have not already defeated and claim your reward. 0/1"

This is one of the five Trials of Smoke. Completing all five (plus the two "Grieving
Soul Scent" tasks) earns the **Trials of Smoke (Group)** achievement, which grants
access to the static Plane of Smoke zone and lets you request the Rise of Smoke raid.

---

## Walkthrough Steps (Verbatim, EQ Resource)

1. "Speak with Waves of Saffron Sky to start the trial"
2. "Defeat the yellow con mobs that pop throughout the event"
3. "when the boss despawns"
4. "Defeat the correct green con mobs until it re-pops in a different elemental form"
5. "repeat 3 times"
6. "There are also Fireball auras to avoid"
7. "Open the chest to complete the trial"

---

## The Shifting-Element Boss Mechanic (DETAILED)

The fight is a single named boss that cycles through **multiple elemental forms**. You
must alternate between damaging the boss and re-popping it in the next form:

1. **Damage the boss until it despawns ("depops").** While doing so, **yellow-con
   elementals spawn on a timer, non-stop** — these are the trash adds and must be
   killed/controlled throughout the entire event.
2. **When the boss depops**, it is replaced by **5 green-con spawns scattered all
   over the island.** You must kill the **correct one** of these 5 to make the boss
   re-pop. The boss then returns in a **different elemental form**.
3. **Repeat this cycle 3 times** (i.e., the boss appears in 3 forms / 3 phases).
   (Note: the original Satellite comment first said "repeat this step 4 times," then
   the corrected comment says "Repeat this 3 times" — the corrected count of **3** is
   authoritative.)

### How to know which green mob to kill — the KEY tip
The "guessing game" framing on the wiki ("kill the *correct* one of 5 green spawns")
is resolved by the community: **the correct green-con repop mob is always named
`a_swirl_of_disturbed_crust`**, and the practical target is
**`a_swirl_of_disturbed_crust05`**. Make a hotbutton:

```
/target a_swirl_of_disturbed_crust05
```

Killing it after each depop immediately re-pops the boss. This is the same target used
for the **Stirring the Dust** achievement (see below).

> tboy6423 (RedGuides): "I've found having a hot button /target a_swirl_of_disturbed_crust05 to get to the rock to respawn quickly before too many adds is a help on ashen cliffs."

> Chanticleer (RedGuides): "if you kill the swirl fast enough after each depop and get the 3 phases dead before the adds get past 1 you actually can get all the achievments. Basiclly - Run into cubby under ramp , Take and pull named into cubby , have team in cubby , rotate the named where his back Is to the group , id save burns until phase 2 or 3 . Kill him down to 65 % I believe - depops , instally find /target a_swirl_of_disturbed_crust05 and kill it , when its dead mob spawns instantly ."

> Hylander (RedGuides): "At 115 the trial of ash is the quickest and easiest trial to complete...get in cubby at bottom of ramp, pet pull boss. Target crust run out and gank when close to cubby entrance and group."

> Chanticleer (RedGuides): "trial of ash hardest one , boxable but hardest"

**Optimal flow (RedGuides synthesis):** Pull the named into the "cubby" under the ramp,
keep the group there with the boss's back to the group, kill the boss down to ~65% so
it depops, immediately `/target a_swirl_of_disturbed_crust05` and kill it (run out and
gank it near the cubby entrance), the boss re-pops instantly, repeat for all 3 phases.
Killing the swirl fast enough keeps the yellow adds capped at ~1 at a time, which also
enables the achievements.

---

## Boss Name(s) / Elemental Forms

The boss cycles through elemental forms. Confirmed:

- **Indomitable Onyx** — a named form of the boss (onyx/earthen). This name is
  confirmed by the official patch note for the **All Alone** achievement (below). The
  "ashen elementals" are the elemental adds tied to this fight.

Per-form ability names and the names of every individual elemental form are **not
documented** in the available public sources (EQ Resource lists the adds only
generically as "yellow con mobs" / "green con mobs"; the repop mob is
`a_swirl_of_disturbed_crust05`). Only **Indomitable Onyx** is named explicitly in
official text.

---

## The Fireball Aura Mechanic

EQ Resource walkthrough text:
> "There are also Fireball auras to avoid"

Satellite (Dec 12, 2018):
> "you also have to avoid the fireball auras that get put down. we ate them and healed through."

Vumad (Dec 17, 2018), describing the aura VERBATIM:
> "The aura targets 1 person at random and follows them. It is a very large aura. We tanked the mob just inside the event. We found it easiest to just eat the aura. It would take me from 175k to 24% so around 150kdd. Other than mana use of the group heal the DD was no problem to heal through."

**How to handle it:** The aura picks **one random player and follows that player** (it
is very large, so dodging is impractical). The accepted strategy is to simply **eat the
aura and heal through it** — it hits for roughly **150k** (took Vumad from 175k to
24%). The only real cost is healer mana on group heals, so plan mana sustain (see
below). Note: avoiding the aura while healing can cause missed heals — Vumad's one
mistake was missing an SK heal while trying to dodge the aura that hit him anyway.

---

## Recommended Strategy / Group Setup

Vumad (Dec 17, 2018), full comment VERBATIM:
> "We got through this fairly easy with the right group and strat.
>
> We had 2 raid tanks and a group cleric. One a paladin and one a SK. This was intentional group setup. The SK main tanked the named and the paladin off tanked the adds.The adds are stunnable a (To quote Raynorel, \"They are stunnable. Paladin easy mode.\")
>
> The only hitch we had was I missed a heal on the SK trying to avoid the aura which hit me anyway. The aura targets 1 person at random and follows them. It is a very large aura. We tanked the mob just inside the event. We found it easiest to just eat the aura. It would take me from 175k to 24% so around 150kdd. Other than mana use of the group heal the DD was no problem to heal through.
>
> Mana was potentially an issue but we used jester, staunch recovery, paladin group heals, etc to make sure we didn't get too close to oom.
>
> We went with 2 tanks because the 1st time I did the event we were fine until the adds and then wiped. It is unlikely that too many tanks can tank the named and the adds and eat the DD. Maybe a paladin chain stunning but some sort of second tank is best atm."

Key takeaways:
- **2 raid tanks + a group cleric.** One SK to main-tank the named, one Paladin to
  off-tank the adds.
- **The adds are stunnable** — "They are stunnable. Paladin easy mode." (Raynorel).
  A Paladin chain-stunning the adds is highly effective.
- **Tank the boss just inside the event** (the "cubby" per RedGuides).
- **Eat the aura and heal through it** (~150k DD); manage mana with Jester's tarot,
  Staunch Recovery, Paladin group heals, etc.
- The first wipe risk is the adds — controlling adds (stuns / killing the swirl fast)
  is the difference between a clean run and a wipe.
- At level 115 the fight is trivial — "Run and done in 3 mins flat."

---

## Achievements

EQ Resource lists the following achievements associated with this trial. Each is a
sub-achievement under **Challenger of The Burning Lands** (60 Points total for all TBL
mission challenges), and completing the trial counts toward **Trials of Smoke (Group)**
(10 Points).

| Achievement | Notes |
|---|---|
| **Trials of Smoke (Group)** | 10 pts. Earned by completing all five Trials of Smoke + the two "Grieving Soul Scent" tasks (Soldier of Air, Fight Fire). Grants access to The Plane of Smoke. |
| **Stirring the Dust** | Kill the repop mob `a_swirl_of_disturbed_crust05` (`/target a_swirl_of_disturbed_crust05`). |
| **Fireproof** | Fire/aura-themed challenge for this trial (almost certainly complete without taking/dying to the Fireball aura damage; presumed — exact requirement wording is not published on the source pages). |
| **All Alone** | Defeat **Indomitable Onyx** with **no ashen elementals alive.** |

**Stirring the Dust — target tip (Provolone, April 13, 2024, VERBATIM):**
> "stirring the dust achievement /tar a_swirl_of_disturbed_crust05
>
> Hope this helps someone or maybe me next time I run this for an alt and forget what the name is :P"

**All Alone — official patch note (RedGuides, Test Patch Notes 12 Feb 19), VERBATIM:**
> "Trial of the Ashes of Rusted Cliff's Glory - Fixed an error that would allow completion of the All Alone achievement when there were ashen elementals alive when Indomitable Onyx was defeated."

This patch confirms **All Alone** requires the boss (**Indomitable Onyx**) to die with
**zero ashen elementals (adds) alive** — i.e., fully clear the adds before the kill.
Combined with Chanticleer's note, killing the swirl fast enough to keep adds at ≤1 lets
you snag all achievements in one clean run.

---

## Rewards / Chest Loot

- Experience
- **212 Platinum, 5 Gold**

No specific named chest item/loot table is documented on the EQ Resource page beyond
experience and coin. (ZAM quest 9335 mirrors this; its full page returned HTTP 403 and
could not be scraped for an item list at time of writing.)

---

## All Player Comments (Verbatim, EQ Resource)

**Provolone — April 13, 2024, 12:28:54 AM:**
> "stirring the dust achievement /tar a_swirl_of_disturbed_crust05
>
> Hope this helps someone or maybe me next time I run this for an alt and forget what the name is :P"

**Vumad — December 17, 2018:**
> "We got through this fairly easy with the right group and strat.
>
> We had 2 raid tanks and a group cleric. One a paladin and one a SK. This was intentional group setup. The SK main tanked the named and the paladin off tanked the adds.The adds are stunnable a (To quote Raynorel, \"They are stunnable. Paladin easy mode.\")
>
> The only hitch we had was I missed a heal on the SK trying to avoid the aura which hit me anyway. The aura targets 1 person at random and follows them. It is a very large aura. We tanked the mob just inside the event. We found it easiest to just eat the aura. It would take me from 175k to 24% so around 150kdd. Other than mana use of the group heal the DD was no problem to heal through.
>
> Mana was potentially an issue but we used jester, staunch recovery, paladin group heals, etc to make sure we didn't get too close to oom.
>
> We went with 2 tanks because the 1st time I did the event we were fine until the adds and then wiped. It is unlikely that too many tanks can tank the named and the adds and eat the DD. Maybe a paladin chain stunning but some sort of second tank is best atm."

**Satellite — December 12, 2018, 04:56:54 PM:**
> "better descrip. Attack boss til depop, kill the yellow con elementals that spawn(these spawn on a timer non stop). When the boss depops you have to kill the correct one of 5 green spawns all over the island. just kill them til the boss spawns again in a different elemental form. Repeat this 3 times. you also have to avoid the fireball auras that get put down. we ate them and healed through."

**Satellite — December 11, 2018, 06:20:13 PM:**
> "kill namer, and yellow adds, when name despawns you kill the green cons til it appears in a different elemental form, repeat this step 4 times. We ate the aura aoe's"
