--- doprog.services.eqbc_service
---
--- Crew coordination over EQBC ONLY. No DanNet, no actors — by design. The lead
--- character runs the engine and drives movement; the rest of the crew follows.
--- Everything here is expressed as EQBC broadcasts so a boxed group stays
--- together while doprog walks the leader through progression.
---
--- Requires MQ2EQBC loaded and the crew connected (`/bccmd connect`).

---@class doprog.EqbcService : doprog.IEqbcService
---@field private _mq doprog.MqAdapter
---@field private _log doprog.Logger
---@field private _leader string
---@field private _followCmd string
local EqbcService = {}
EqbcService.__index = EqbcService

---@class doprog.EqbcService.Deps
---@field mq doprog.MqAdapter
---@field logger doprog.LoggerFactory
---@field leader? string       # leader name; defaults to the current character
---@field followCmd? string    # how followers stick; default uses MQ2AdvPath /afollow

---@param deps doprog.EqbcService.Deps
---@return doprog.EqbcService
function EqbcService.new(deps)
    assert(deps and deps.mq, 'EqbcService requires deps.mq')
    return setmetatable({
        _mq = deps.mq,
        _log = deps.logger:forModule('Eqbc'),
        _leader = deps.leader or deps.mq:myName(),
        _followCmd = deps.followCmd or '/afollow spawn',
    }, EqbcService)
end

--- Send a command to every other connected character (`/bca`).
---@param command string
function EqbcService:broadcast(command)
    self._mq:cmdf('/bca //%s', command:gsub('^/', ''))
end

--- Tell the crew to follow the leader. Uses `/afollow` keyed off the leader's
--- spawn so it survives the leader moving between pulls.
function EqbcService:followLead()
    self._log:Debug('crew follow %s', self._leader)
    self:broadcast(('%s %s'):format(self._followCmd, self._leader))
end

--- Stop the crew where they stand (e.g. before a scripted pull or a hand-in).
function EqbcService:holdCrew()
    self._log:Debug('crew hold')
    self:broadcast('/afollow off')
    self:broadcast('/nav stop')
end

--- True when every connected crew member reports being in `zoneShortName`.
--- We cannot read peers' TLOs over EQBC directly, so this is implemented by the
--- engine's barrier: callers should pair this with `announce`/echo handshakes.
--- Here we conservatively check the leader is in zone and defer crew readiness
--- to the configured settle delay.
---@param zoneShortName string
---@return boolean
function EqbcService:allInZone(zoneShortName)
    return self._mq:zoneShortName() == zoneShortName
end

--- Print a status line locally and to the crew.
---@param fmt string
function EqbcService:announce(fmt, ...)
    local msg = select('#', ...) > 0 and string.format(fmt, ...) or fmt
    self._log:Info('%s', msg)
    self._mq:cmdf('/bca //echo [doprog] %s', msg)
end

return EqbcService
