---@meta
--- doprog.data — types for static data tables (zone graph). Annotation-only.

--- One directed connection between two zones.
---@class doprog.ZoneEdge
---@field to string                 # destination zone short name
---@field kind 'zoneline'|'portal'  # zoneline = walk into it; portal = run an action
---@field loc? doprog.Vec3          # where to stand (zone line, or the clicky/NPC)
---@field action? string            # slash command to trigger a portal (kind=='portal')
---@field note? string              # human note (progression gate, etc.)

--- Adjacency list keyed by source zone short name.
---@class doprog.ZoneGraph
---@field edges table<string, doprog.ZoneEdge[]>

return {}
