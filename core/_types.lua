---@meta
--- doprog.core — types for the engine state machine and public facade.
--- Annotation-only.

--- Immutable-ish snapshot the engine produces each tick. The State facade hands
--- this (and convenience accessors over it) to host combat systems.
---@class doprog.EngineState
---@field directive doprog.Directive
---@field target doprog.SpawnQuery?   # set only when directive == "NEED_COMBAT"
---@field zone string                 # current zone short name
---@field questName string?           # active quest, if any
---@field stepDesc string?            # active step description
---@field reason string?              # why we are in this state (for UI/logs)
---@field complete boolean            # all progression finished

return {}
