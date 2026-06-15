--- tests.test_mechanics — doprog executes combat positioning (flee an AE/boulder)
--- while still handing damage off to the host.

local H = require('tests.test_helpers')
local MockMq = require('tests.mock_mq')
local LoggerFactory = require('doprog.services.logger_factory')
local MqAdapter = require('doprog.services.mq_adapter')
local NavService = require('doprog.services.nav_service')
local EqbcService = require('doprog.services.eqbc_service')
local TaskService = require('doprog.services.task_service')
local MechanicsWatcher = require('doprog.services.mechanics_watcher')
local S = require('doprog.steps')

print('test_mechanics')

local mq, state = MockMq.new()
local lf = LoggerFactory.new({ level = 'ERROR' })
local adapter = MqAdapter.new({ mq = mq, logger = lf })
---@type doprog.StepContext
local ctx = {
    mq = adapter,
    nav = NavService.new({ mq = adapter, logger = lf }),
    travel = nil, ---@diagnostic disable-line: assign-type-mismatch
    safety = nil, ---@diagnostic disable-line: assign-type-mismatch
    eqbc = EqbcService.new({ mq = adapter, logger = lf }),
    task = TaskService.new({ mq = adapter, logger = lf }),
    mech = MechanicsWatcher.new({ mq = adapter, logger = lf }),
    log = lf:forModule('Test'),
}

-- A boss fight with a "run the boulder away" flee mechanic on an emote.
local step = S.combat({
    taskName = 'Relic Raider', objective = 1,
    target = { name = 'Iron Heart', npc = true },
    mechanics = { { react = 'flee', emote = 'boulder', desc = 'run the boulder away' } },
})

-- World: task open; Iron Heart is target id 100, in range, 10 units East of us.
state.tasks['Relic Raider'] = { objectives = { 'Open' } }
state.spawnId = 100
state.targetId = 100
state.spawnNames[100] = 'Iron Heart'
state.spawnDist[100] = 10
state.spawnLocs[100] = { y = 0, x = 10, z = 0 }
state.me.x, state.me.y, state.me.z = 0, 0, 0

-- Frame 1: hand off, no emote yet -> no flee movement.
local r1 = step:execute(ctx)
H.eq(r1.directive, 'NEED_COMBAT', 'hands off to host with a valid in-range target')
H.ok(not H.commandSeen(state.commands, '/nav loc'), 'no positioning movement before the emote')

-- Boulder emote fires; deliver it, then run another frame.
state.emoteQueue = { 'Iron Heart hurls a boulder toward you' }
ctx.mech:poll()
local r2 = step:execute(ctx)
H.eq(r2.directive, 'NEED_COMBAT', 'still handed off while doprog repositions')
-- Flee away from the boss (East at x=10) => move West to x=-40; nav loc is "Y X".
H.ok(H.commandSeen(state.commands, '/nav loc 0.00 -40.00'), 'doprog flees the boulder (escape vector away from boss)')
