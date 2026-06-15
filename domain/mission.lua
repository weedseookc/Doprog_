--- doprog.domain.mission
---
--- A Mission is a Quest variant for TBL group missions: instanced content
--- requested from an NPC, with a request lockout (typically 1 hour) before a
--- different mission can be requested. Modelled as a Quest whose first action is
--- the request; the lockout is carried as metadata for the UI and for WaitSteps
--- that gate re-requests.

local Quest = require('doprog.domain.quest')

---@class doprog.Mission : doprog.Quest
---@field requestNpc doprog.SpawnQuery?
---@field requestSay string?
---@field lockoutMinutes integer
local Mission = Quest.extend({})
Mission.__index = Mission

---@param opts doprog.Mission.Opts
---@return doprog.Mission
function Mission.new(opts)
    local self = Quest.new(opts) ---@cast self doprog.Mission
    self.type = 'mission'
    self.requestNpc = opts.requestNpc
    self.requestSay = opts.requestSay
    self.lockoutMinutes = opts.lockoutMinutes or 60
    return setmetatable(self, Mission)
end

return Mission
