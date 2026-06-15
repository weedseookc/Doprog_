--- doprog
---
--- Entry point + public module. doprog is "progression state within other combat
--- systems": it drives travel, targeting and safety, and exposes readable state.
--- It NEVER fights — at a kill step it advertises NEED_COMBAT with a target and
--- waits for the host combat system to clear it.
---
--- Two usage modes (the same file serves both):
---
--- 1) AS A MODULE inside a host combat loop (primary; lg-pl style):
---
---        local doprog = require('doprog')
---        doprog.init({ leader = 'Tankname' })
---        -- each frame of your combat loop:
---        doprog.tick()
---        if doprog.shouldEngage() then myCombat:assistOn(doprog.target()) end
---
--- 2) STANDALONE: `/lua run doprog`
---        Runs its own loop and shows a status window. Combat is left to whatever
---        tools you already have running; doprog just exposes state and moves the
---        party. (Detected because the script's vararg is not the module name.)

local modName = ...
local Container = require('doprog.container')

---@class doprog.Module
local M = {}

---@type doprog.App?
M._app = nil
M._running = false

--- Build the application graph (idempotent). Returns the module for chaining.
---@param opts? doprog.Container.Opts
---@return doprog.Module
function M.init(opts)
    if not M._app then
        M._app = Container.build(opts)
    end
    return M
end

---@return doprog.App
local function app()
    assert(M._app, 'doprog: call doprog.init() before use')
    return M._app
end

-------------------------------------------------------------------------------
-- Public read API (delegates to the State facade)
-------------------------------------------------------------------------------

--- Advance the engine one frame. Call once per host loop iteration.
---@return doprog.EngineState
function M.tick() return app().state:tick() end

---@return boolean
function M.shouldEngage() return app().state:shouldEngage() end

---@return doprog.SpawnQuery?
function M.target() return app().state:target() end

---@return doprog.Directive
function M.directive() return app().state:directive() end

---@return boolean
function M.isTraveling() return app().state:isTraveling() end

---@return boolean
function M.isComplete() return app().state:isComplete() end

---@return doprog.EngineState
function M.current() return app().state:current() end

--- Direct access to the State facade object, if a host prefers method calls.
---@return doprog.State
function M.state() return app().state end

function M.stop() M._running = false end

-------------------------------------------------------------------------------
-- Standalone runner
-------------------------------------------------------------------------------

--- Run doprog's own loop with a status window. Used when launched via /lua run.
---@param opts? doprog.Container.Opts
function M.run(opts)
    local mq = require('mq')
    M.init(opts)
    local a = app()
    a.logger:forModule('Main'):Info('doprog standalone runner starting')

    local StatusWindow = require('doprog.ui.status_window')
    local win = StatusWindow.new({ mq = mq, state = a.state, logger = a.logger })
    win:register()

    mq.bind('/doprog', function(arg)
        if arg == 'stop' or arg == 'quit' then
            M.stop()
        else
            local s = a.state:current()
            mq.cmdf('/echo [doprog] %s | %s | %s', s.directive, s.questName or '-', s.stepDesc or '-')
        end
    end)

    M._running = true
    while M._running do
        M.tick()
        mq.doevents()
        mq.delay(100)
    end

    win:unregister()
    a.logger:forModule('Main'):Info('doprog stopped')
end

-- If this chunk was executed (not `require`d), run the standalone loop. When
-- `require`d, Lua passes the module name as the first vararg ('doprog').
if modName ~= 'doprog' then
    M.run()
end

return M
