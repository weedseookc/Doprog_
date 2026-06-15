---@meta
--- doprog.steps — types for the Step hierarchy and the runtime context steps
--- receive. Annotation-only.

--- Services injected into every Step at execution time. This is the
--- dependency-injection seam for the domain layer: steps never `require` a
--- service, they only ever touch what the engine hands them here.
---@class doprog.StepContext
---@field mq doprog.MqAdapter
---@field nav doprog.NavService
---@field travel doprog.TravelService
---@field safety doprog.SafetyService
---@field eqbc doprog.EqbcService
---@field task doprog.TaskService
---@field mech doprog.MechanicsWatcher
---@field log doprog.Logger

--- Common option bag accepted by Step constructors. Subclasses narrow this.
---@class doprog.Step.Opts
---@field desc? string                 # human-readable description for UI/logs
---@field zone? string                 # zone the step expects to run in
---@field loc? doprog.Vec3             # destination / interaction point
---@field npc? doprog.SpawnQuery       # giver / hand-in / interaction target
---@field taskName? string             # task this step relates to
---@field objective? integer           # objective index used for completion
---@field target? doprog.SpawnQuery    # combat target (combat steps)
---@field item? string                 # item name (loot/handin steps)
---@field count? integer               # required count (loot steps)
---@field condition? fun(ctx: doprog.StepContext): boolean  # wait-step predicate
---@field action? string               # raw slash command (click steps)
---@field request? string              # offer/keyword phrase said to acquire a task (pickup)
---@field completeAfter? integer       # ms after firing to consider a click done (porter says)
---@field engageRange? integer         # combat: within this range we hand off, beyond it we close in
---@field untilItem? string            # combat: keep farming until this many of an item are held
---@field untilCount? integer          # combat: count for untilItem (default 1)
---@field mechanics? doprog.Mechanic[] # combat: positioning rules doprog executes during the fight

return {}
