---@meta
--- doprog.services — interface types for the injectable service layer.
---
--- Annotation-only. Concrete classes live in the sibling files and declare
--- `---@class X : doprog.IThing` so the composition root can depend on the
--- interfaces rather than the implementations (dependency inversion).

-------------------------------------------------------------------------------
-- Logging
-------------------------------------------------------------------------------

--- A module-bound logger handed to every class. Wraps the singleton lwlogger
--- so each owner can log under its own module name without global coordination.
---@class doprog.Logger
---@field Trace fun(self: doprog.Logger, fmt: string, ...: any)
---@field Debug fun(self: doprog.Logger, fmt: string, ...: any)
---@field Info  fun(self: doprog.Logger, fmt: string, ...: any)
---@field Warn  fun(self: doprog.Logger, fmt: string, ...: any)
---@field Error fun(self: doprog.Logger, fmt: string, ...: any)
---@field Fatal fun(self: doprog.Logger, fmt: string, ...: any)

---@class doprog.LoggerFactory
---@field forModule fun(self: doprog.LoggerFactory, moduleName: string): doprog.Logger

-------------------------------------------------------------------------------
-- MQ adapter (thin seam over the real `mq`, swappable for a mock in tests)
-------------------------------------------------------------------------------

---@class doprog.IMqAdapter
---@field cmd fun(self: doprog.IMqAdapter, command: string)
---@field cmdf fun(self: doprog.IMqAdapter, fmt: string, ...: any)
---@field delay fun(self: doprog.IMqAdapter, ms: integer|string, condition?: fun(): boolean)
---@field zoneShortName fun(self: doprog.IMqAdapter): string
---@field inGame fun(self: doprog.IMqAdapter): boolean
---@field myName fun(self: doprog.IMqAdapter): string
---@field isMoving fun(self: doprog.IMqAdapter): boolean
---@field inCombat fun(self: doprog.IMqAdapter): boolean
---@field pctHps fun(self: doprog.IMqAdapter): number
---@field isDead fun(self: doprog.IMqAdapter): boolean
---@field xtargets fun(self: doprog.IMqAdapter): integer
---@field loc fun(self: doprog.IMqAdapter): doprog.Vec3
---@field findSpawn fun(self: doprog.IMqAdapter, query: doprog.SpawnQuery): integer? # spawn id or nil
---@field findSpawnFiltered fun(self: doprog.IMqAdapter, query: doprog.SpawnQuery): integer?, string?
---@field spawnDistance fun(self: doprog.IMqAdapter, id: integer): number
---@field spawnHeight fun(self: doprog.IMqAdapter, id: integer): number
---@field spawnCount fun(self: doprog.IMqAdapter, search: string): integer
---@field spawnLoc fun(self: doprog.IMqAdapter, id: integer): doprog.Vec3
---@field target fun(self: doprog.IMqAdapter, id: integer)
---@field targetId fun(self: doprog.IMqAdapter): integer
---@field registerEvent fun(self: doprog.IMqAdapter, name: string, pattern: string, cb: fun(line: string, ...: any))
---@field doEvents fun(self: doprog.IMqAdapter)
---@field navActive fun(self: doprog.IMqAdapter): boolean
---@field navPathExists fun(self: doprog.IMqAdapter, query: doprog.SpawnQuery|doprog.Vec3): boolean
---@field taskExists fun(self: doprog.IMqAdapter, taskName: string): boolean
---@field taskObjectiveStatus fun(self: doprog.IMqAdapter, taskName: string, index: integer): string?
---@field pluginLoaded fun(self: doprog.IMqAdapter, pluginName: string): boolean
---@field itemCount fun(self: doprog.IMqAdapter, itemName: string): integer
---@field navTo fun(self: doprog.IMqAdapter, dest: doprog.Vec3|doprog.SpawnQuery)

-------------------------------------------------------------------------------
-- Movement & travel
-------------------------------------------------------------------------------

---@class doprog.INavService
--- `to` begins/continues nav toward dest and returns true once arrived.
---@field to fun(self: doprog.INavService, dest: doprog.Vec3|doprog.SpawnQuery): boolean
---@field stop fun(self: doprog.INavService)
---@field isActive fun(self: doprog.INavService): boolean
---@field reset fun(self: doprog.INavService) # clear stuck-tracking bookkeeping

---@class doprog.ITravelService
--- Drives inter-zone movement across the zone graph. Returns true once the
--- player is standing in `targetZone`.
---@field toZone fun(self: doprog.ITravelService, targetZone: string): boolean
---@field reset fun(self: doprog.ITravelService)

-------------------------------------------------------------------------------
-- Safety & crew
-------------------------------------------------------------------------------

--- Reasons travel/progression can be gated by SafetyService.
---@alias doprog.SafetyGate
---| '"clear"'          # safe to proceed
---| '"in_combat"'      # we (or crew) are fighting; hold movement
---| '"recovering"'     # death recovery / waiting on rez
---| '"crew_zoning"'    # crew not all in zone yet
---| '"crew_hurt"'      # a crew member is low / down

---@class doprog.ISafetyService
---@field assess fun(self: doprog.ISafetyService): doprog.SafetyGate
---@field isSafe fun(self: doprog.ISafetyService): boolean
---@field handleRecovery fun(self: doprog.ISafetyService): boolean # true when recovery complete / not needed

---@class doprog.IEqbcService
---@field broadcast fun(self: doprog.IEqbcService, command: string)
---@field followLead fun(self: doprog.IEqbcService)
---@field holdCrew fun(self: doprog.IEqbcService)
---@field allInZone fun(self: doprog.IEqbcService, zoneShortName: string): boolean
---@field announce fun(self: doprog.IEqbcService, fmt: string, ...: any)

-------------------------------------------------------------------------------
-- Task / config
-------------------------------------------------------------------------------

--- Emote watcher used for combat positioning: arms MQ text events and reports
--- whether a given emote substring fired recently.
---@class doprog.IMechanicsWatcher
---@field arm fun(self: doprog.IMechanicsWatcher, emoteSubstring: string)
---@field firedWithin fun(self: doprog.IMechanicsWatcher, emoteSubstring: string, seconds: number): boolean
---@field poll fun(self: doprog.IMechanicsWatcher)

---@class doprog.ITaskService
---@field has fun(self: doprog.ITaskService, taskName: string): boolean
---@field objectiveDone fun(self: doprog.ITaskService, taskName: string, index: integer): boolean
---@field isComplete fun(self: doprog.ITaskService, taskName: string): boolean

---@class doprog.IConfigService
---@field get fun(self: doprog.IConfigService, key: string, default: any): any
---@field set fun(self: doprog.IConfigService, key: string, value: any)
---@field save fun(self: doprog.IConfigService)
---@field load fun(self: doprog.IConfigService)

return {}
