--- tests.mock_mq
---
--- A controllable stand-in for the global `mq` table, good enough to exercise
--- everything MqAdapter touches. Tests mutate `mq._state` to set up the world
--- and read `mq._commands` to assert what doprog issued. No EverQuest required.

local M = {}

--- Build a fresh mock mq.
---@return table mq, table state
function M.new()
    local state = {
        zone = 'stratos',
        gameState = 'INGAME',
        me = {
            name = 'Tester', moving = false, combatState = 'ACTIVE',
            pctHps = 100, hovering = false, xtarget = 0,
            x = 0, y = 0, z = 0, heading = 0,
        },
        spawnId = 0,            -- value returned by Spawn(...).ID()
        targetId = 0,
        nav = { active = false, pathExists = true },
        tasks = {},             -- name -> { id=number, objectives={'Done','Open',...} }
        items = {},             -- name -> count
        plugins = { MQ2Nav = true, MQ2EQBC = true },
    }

    local commands = {}
    state.commands = commands -- exposed for assertions

    local function record(s) commands[#commands + 1] = s end

    local TLO = {}
    TLO.Zone = { ShortName = function() return state.zone end }
    TLO.EverQuest = { GameState = function() return state.gameState end }
    TLO.Me = {
        CleanName = function() return state.me.name end,
        Moving = function() return state.me.moving end,
        CombatState = function() return state.me.combatState end,
        PctHPs = function() return state.me.pctHps end,
        Hovering = function() return state.me.hovering end,
        XTarget = function() return state.me.xtarget end,
        X = function() return state.me.x end,
        Y = function() return state.me.y end,
        Z = function() return state.me.z end,
        Heading = { Degrees = function() return state.me.heading end },
    }
    TLO.Spawn = function(_) return { ID = function() return state.spawnId end } end
    TLO.Target = { ID = function() return state.targetId end }
    TLO.Navigation = {
        Active = function() return state.nav.active end,
        PathExists = function(_) return function() return state.nav.pathExists end end,
    }
    TLO.Task = function(name)
        local t = state.tasks[name]
        return {
            ID = function() return t and (t.id or 1) or 0 end,
            Objective = function(i)
                return { Status = function() return t and t.objectives and t.objectives[i] or nil end }
            end,
        }
    end
    TLO.Plugin = function(name) return { IsLoaded = function() return state.plugins[name] == true end } end
    TLO.FindItemCount = function(arg)
        local name = tostring(arg):gsub('^=', '')
        return function() return state.items[name] or 0 end
    end

    local mq = {
        TLO = TLO,
        configDir = '/tmp',
        _state = state,
        _commands = commands,
        cmd = function(c) record(c) end,
        cmdf = function(fmt, ...) record(string.format(fmt, ...)) end,
        delay = function(_, cond) if type(cond) == 'function' then cond() end end,
        doevents = function() end,
        bind = function() end,
        imgui = { init = function() end, destroy = function() end },
    }
    return mq, state
end

return M
