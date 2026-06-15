--- doprog.container
---
--- The composition root. This is the ONE place that constructs services and
--- wires their dependencies together. Everything else receives what it needs via
--- its constructor `deps` — nothing reaches out to build its own collaborators.
--- That keeps the dependency graph explicit here and the rest of the code unit-
--- testable (the tests build a container-shaped object with a mock mq).

local LoggerFactory = require('doprog.services.logger_factory')
local MqAdapter = require('doprog.services.mq_adapter')
local NavService = require('doprog.services.nav_service')
local TravelService = require('doprog.services.travel_service')
local EqbcService = require('doprog.services.eqbc_service')
local SafetyService = require('doprog.services.safety_service')
local TaskService = require('doprog.services.task_service')
local MechanicsWatcher = require('doprog.services.mechanics_watcher')
local ConfigService = require('doprog.services.config_service')
local QuestRegistry = require('doprog.core.quest_registry')
local Engine = require('doprog.core.engine')
local State = require('doprog.core.state')

---@class doprog.App
---@field state doprog.State
---@field engine doprog.Engine
---@field config doprog.ConfigService
---@field logger doprog.LoggerFactory
---@field mq doprog.MqAdapter
local App = {}
App.__index = App

local Container = {}

---@class doprog.Container.Opts
---@field mq? table                 # injected mq (defaults to require('mq'))
---@field leader? string            # crew leader name (defaults to current char)
---@field level? lwlogger.Level|string
---@field configPath? string
---@field lowHpPct? number
---@field arrivalRadius? number

--- Build the fully-wired application graph.
---@param opts? doprog.Container.Opts
---@return doprog.App
function Container.build(opts)
    opts = opts or {}
    local mq = opts.mq or require('mq')

    local logger = LoggerFactory.new({ level = opts.level })
    local boot = logger:forModule('Container')
    boot:Info('building doprog application graph')

    local mqAdapter = MqAdapter.new({ mq = mq, logger = logger })

    -- Soft dependency check: warn (don't crash) if movement plugins are absent.
    if not mqAdapter:pluginLoaded('MQ2Nav') then
        boot:Warn('MQ2Nav not loaded — navigation will not function')
    end
    if not mqAdapter:pluginLoaded('MQ2EQBC') then
        boot:Warn('MQ2EQBC not loaded — crew coordination disabled')
    end

    local nav = NavService.new({ mq = mqAdapter, logger = logger, arrivalRadius = opts.arrivalRadius })
    local travel = TravelService.new({ mq = mqAdapter, nav = nav, logger = logger })
    local eqbc = EqbcService.new({ mq = mqAdapter, logger = logger, leader = opts.leader })
    local safety = SafetyService.new({ mq = mqAdapter, eqbc = eqbc, logger = logger, lowHpPct = opts.lowHpPct })
    local task = TaskService.new({ mq = mqAdapter, logger = logger })
    local mech = MechanicsWatcher.new({ mq = mqAdapter, logger = logger })

    local configPath = opts.configPath or ((mq.configDir or '.') .. '/doprog.lua')
    local config = ConfigService.new({ logger = logger, path = configPath })
    config:load()

    local registry = QuestRegistry.new({ logger = logger })
    local engine = Engine.new({
        mq = mqAdapter, nav = nav, travel = travel, safety = safety,
        eqbc = eqbc, task = task, mech = mech, registry = registry, logger = logger,
    })
    local state = State.new(engine)

    return setmetatable({
        state = state,
        engine = engine,
        config = config,
        logger = logger,
        mq = mqAdapter,
    }, App)
end

return Container
