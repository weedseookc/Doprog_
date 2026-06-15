--- tests.test_portal_solver — Wending Ways "most portals first" order solver.

local H = require('tests.test_helpers')
local MockMq = require('tests.mock_mq')
local LoggerFactory = require('doprog.services.logger_factory')
local MqAdapter = require('doprog.services.mq_adapter')
local PortalSolver = require('doprog.zones.plane_of_smoke.trials.portal_solver')

print('test_portal_solver')

local mq, state = MockMq.new()
local lf = LoggerFactory.new({ level = 'ERROR' })
local adapter = MqAdapter.new({ mq = mq, logger = lf })
---@type doprog.StepContext
local ctx = { mq = adapter, log = lf:forModule('Test') } ---@diagnostic disable-line: missing-fields

local solver = PortalSolver.new({
    { name = 'Blazing Triumphant Bulwark', element = 'fire' },
    { name = 'Obsidian Undefeated Shield', element = 'earth' },
    { name = 'Flowing Unconquered Guard', element = 'water' },
    { name = 'Blustering Stalwart Screen', element = 'wind' },
})

state.spawnByName = {
    ['Blazing Triumphant Bulwark'] = 1, ['Obsidian Undefeated Shield'] = 2,
    ['Flowing Unconquered Guard'] = 3, ['Blustering Stalwart Screen'] = 4,
}
-- Earth has the most portals -> fight earth first.
state.spawnCounts = { ['fire portal'] = 1, ['earth portal'] = 3, ['water portal'] = 2, ['wind portal'] = 0 }

local t1 = solver:nextTarget(ctx)
H.ok(t1 ~= nil and t1 ~= false and t1.name == 'Obsidian Undefeated Shield', 'most portals (earth) is first')

-- Kill earth; recount leaves water highest among the living.
state.spawnByName['Obsidian Undefeated Shield'] = nil
local t2 = solver:nextTarget(ctx)
H.ok(t2 ~= nil and t2.name == 'Flowing Unconquered Guard', 'water is next (most portals among living)')

-- Ambiguous: two left, no portals readable -> wait, don't guess.
state.spawnByName['Flowing Unconquered Guard'] = nil
state.spawnCounts = {}
H.ok(solver:nextTarget(ctx) == false, 'ambiguous order (no portals, 2 alive) -> false (wait)')

-- One left -> just take it.
state.spawnByName['Blustering Stalwart Screen'] = nil
state.spawnByName['Blazing Triumphant Bulwark'] = 1
H.ok(solver:nextTarget(ctx).name == 'Blazing Triumphant Bulwark', 'last boss alive -> target it')
