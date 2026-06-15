--- doprog.services.safety_service
---
--- "Keep our ass safe while traveling." This is the watchdog that gates
--- movement. doprog never fights, but it must not blindly walk the crew off a
--- cliff of adds or keep navving while the leader is dead. Each tick the engine
--- asks `assess()` and only advances travel/objectives when the gate is "clear".
---
--- Combat itself is the host system's job. SafetyService only decides whether it
--- is currently SAFE to keep moving, and owns death recovery so progression can
--- resume after a wipe.

---@class doprog.SafetyService : doprog.ISafetyService
---@field private _mq doprog.MqAdapter
---@field private _eqbc doprog.EqbcService
---@field private _log doprog.Logger
---@field private _lowHpPct number
---@field private _recovering boolean
local SafetyService = {}
SafetyService.__index = SafetyService

---@class doprog.SafetyService.Deps
---@field mq doprog.MqAdapter
---@field eqbc doprog.EqbcService
---@field logger doprog.LoggerFactory
---@field lowHpPct? number   # below this, treat as crew_hurt; default 35

---@param deps doprog.SafetyService.Deps
---@return doprog.SafetyService
function SafetyService.new(deps)
    assert(deps and deps.mq and deps.eqbc, 'SafetyService requires deps.mq and deps.eqbc')
    return setmetatable({
        _mq = deps.mq,
        _eqbc = deps.eqbc,
        _log = deps.logger:forModule('Safety'),
        _lowHpPct = deps.lowHpPct or 35,
        _recovering = false,
    }, SafetyService)
end

--- Evaluate the current safety gate.
---@return doprog.SafetyGate
function SafetyService:assess()
    if self._mq:isDead() or self._recovering then
        return 'recovering'
    end
    if self._mq:inCombat() or self._mq:xtargets() > 0 then
        return 'in_combat'
    end
    if self._mq:pctHps() < self._lowHpPct then
        return 'crew_hurt'
    end
    return 'clear'
end

---@return boolean
function SafetyService:isSafe()
    return self:assess() == 'clear'
end

--- Drive death recovery. Returns true when recovery is complete (or not needed).
--- Strategy: stop nav, hold the crew, and wait to be rezzed in place. If we end
--- up back at bind (no rez), the engine will re-route to the current objective
--- on its own once this returns true.
---@return boolean
function SafetyService:handleRecovery()
    if not self._mq:isDead() then
        if self._recovering then
            self._log:Info('recovery complete')
            self._recovering = false
        end
        return true
    end

    if not self._recovering then
        self._recovering = true
        self._log:Error('character down — entering recovery, holding crew')
        self._mq:cmd('/nav stop')
        self._eqbc:holdCrew()
        self._eqbc:announce('leader down, holding for rez')
    end
    -- Still hovering; wait for a rez (host/healer/crew handles the actual rez).
    return false
end

return SafetyService
