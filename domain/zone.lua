--- doprog.domain.zone
---
--- Groups a zone's quests/missions in intended completion order and answers
--- "what should we work next here?". A zone is complete when all its quests are.

---@class doprog.Zone
---@field shortName string
---@field displayName string
---@field quests doprog.Quest[]
local Zone = {}
Zone.__index = Zone

---@param opts doprog.Zone.Opts
---@return doprog.Zone
function Zone.new(opts)
    assert(opts and opts.shortName and opts.quests, 'Zone requires shortName and quests')
    return setmetatable({
        shortName = opts.shortName,
        displayName = opts.displayName or opts.shortName,
        quests = opts.quests,
    }, Zone)
end

--- The next quest to work: first one that is not complete and may start.
---@param ctx doprog.StepContext
---@return doprog.Quest?
function Zone:nextQuest(ctx)
    for _, quest in ipairs(self.quests) do
        if not quest:isComplete(ctx) and quest:canStart(ctx) then
            return quest
        end
    end
    return nil
end

---@param ctx doprog.StepContext
---@return boolean
function Zone:isComplete(ctx)
    for _, quest in ipairs(self.quests) do
        if not quest:isComplete(ctx) then return false end
    end
    return true
end

return Zone
