--- tests.test_helpers
---
--- Minimal assertion helpers + a builder that assembles a doprog App against the
--- mock mq, so engine/step tests can drive the real wiring without EverQuest.

local MockMq = require('tests.mock_mq')
local Container = require('doprog.container')

local H = { passed = 0, failed = 0, failures = {} }

---@param cond any
---@param msg string
function H.ok(cond, msg)
    if cond then
        H.passed = H.passed + 1
    else
        H.failed = H.failed + 1
        H.failures[#H.failures + 1] = msg
        print('  FAIL: ' .. msg)
    end
end

---@param a any
---@param b any
---@param msg string
function H.eq(a, b, msg)
    H.ok(a == b, string.format('%s (expected %s, got %s)', msg, tostring(b), tostring(a)))
end

--- Build an App + return the control state so tests can manipulate the world.
---@param opts? table
---@return doprog.App app, table state
function H.app(opts)
    local mq, state = MockMq.new()
    opts = opts or {}
    opts.mq = mq
    opts.configPath = '/tmp/doprog_test.lua'
    opts.level = opts.level or 'ERROR'
    local app = Container.build(opts)
    return app, state
end

---@return boolean
function H.report()
    print(string.format('\n%d passed, %d failed', H.passed, H.failed))
    return H.failed == 0
end

--- True if any recorded command contains `substr`.
---@param mqCommands string[]
---@param substr string
---@return boolean
function H.commandSeen(mqCommands, substr)
    for _, c in ipairs(mqCommands) do
        if c:find(substr, 1, true) then return true end
    end
    return false
end

return H
