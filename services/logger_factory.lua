--- doprog.services.logger_factory
---
--- Adapts the singleton `lwlogger` into a dependency-injectable shape.
---
--- lwlogger is a module-level singleton: app name, level and module name are
--- global to the process. That is fine for output formatting, but it does not
--- compose with our "every class gets its own logger" rule. The `LoggerFactory`
--- owns the one-time global configuration; each `Logger` it vends is a thin
--- facade that re-asserts its own module name immediately before delegating, so
--- a `NavService` log line is tagged "Nav" even if a `SafetyService` logged a
--- nanosecond earlier.

local lwlogger = require('doprog.lib.lwlogger')

-------------------------------------------------------------------------------
-- Logger facade (module-bound)
-------------------------------------------------------------------------------

---@class doprog.LoggerImpl : doprog.Logger
---@field private _module string
local Logger = {}
Logger.__index = Logger

---@param moduleName string
---@return doprog.LoggerImpl
function Logger.new(moduleName)
    return setmetatable({ _module = moduleName }, Logger)
end

--- Re-assert this facade's module name on the shared singleton, then run `fn`.
---@private
---@param fn fun()
function Logger:_scoped(fn)
    lwlogger.SetModuleName(self._module)
    fn()
end

---@param fmt string
function Logger:Trace(fmt, ...) local a = { ... } self:_scoped(function() lwlogger.Trace(fmt, table.unpack(a)) end) end
---@param fmt string
function Logger:Debug(fmt, ...) local a = { ... } self:_scoped(function() lwlogger.Debug(fmt, table.unpack(a)) end) end
---@param fmt string
function Logger:Info(fmt, ...) local a = { ... } self:_scoped(function() lwlogger.Info(fmt, table.unpack(a)) end) end
---@param fmt string
function Logger:Warn(fmt, ...) local a = { ... } self:_scoped(function() lwlogger.Warn(fmt, table.unpack(a)) end) end
---@param fmt string
function Logger:Error(fmt, ...) local a = { ... } self:_scoped(function() lwlogger.Error(fmt, table.unpack(a)) end) end
---@param fmt string
function Logger:Fatal(fmt, ...) local a = { ... } self:_scoped(function() lwlogger.Fatal(fmt, table.unpack(a)) end) end

-------------------------------------------------------------------------------
-- Factory
-------------------------------------------------------------------------------

---@class doprog.LoggerFactoryImpl : doprog.LoggerFactory
---@field private _appName string
local LoggerFactory = {}
LoggerFactory.__index = LoggerFactory

---@class doprog.LoggerFactory.Opts
---@field appName? string                       # default "doprog"
---@field level? lwlogger.Level|string          # default INFO
---@field includeTime? boolean|string           # passed through to lwlogger
---@field includeCharacter? boolean|string
---@field outputFile? boolean|string

--- Performs the one-time global configuration of lwlogger and returns a factory.
---@param opts? doprog.LoggerFactory.Opts
---@return doprog.LoggerFactoryImpl
function LoggerFactory.new(opts)
    opts = opts or {}
    local appName = opts.appName or 'doprog'
    lwlogger.SetAppName(appName)
    lwlogger.SetLevel(opts.level or lwlogger.INFO)
    if opts.includeTime ~= nil then lwlogger.SetIncludeTime(opts.includeTime) end
    if opts.includeCharacter ~= nil then lwlogger.SetIncludeCharacter(opts.includeCharacter) end
    if opts.outputFile ~= nil then lwlogger.SetOutputFile(opts.outputFile) end
    return setmetatable({ _appName = appName }, LoggerFactory)
end

--- Vend a logger bound to `moduleName`.
---@param moduleName string
---@return doprog.LoggerImpl
function LoggerFactory:forModule(moduleName)
    return Logger.new(moduleName)
end

return LoggerFactory
