--- doprog.ui.status_window
---
--- Optional ImGui readout of the engine state: current zone, quest, step and
--- directive, plus a pause toggle. Purely diagnostic — the engine runs fine
--- headless. Registered with `mq.imgui.init` by the standalone runner.

---@class doprog.StatusWindow
---@field private _mq table              # raw mq (for imgui registration)
---@field private _state doprog.State
---@field private _log doprog.Logger
---@field private _open boolean
---@field private _name string
local StatusWindow = {}
StatusWindow.__index = StatusWindow

---@class doprog.StatusWindow.Deps
---@field mq table
---@field state doprog.State
---@field logger doprog.LoggerFactory
---@field name? string

---@param deps doprog.StatusWindow.Deps
---@return doprog.StatusWindow
function StatusWindow.new(deps)
    assert(deps and deps.mq and deps.state, 'StatusWindow requires deps.mq and deps.state')
    return setmetatable({
        _mq = deps.mq,
        _state = deps.state,
        _log = deps.logger:forModule('UI'),
        _open = true,
        _name = deps.name or 'doprog',
    }, StatusWindow)
end

--- Register the ImGui callback. Safe to skip if ImGui is unavailable.
function StatusWindow:register()
    local ok = pcall(function()
        self._mq.imgui.init(self._name, function() self:_draw() end)
    end)
    if not ok then
        self._log:Warn('ImGui unavailable; status window disabled')
    end
end

function StatusWindow:unregister()
    pcall(function() self._mq.imgui.destroy(self._name) end)
end

---@private
function StatusWindow:_draw()
    local ImGui = _G.ImGui
    if not ImGui then return end
    local open, show = ImGui.Begin('doprog', self._open)
    self._open = open
    if show then
        local s = self._state:current()
        ImGui.Text('Directive: ' .. tostring(s.directive))
        ImGui.Text('Zone:      ' .. tostring(s.zone))
        ImGui.Text('Quest:     ' .. tostring(s.questName or '-'))
        ImGui.Text('Step:      ' .. tostring(s.stepDesc or '-'))
        ImGui.Text('Reason:    ' .. tostring(s.reason or '-'))
        if s.target then
            ImGui.Separator()
            ImGui.Text('Combat target: ' .. tostring(s.target.name or s.target.id))
        end
        if s.complete then
            ImGui.Separator()
            ImGui.Text('Progression COMPLETE')
        end
    end
    ImGui.End()
end

return StatusWindow
