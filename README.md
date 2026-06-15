# doprog — The Burning Lands progression framework

doprog is a MacroQuest **Lua** framework that drives a group through **The Burning
Lands (TBL)** group progression. It owns **travel, targeting, and staying alive
while moving** — and exposes everything else as **readable state**.

**doprog never fights.** It is "progression state within other combat systems"
(lg-pl style): at a kill step it advertises `NEED_COMBAT` with (optionally) a
target and waits for the task objective to tick over. Your combat system —
RGMercs, KissAssist, MuleAssist, or your own — reads that state and does the
killing. doprog handles the part around the fight: which task to grab, where to
go, when it's safe, and keeping the crew together.

- **Scope:** group progression (Partisan + Mercenary tasks + group Missions)
  across all 8 TBL zones, Stratos → Mearatas, plus Doomfire / Chamber of Tears.
- **Crew:** lead drives, crew follows, **EQBC only** (no DanNet, no actors).
- **Movement:** MQ2Nav for in-zone, a zone-connection graph for inter-zone.

## Requirements

- MacroQuest with the Lua core, **MQ2Nav** (with meshes for the TBL zones), and
  **MQ2EQBC** (crew connected via `/bccmd connect`).
- A combat automation tool of your choice (doprog does not provide combat).

## Install

Clone into your MacroQuest `lua` folder **as `doprog`** (the module namespace
depends on the folder name):

```
MacroQuest/lua/doprog/      <- this repo
```

The repo bundles its dependencies: the `lwlogger` logger (`lib/lwlogger`) and the
LuaLS type definitions for `mq` (`.meta/mq-definitions`, a git submodule — run
`git submodule update --init` after cloning).

## Usage

### 1) As state inside your combat loop (primary)

```lua
local doprog = require('doprog')
doprog.init({ leader = 'Tankname' })   -- builds the application graph

-- ...inside your existing combat loop, once per frame:
doprog.tick()
if doprog.shouldEngage() then
    myCombat:assistOn(doprog.target())  -- target() may be nil for area objectives
end
```

Read API (all reflect the latest `tick()`):

| Call | Meaning |
| --- | --- |
| `doprog.tick()` | advance one frame, returns the state snapshot |
| `doprog.directive()` | `TRAVEL` / `PICKUP` / `TURN_IN` / `NEED_COMBAT` / `LOOT` / `WAIT` / `IDLE` |
| `doprog.shouldEngage()` | true when the host should be fighting |
| `doprog.target()` | spawn to kill, or `nil` for area/objective kills (host picks) |
| `doprog.isTraveling()` | true while moving between objectives/zones |
| `doprog.isComplete()` | true when all configured progression is done |
| `doprog.current()` | full snapshot `{ directive, zone, questName, stepDesc, reason, ... }` |

### 2) Standalone

```
/lua run doprog
```

Runs doprog's own loop with a status window. Combat is left to whatever you
already have running. `/doprog` prints status; `/doprog stop` exits.

## Architecture

OOP with dependency injection; one composition root (`container.lua`) wires
everything. Nothing reaches for a global — services are injected, which is why
the whole thing is unit-testable against a mock `mq`.

```
init.lua          entry + public module (dual-mode: require vs /lua run)
container.lua     composition root (builds & injects every service)
core/             engine (directive state machine), quest_registry, state facade
services/         mq_adapter, nav, travel, safety, eqbc, task, config, logger_factory
steps/            Step base + travel/pickup/handin/combat/loot/click/wait + DSL
domain/           Quest, Mission (extends Quest), Zone
data/zones.lua    inter-zone connection graph
zones/<zone>/     folder per zone, file per quest (Plane of Smoke trials in trials/)
ui/               optional ImGui status window
lib/lwlogger/     vendored logger (all logging goes through it)
tests/            mock mq + headless unit tests
tools/gen_quests.lua  regenerates zone files from the giver data table
```

Every folder has a `_types.lua` holding its LuaLS `---@class` / `---@alias`
declarations; everything is fully typed and clean under `luacheck`.

### How a quest is modelled

A `Quest` is an ordered list of `Step`s. Steps are polymorphic
(`pickup → combat → handin` is the common shape) and receive their services via
an injected `StepContext`. Combat is **objective-driven**: because TBL objectives
are usually "defeat N of `<faction>` in `<area>`", a CombatStep advertises
`NEED_COMBAT` and watches the task objective counter rather than naming mobs.
Givers that live in another zone (several partisan/mission givers are in Stratos
or Esianti) are handled per-step, so pickup/hand-in navigate to the giver's zone
while combat happens in the objective zone.

## Quest data

All 46 TBL quests/missions are encoded by hand from their individual
tbl.eqresource.com pages — real giver NPCs, request phrases, objective counts
and indices, named mobs, item turn-ins, say-phrase puzzles, porter hops, and
mission request/zone-in phrases. Each quest file cites its source page and the
mechanics in its header comment. To pick a different Trial of Smoke, change the
`require` in `zones/plane_of_smoke/index.lua`.

`tools/gen_quests.lua` is the original scaffold generator (givers only); the
shipped quest files have since been hand-authored with full mechanics, so edit
the `zones/**/*.lua` files directly. Anything still needing an in-game read is
tracked in `DATA.md`.

## Field calibration

A small set of values genuinely need an in-game read (exact `/loc`s, portal
mechanics, a couple of unconfirmed NPC names). They are listed in **DATA.md**.
The framework runs and routes without them, navigating to NPCs/targets by spawn
name; filling them in sharpens inter-zone travel.

## Development

```
lua5.4 tests/run_tests.lua     # headless tests (mock mq), no EQ needed
luacheck core services steps domain data zones ui tests container.lua init.lua _types.lua
```
