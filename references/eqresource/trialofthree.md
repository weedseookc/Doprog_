# Trial of Three (Trials of Smoke)

**Expansion:** The Burning Lands (TBL)
**Zone:** The Plane of Smoke (inside the *Trials of Smoke* instance)

## Sources
- EQ Resource — Trial of Three: https://tbl.eqresource.com/trialofthree.php (primary; clue list, bosses, mechanics, loot, comments)
- ZAM / Allakhazam — Trial of Three (Trial of Smoke), quest #9281: https://everquest.allakhazam.com/db/quest.html?quest=9281
- EQ Freelance — "TBL - Plane of Smoke - T1 - Rise of Smoke": https://forums.eqfreelance.net/index.php?topic=21470.0 (room directions; alternate ability/spell data — see note)
- RedGuides — "Trial of Three decoder" (community macro): https://www.redguides.com/community/resources/trial-of-three-decoder.911/
- RedGuides — Trials of Smoke / The Burning Lands threads: https://www.redguides.com/community/threads/trials-of-smoke.72766/ , https://www.redguides.com/community/threads/the-burning-lands.67559/page-2

> Note on conflicting data: EQ Resource lists this group trial's abilities as *Water Blast / Boiling Mana / Burning Embers / Flaming Defense / Crushing Earth / Choking Dust* with ~35–40k max melee. EQ Freelance lists much larger spells (190k+ "Flaming Embers / Wandering Flames / Ocean Blast / Steaming Mana / Stone Slam / Crushing Stones / Choking Sands") plus a "mephit HP balanced within 8%" rule and a "Called to Task" achievement — that data appears to describe a different/raid-tier Plane of Smoke event and is recorded below only as a cross-reference, not as the group-trial canon.

---

## Quest Start

- **Start NPC:** Waves of Saffron Sky (location marked with `smallblackboxcb.png` on the EQ Resource map)
- **Zone:** The Plane of Smoke
- **Request phrase:** say **`prepared`**
- **Requirement:** You must already be inside the *Trials of Smoke* instance.

### Task Details
| Field | Value |
|---|---|
| Task type | Group (1–6 players) |
| Time limit | 6 hours |
| Lockout | 60 hours |
| Repeatable | Yes |

### Objective (in order)
- *"Defeat any trial that you have not already defeated and claim your reward. 0/1 (Plane of Smoke)"*

---

## The Three Bosses & The Room Layout

Three elemental NPCs, each occupying its own room. Room → element → boss assignment (per EQ Freelance + EQ Resource comments):

| Compass direction | Element | Boss NPC |
|---|---|---|
| North room | Fire | **Warm Heart Flickers** |
| West room | Water | **Dark Waters Sing** |
| South room | Earth | **Shadows of Stone** |

Knowing each room's element is essential, because several clues key off whether a mob is **"in its element"** (standing in the room that matches its own element) or in an unfamiliar room.

### Boss Abilities (EQ Resource — group trial canon)

**Dark Waters Sing** (Water)
- **Water Blast** — single-target direct damage + knockback.
- **Boiling Mana** — point-blank AE direct damage scaled by the target's current mana.
- Warning emote: **`Dark Waters Sing begins to drip`** (signals an incoming AE).

**Warm Heart Flickers** (Fire)
- **Flaming Defense** — self damage-shield buff.
- **Burning Embers** — point-blank AE direct damage + DoT; **incurable, lasts 4 ticks**.
- Warning emote: **`Warm Heart Flickers begins to glow and grow warmer.`** (signals the Burning Embers AE).

**Shadows of Stone** (Earth)
- **Crushing Earth** — point-blank AE direct damage + **3-second stun**.
- **Choking Dust** — melee **and** spell **silence** + DoT.
- Warning emote: **`Shadows of Stone begins to rumble.`** (signals the Crushing Earth AE).

- **Max melee hit (all three): 35,000–40,000.**
- The bosses are otherwise largely tank-and-spank, so once you correctly engage the first mob you usually have time to re-read clues for the rest of the encounter.

> EQ Freelance cross-reference (likely raid-tier values, NOT confirmed for the group trial): Warm Heart Flickers — Flaming Embers (~190k DD), Wandering Flames (~190k viral spreading DoT), warns *"I shall set your world aflame"* (run NE tunnel). Dark Waters Sing — Ocean Blast (~190k frontal DD), Steaming Mana (~140k DD + mana drain), warns *"It is about time I taught you what the deepest seas are like"* (run to E water aura). Shadows of Stone — Stone Slam (~201k DD + knockback), Crushing Stones (~190k DD + stun), Choking Sands (~129k DoT + silence), warns *"You will drink sand"* (run SE tunnel).

---

## Kill Order & The Clue System

You **hail / receive clues** from the start NPC. The riddle clues determine the **order in which you must defeat the three bosses**.

Key rule (verbatim, EQ Resource): *"You will get clues for the first and 3rd mob to defeat, the 2nd mob to defeat has no clues related to it."*

So you only need to identify the **1st** and **3rd** mob from the clues — the remaining boss is the **2nd** by elimination.

### How the clues work
Each clue line is a riddle describing **one observable attribute** of a boss, and you match that attribute to whichever of the three mobs actually exhibits it. The four attribute categories are:

1. **Mob size** — smallest / medium / largest of the three.
2. **Weapon** — smallest weapon (dagger), middle weapon (rapier), largest weapon, or weapon color (whiteish/green = greatest arms).
3. **Position in the room** — closest to the door (foremost), middle (mid-most), or back of the room (rearmost).
4. **Element / room match** — whether the mob is standing **in** its matching element room ("in its element") or not.

The community **Trial of Three decoder** (RedGuides macro) automates exactly this: it parses the clue text "based on weapon type, mob size, position in the room, etc." and **announces the resolved kill order to the group** so players can record it before engaging.

> Caution (Trax540, EQ Resource comments): *"The Mob can be anywhere in room, Not reserved to Middle."* — i.e. don't assume fixed spawn spots; read the actual positions each run.

### Achievement timing (kill-window)
Per player reports, the speed achievement requires chaining the kills: *"...you have 1 minute after killing first boss to kill second boss, and after that...another minute to kill third boss"* / *"kill the 3rd one within a minute of the first ones death."* (Reported, not officially stated on the page.)

---

## Verbatim Clue Lines → Mappings

All clue phrases below are quoted verbatim from the EQ Resource page (and corroborated by the page's `darkwater` comment), with the page's own bracketed mapping after each:

| # | Clue text (verbatim) | Maps to |
|---|---|---|
| 1 | *"least size, for it may be the largest in power"* | smallest of the three |
| 2 | *"whose great personal power is made physical"* | weapon matches mob |
| 3 | *"with no fear of appearing weak nor need to appear strong, brings with it a modest weapon"* | middle of room w/ rapier |
| 4 | *"implies great strength by displaying little"* | smallest weapon |
| 5 | *"of middling size that hides great strength"* | medium size |
| 6 | *"wielding the great power of its element"* | weapon matches mob |
| 7 | *"greatest in size"* | largest of the three |
| 8 | *"furthest from battle"* | back of its room |
| 9 | *"neither foremost nor furthest"* | middle of its room |
| 10 | *"neither largest nor tiniest"* | medium size |
| 11 | *"that brings with it the greatest of arms"* | whiteish/green weapon |
| 12 | *"that believes in moderation in war"* | middle of room w/ rapier |
| 13 | *"that stands mid-most"* | middle of its room |
| 14 | *"that stands foremost, least afraid to fight"* | closest to the door |
| 15 | *"that stands to the rear, least ready for battle"* | back of its room |
| 16 | *"that is the greatest of the three"* | biggest of the three |
| 17 | *"that is perhaps weakest in strength compensated for with a sizable weapon"* | biggest weapon |
| 18 | *"that is boldest, most ready for battle"* | closest to the door |
| 19 | *"that is in its element"* | mob matches room |
| 20 | *"that is not distracted by unfamiliar surroundings"* | mob matches room |
| 21 | *"of smallest stature, as it hides the greatest power"* | smallest of the three |
| 22 | *"that shows great elemental power by wielding the least of weapons"* | the one with the dagger |

### Quick decode key
- **Size language** ("least/smallest size", "greatest in size", "middling", "neither largest nor tiniest") → compare the three mob models' sizes.
- **Weapon language** ("modest weapon"/"moderation in war" = rapier; "least of weapons"/"displaying little" = dagger/smallest weapon; "greatest of arms"/"sizable weapon" = biggest weapon, whiteish-green) → compare visible weapons.
- **Position language** ("foremost"/"boldest"/"most ready for battle" = closest to door; "mid-most"/"neither foremost nor furthest" = middle; "to the rear"/"furthest from battle"/"least ready" = back) → compare in-room placement.
- **Element language** ("in its element", "not distracted by unfamiliar surroundings", "wielding the great power of its element", "power...made physical") → the mob standing in the room matching its own element.

---

## Entry & Reset Mechanics

- **Simultaneous entry is mandatory.** Verbatim (Jaquo Da Jester): *"if you do not ALL go into the room at the same time you will be kicked out / blinded."* The fix (Vumad): *"get everyone into the room before engage and blind wont be a problem."* Entering out of sync applies a **blind debuff with an accompanying DoT**.
- **Stay on the hailed NPC.** Verbatim: *"stay there and do not move from the hailed mob"* — remain with the NPC giving clues.
- **Leashing.** Mobs can **leash / reset if pushed to the room edges** (azzeran warned about this). Use invisibility on approach.
- **Intentional reset.** If you can't solve the riddle, you can let the mobs disengage and reset; reset happens relatively quickly.
- After a successful kill of the mobs you get a **reset message that ports you back to the entrance, but the chest remains** (Antibane).

---

## Turn-In / Completion

- **Open the chest** to complete the trial and claim rewards.

## Achievements
- **Trials of Smoke (Group)**
- **Read the Signs**
- **No Smoking**
- **Three at Once**

## Rewards
- Experience
- **212 Platinum, 5 Gold**
- Chest loot (random selection from the table below)

### Chest Loot Table
- Beak
- Blue Sky
- Dour Blue
- Glowing Spellbound Lamp
- Greater Spellbound Lamp
- Happy Stone
- Mortal Corporeal Light Zephyr
- Planetary Dagger Medallion
- Sky Hammer
- Spiked Collar of Stalactite
- Starbreaker
- Weeping Undefeated Heaven Binding Feet Muhbis
- Weeping Undefeated Heaven Binding Wrist Muhbis

> Player drop reports: greaves, boots, neck, an aug, and a level-106 spell (Antibane); a Glowing Spellbound Lamp, Weeping boots + arms, and a Happy Stone aug (Greym Greymantle).

---

## Player Comments (EQ Resource thread)

Summarized in date order; quoted text is verbatim where the page provided it.

- **Riou** (Dec 9, 2018) — original thread opener.
- **azzeran** (Dec 11, 2018) — recommended using invisibility and warned about mobs leashing at the room edges.
- **Greym Greymantle** (Dec 12, 2018) — looted a **"GLOWING SPELLBOUND LAMP"**, **"2 weeping armour items, boots and arms"**, and a **"Happy Stone aug."**
- **Riou** (Dec 12, 2018) — acknowledged adding the new loot items to the database.
- **Yraen** (Dec 12, 2018) — detailed the three mobs' abilities/casting patterns and damage (source of the ability list above).
- **Antibane** (Dec 13, 2018) — looted **"greaves and boots, the neck...the aug, and a 106 spell."**
- **Antibane** (Dec 13, 2018) — noted the **"reset message after successfully kill the mobs...ports you back to entrance, but the chest remains."**
- **Satellite** (Dec 13, 2018) — noted **"possible clues are closer or farther from center of the three rooms."**
- **Jaquo Da Jester** (Dec 14, 2018) — emphasized staying with the NPC hailing you and that **"all go into the room at the same time."**
- **darkwater** (Dec 16, 2018) — posted the comprehensive riddle-to-mob matching list (the clue table above).
- **Vumad** (Dec 17, 2018) — **"get everyone into the room before engage and blind wont be a problem."**
- **Trax540** (Jan 24, 2019) — **"The Mob can be anywhere in room, Not reserved to Middle."**
- **Fian** (Oct 2, 2019) — **"riddles depend on knowing what element a room is. North room is Fire, west room is Water, and south room is Earth."**
- **simoncrobbes** (Oct 26, 2019) — noted difficulty for boxers without multiboxing tools.
- **Riou** (Nov 8, 2019) — **"Believe it's kill the 3rd one within a minute of the first ones death."**
- **Fian** (Nov 8, 2019) — on the achievement: **"you have 1 minute after killing first boss to kill second boss, and after that...another minute to kill third boss."**
