---@meta
--- doprog — root shared type vocabulary.
---
--- This file is annotation-only. It declares the cross-cutting aliases and
--- classes that the rest of the framework references. It defines NO runtime
--- behaviour and returns an empty table so it can be `require`d harmlessly.
---
--- Naming convention: every public type is namespaced under `doprog.`.

-------------------------------------------------------------------------------
-- Geometry / spawn addressing
-------------------------------------------------------------------------------

--- An EQ world location. EQ uses Y/X/Z ordering in several places; we always
--- store explicit named fields to avoid ambiguity.
---@class doprog.Vec3
---@field y number
---@field x number
---@field z number
---@field heading? number # optional facing, 0-512 EQ heading units

--- A declarative description of a spawn to find/target. Resolved by MqAdapter
--- into a concrete spawn id at runtime. At least one of the fields is required.
---@class doprog.SpawnQuery
---@field name? string        # exact or partial spawn name
---@field id? number          # explicit spawn id (wins over everything else)
---@field npc? boolean        # restrict to NPCs
---@field radius? number      # search radius from the player, in units
---@field body? string        # body type filter (e.g. "Giant")

-------------------------------------------------------------------------------
-- Engine state vocabulary
-------------------------------------------------------------------------------

--- What the engine currently wants to happen this frame. Combat systems read
--- this (via the State facade) to decide whether to act.
---@alias doprog.Directive
---| '"IDLE"'          # nothing to do (progression complete or paused)
---| '"TRAVEL"'        # moving toward an objective; do not engage
---| '"PICKUP"'        # acquiring a task from a giver NPC
---| '"TURN_IN"'       # handing in items / completing at an NPC
---| '"NEED_COMBAT"'   # a kill is required; host combat system should engage `target`
---| '"LOOT"'          # looting a required drop
---| '"WAIT"'          # blocked on a condition (lockout, crew sync, rez, ...)

--- The discriminator for a concrete Step subclass.
---@alias doprog.StepKind
---| '"travel"'
---| '"pickup"'
---| '"handin"'
---| '"combat"'
---| '"loot"'
---| '"click"'
---| '"wait"'

--- Outcome of a single `Step:execute` / `Step:isComplete` evaluation.
---@alias doprog.StepStatus
---| '"running"'   # step is in progress, call again next tick
---| '"done"'      # step finished successfully, advance
---| '"blocked"'   # cannot proceed right now (returns a directive + reason)
---| '"failed"'    # unrecoverable for this step

--- Value returned by a Step each tick so the engine can drive the state machine.
---@class doprog.StepResult
---@field status doprog.StepStatus
---@field directive doprog.Directive   # what the engine should advertise while here
---@field target? doprog.SpawnQuery    # set when directive == "NEED_COMBAT"
---@field reason? string               # human-readable note for logging/UI

-------------------------------------------------------------------------------
-- Task line classification (matches TBL progression structure)
-------------------------------------------------------------------------------

---@alias doprog.QuestType
---| '"partisan"'
---| '"mercenary"'
---| '"mission"'
---| '"task"'

return {}
