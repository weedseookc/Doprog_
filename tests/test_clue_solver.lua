--- tests.test_clue_solver — Trial of Three kill-order solver decodes the clue
--- emotes and yields the correct boss sequence.

local H = require('tests.test_helpers')
local MockMq = require('tests.mock_mq')
local LoggerFactory = require('doprog.services.logger_factory')
local MqAdapter = require('doprog.services.mq_adapter')
local ClueSolver = require('doprog.zones.plane_of_smoke.trials.clue_solver')

print('test_clue_solver')

local mq, state = MockMq.new()
local lf = LoggerFactory.new({ level = 'ERROR' })
local adapter = MqAdapter.new({ mq = mq, logger = lf })
---@type doprog.StepContext
local ctx = { mq = adapter, log = lf:forModule('Test') } ---@diagnostic disable-line: missing-fields

local solver = ClueSolver.new({
    { name = 'Dark Waters Sing', element = 'water' },
    { name = 'Warm Heart Flickers', element = 'fire' },
    { name = 'Shadows of Stone', element = 'earth' },
})

-- Three bosses, all visible. Heights: water smallest, fire medium, earth largest.
state.spawnByName = { ['Dark Waters Sing'] = 10, ['Warm Heart Flickers'] = 20, ['Shadows of Stone'] = 30 }
state.spawnHeights = { [10] = 5, [20] = 8, [30] = 12 }
state.spawnLocs = { [10] = { y = 0, x = 1 }, [20] = { y = 0, x = 2 }, [30] = { y = 0, x = 3 } }
state.me.x, state.me.y = 0, 0

-- Before any clue: unsolved -> false (caller waits, does not guess).
H.ok(solver:nextTarget(ctx) == false, 'unsolved order returns false (wait, do not guess)')

-- Trial emotes: first-kill clue "least size" (=smallest=water), third-kill clue
-- "greatest in size" (=largest=earth). Second is fire by elimination.
state.emoteQueue = {
    'A whisper: the least size, for it may be the largest in power',
    'A whisper: the greatest in size shall fall last',
}
adapter:doEvents()

local t1 = solver:nextTarget(ctx)
H.ok(t1 ~= nil and t1 ~= false and t1.name == 'Dark Waters Sing',
    'first target is the smallest (water)')

-- Kill water -> next is the elimination pick (fire).
state.spawnByName['Dark Waters Sing'] = nil
local t2 = solver:nextTarget(ctx)
H.ok(t2 ~= nil and t2.name == 'Warm Heart Flickers', 'second target is fire (by elimination)')

-- Kill fire -> next is the largest (earth).
state.spawnByName['Warm Heart Flickers'] = nil
local t3 = solver:nextTarget(ctx)
H.ok(t3 ~= nil and t3.name == 'Shadows of Stone', 'third target is the largest (earth)')

-- Kill earth -> all dead -> nil (complete).
state.spawnByName['Shadows of Stone'] = nil
H.ok(solver:nextTarget(ctx) == nil, 'all bosses dead -> nil (step completes)')
