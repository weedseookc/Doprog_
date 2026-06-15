--- tests.test_config — ConfigService round-trips settings to disk.

local H = require('tests.test_helpers')
local LoggerFactory = require('doprog.services.logger_factory')
local ConfigService = require('doprog.services.config_service')

print('test_config')

local path = '/tmp/doprog_cfg_test.lua'
os.remove(path)

local logger = LoggerFactory.new({ level = 'ERROR' })
local cfg = ConfigService.new({ logger = logger, path = path, defaults = { leader = 'Tank' } })

H.eq(cfg:get('leader', nil), 'Tank', 'default applied')
H.eq(cfg:get('missing', 'fallback'), 'fallback', 'missing key returns fallback')

cfg:set('leader', 'Healer')
cfg:set('lowHp', 40)
cfg:save()

local cfg2 = ConfigService.new({ logger = logger, path = path })
cfg2:load()
H.eq(cfg2:get('leader', nil), 'Healer', 'saved string round-trips')
H.eq(cfg2:get('lowHp', nil), 40, 'saved number round-trips')

os.remove(path)
