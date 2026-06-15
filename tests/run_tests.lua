--- tests.run_tests — headless test entrypoint.
---
--- Run from the repo root:   lua5.4 tests/run_tests.lua
---
--- The framework's modules are namespaced under `doprog.*` (which resolves to
--- this repo when deployed at MQ's `lua/doprog`). For headless testing we add a
--- package searcher that maps `doprog.x.y` -> `<root>/x/y.lua`, and preload a
--- mock `mq` so the vendored logger (which requires 'mq' at load) is satisfied.

local arg0 = (arg and arg[0]) or 'tests/run_tests.lua'
local root = arg0:match('^(.*)/tests/run_tests%.lua$') or '.'

package.path = root .. '/?.lua;' .. root .. '/?/init.lua;' .. package.path

table.insert(package.searchers, 1, function(name)
    local rel
    if name == 'doprog' then
        rel = 'init'
    else
        rel = name:match('^doprog%.(.+)$')
    end
    if not rel then return nil end
    local base = root .. '/' .. rel:gsub('%.', '/')
    for _, p in ipairs({ base .. '.lua', base .. '/init.lua' }) do
        local f = io.open(p, 'r')
        if f then
            f:close()
            return assert(loadfile(p))
        end
    end
    return '\n\tno doprog module file for ' .. name
end)

-- Satisfy `require('mq')` made by vendored code at load time.
package.loaded['mq'] = (require('tests.mock_mq').new())

local H = require('tests.test_helpers')

require('tests.test_travel_graph')
require('tests.test_engine')
require('tests.test_safety')
require('tests.test_config')

os.exit(H.report() and 0 or 1)
