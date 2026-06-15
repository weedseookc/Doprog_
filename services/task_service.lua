--- doprog.services.task_service
---
--- Reads EQ task state through the MqAdapter. This is how doprog knows a quest
--- step is actually complete in-game (objective ticked over) rather than just
--- "we ran the command". Combat steps in particular complete when the task
--- objective advances, not when a specific mob dies.
---
--- The exact Task TLO objective member names vary across MQ builds; all access
--- is funnelled through `MqAdapter:taskObjectiveStatus`, so any adjustment is a
--- one-line change there rather than scattered through the codebase.

---@class doprog.TaskService : doprog.ITaskService
---@field private _mq doprog.MqAdapter
---@field private _log doprog.Logger
local TaskService = {}
TaskService.__index = TaskService

---@class doprog.TaskService.Deps
---@field mq doprog.MqAdapter
---@field logger doprog.LoggerFactory

---@param deps doprog.TaskService.Deps
---@return doprog.TaskService
function TaskService.new(deps)
    assert(deps and deps.mq, 'TaskService requires deps.mq')
    return setmetatable({
        _mq = deps.mq,
        _log = deps.logger:forModule('Task'),
    }, TaskService)
end

--- True if the character currently holds the task.
---@param taskName string
---@return boolean
function TaskService:has(taskName)
    return self._mq:taskExists(taskName)
end

--- True if objective `index` (1-based) of `taskName` reads as "Done".
---@param taskName string
---@param index integer
---@return boolean
function TaskService:objectiveDone(taskName, index)
    local status = self._mq:taskObjectiveStatus(taskName, index)
    return status ~= nil and status:lower() == 'done'
end

--- True if every objective of the task is done. We probe objectives in order and
--- stop at the first nil status (past the end of the list).
---@param taskName string
---@return boolean
function TaskService:isComplete(taskName)
    if not self:has(taskName) then
        return false
    end
    local index = 1
    while true do
        local status = self._mq:taskObjectiveStatus(taskName, index)
        if status == nil then
            -- No more objectives; complete iff we saw at least one and none open.
            return index > 1
        end
        if status:lower() ~= 'done' then
            return false
        end
        index = index + 1
    end
end

return TaskService
