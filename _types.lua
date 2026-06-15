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
---@field z? number # optional; if omitted, nav uses 2D `/nav loc Y X` and the mesh supplies Z
---@field heading? number # optional facing, 0-512 EQ heading units

--- A declarative description of a spawn to find/target. Resolved by MqAdapter
--- into a concrete spawn id at runtime. At least one of the fields is required.
---@class doprog.SpawnQuery
---@field name? string        # exact or partial spawn name (inclusion)
---@field id? number          # explicit spawn id (wins over everything else)
---@field npc? boolean        # restrict to NPCs
---@field radius? number      # search radius from the player, in units
---@field body? string        # body type filter (e.g. "Giant")
---@field exclude? string[]   # reject candidates whose name contains any of these (case-insensitive)
---@field scan? integer       # how many nearest candidates to consider when filtering (default 25)

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

-------------------------------------------------------------------------------
-- Combat positioning mechanics (doprog handles movement; host handles damage)
-------------------------------------------------------------------------------

--- How doprog repositions the lead in response to a fight mechanic.
---@alias doprog.MechanicReact
---| '"flee"'    # run away from `spawn` by `distance` (AE, boulder, follow-target)
---| '"moveTo"'  # nav the lead to `loc` (safe spot)
---| '"hide"'    # nav to `loc` to break line-of-sight on a gaze/rapture emote
---| '"aura"'    # nav the lead into a damaging aura / required floor spot at `loc`
---| '"drag"'    # nav the lead to `loc`, dragging the targeted mob there (braziers)

--- A single positioning rule attached to a CombatStep. If `emote` is set, the
--- reaction only fires while that emote text has been seen recently; otherwise it
--- is a standing position to hold for the whole fight. Reactions that need a
--- `loc` are no-ops until the loc is calibrated in-game; `flee` works immediately
--- because it computes an escape vector from the live spawn position.
---@class doprog.Mechanic
---@field desc string
---@field react doprog.MechanicReact
---@field emote? string                # substring of the trigger emote line
---@field window? number               # seconds the emote stays "active" (default 8)
---@field loc? doprog.Vec3             # destination for moveTo/hide/aura/drag
---@field spawn? doprog.SpawnQuery     # what to flee from (react == "flee")
---@field distance? number             # flee distance in units (default 40)

return {}
