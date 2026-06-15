--- doprog.services.config_service
---
--- Persistent settings + progression bookkeeping. Stored as a plain Lua table
--- serialized to a file the user can read and hand-edit. Kept free of any `mq`
--- dependency (the file path is injected) so it is trivially testable.

---@class doprog.ConfigService : doprog.IConfigService
---@field private _log doprog.Logger
---@field private _path string
---@field private _data table<string, any>
local ConfigService = {}
ConfigService.__index = ConfigService

---@class doprog.ConfigService.Deps
---@field logger doprog.LoggerFactory
---@field path string                    # absolute path to the config lua file
---@field defaults? table<string, any>

---@param deps doprog.ConfigService.Deps
---@return doprog.ConfigService
function ConfigService.new(deps)
    assert(deps and deps.path, 'ConfigService requires deps.path')
    local self = setmetatable({
        _log = deps.logger:forModule('Config'),
        _path = deps.path,
        _data = {},
    }, ConfigService)
    for k, v in pairs(deps.defaults or {}) do self._data[k] = v end
    return self
end

---@param key string
---@param default any
---@return any
function ConfigService:get(key, default)
    local v = self._data[key]
    if v == nil then return default end
    return v
end

---@param key string
---@param value any
function ConfigService:set(key, value)
    self._data[key] = value
end

--- Load settings from disk, merging over current values. Missing file is fine.
function ConfigService:load()
    local chunk, err = loadfile(self._path)
    if not chunk then
        self._log:Debug('no config at %s (%s)', self._path, tostring(err))
        return
    end
    local ok, data = pcall(chunk)
    if ok and type(data) == 'table' then
        for k, v in pairs(data) do self._data[k] = v end
        self._log:Info('loaded config from %s', self._path)
    else
        self._log:Warn('config at %s did not return a table', self._path)
    end
end

---@private
---@param value any
---@param indent string
---@return string
local function serialize(value, indent)
    local t = type(value)
    if t == 'string' then return string.format('%q', value) end
    if t == 'number' or t == 'boolean' then return tostring(value) end
    if t == 'table' then
        local parts = { '{\n' }
        local nextIndent = indent .. '  '
        for k, v in pairs(value) do
            local key = type(k) == 'string' and string.format('[%q]', k) or string.format('[%d]', k)
            parts[#parts + 1] = string.format('%s%s = %s,\n', nextIndent, key, serialize(v, nextIndent))
        end
        parts[#parts + 1] = indent .. '}'
        return table.concat(parts)
    end
    return 'nil'
end

--- Write settings to disk.
function ConfigService:save()
    local file, err = io.open(self._path, 'w')
    if not file then
        self._log:Error('cannot write config %s: %s', self._path, tostring(err))
        return
    end
    file:write('-- doprog config (auto-generated; safe to edit)\n')
    file:write('return ' .. serialize(self._data, '') .. '\n')
    file:close()
    self._log:Info('saved config to %s', self._path)
end

return ConfigService
