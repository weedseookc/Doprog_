--- doprog.core.quest_registry
---
--- Holds every zone's quests in progression order and answers "what is the next
--- thing to work?". Zones are evaluated in order; the first zone that still has
--- an eligible, incomplete quest wins. This is what makes progression linear:
--- Stratos must be finished before Esianti surfaces work, etc.

local Zones = require('doprog.zones')

---@class doprog.QuestRegistry
---@field zones doprog.Zone[]
---@field private _log doprog.Logger
local QuestRegistry = {}
QuestRegistry.__index = QuestRegistry

---@class doprog.QuestRegistry.Deps
---@field logger doprog.LoggerFactory
---@field zones? doprog.Zone[]   # defaults to the bundled TBL zone list

---@param deps doprog.QuestRegistry.Deps
---@return doprog.QuestRegistry
function QuestRegistry.new(deps)
    assert(deps and deps.logger, 'QuestRegistry requires deps.logger')
    local self = setmetatable({
        zones = deps.zones or Zones,
        _log = deps.logger:forModule('Registry'),
    }, QuestRegistry)
    -- Zones/quests are module-level singletons (require-cached). Reset their step
    -- cursors on build so a fresh run (or a relaunch without reloading Lua)
    -- starts from a clean progression state rather than inheriting stale indices.
    for _, zone in ipairs(self.zones) do
        for _, quest in ipairs(zone.quests) do
            quest:reset()
        end
    end
    return self
end

--- Find the next quest to work and the zone it belongs to.
---@param ctx doprog.StepContext
---@return doprog.Quest?, doprog.Zone?
function QuestRegistry:nextActionable(ctx)
    for _, zone in ipairs(self.zones) do
        if not zone:isComplete(ctx) then
            local quest = zone:nextQuest(ctx)
            if quest then
                return quest, zone
            end
            -- Zone not complete but nothing startable yet (prereqs pending):
            -- keep scanning — a later zone won't be eligible either, but this
            -- keeps the loop honest and the log explains the stall.
            self._log:Debug('zone %s has no startable quest yet', zone.shortName)
        end
    end
    return nil, nil
end

--- True when every zone is complete.
---@param ctx doprog.StepContext
---@return boolean
function QuestRegistry:isComplete(ctx)
    for _, zone in ipairs(self.zones) do
        if not zone:isComplete(ctx) then return false end
    end
    return true
end

return QuestRegistry
