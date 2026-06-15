--- tests.test_travel_graph — BFS routing over the TBL zone graph.

local H = require('tests.test_helpers')
local MockMq = require('tests.mock_mq')
local LoggerFactory = require('doprog.services.logger_factory')
local MqAdapter = require('doprog.services.mq_adapter')
local NavService = require('doprog.services.nav_service')
local TravelService = require('doprog.services.travel_service')

print('test_travel_graph')

local mq = MockMq.new()
local logger = LoggerFactory.new({ level = 'ERROR' })
local adapter = MqAdapter.new({ mq = mq, logger = logger })
local nav = NavService.new({ mq = adapter, logger = logger })
local travel = TravelService.new({ mq = adapter, nav = nav, logger = logger })

local same = travel:_findPath('stratos', 'stratos')
H.ok(same ~= nil and #same == 0, 'same-zone path is empty')

local toEsianti = travel:_findPath('stratos', 'esianti')
H.ok(toEsianti ~= nil and #toEsianti >= 1, 'stratos -> esianti route exists')

local toMearatas = travel:_findPath('stratos', 'mearatas')
H.ok(toMearatas ~= nil, 'stratos -> mearatas route exists (multi-hop)')
if toMearatas then
    H.eq(toMearatas[#toMearatas].to, 'mearatas', 'last hop lands in mearatas')
end

local nowhere = travel:_findPath('stratos', 'no_such_zone')
H.ok(nowhere == nil, 'unknown destination yields no route')

-- toZone short-circuits when already in the target zone.
mq._state.zone = 'empyr'
H.ok(travel:toZone('empyr') == true, 'toZone true when already in target zone')
