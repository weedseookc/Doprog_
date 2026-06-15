--- tests.test_safety — safety gating and death recovery preempt movement.

local H = require('tests.test_helpers')

print('test_safety')

-- In combat on a non-combat step: hold movement and WAIT.
do
    local app, state = H.app()
    state.zone = 'stratos'
    state.me.combatState = 'COMBAT'
    local s = app.state:tick()
    H.eq(s.directive, 'WAIT', 'combat on a travel/pickup step yields WAIT')
    H.ok((s.reason or ''):find('safety', 1, true) ~= nil, 'WAIT reason cites safety')
    H.ok(H.commandSeen(state.commands, '/nav stop'), 'movement is stopped while unsafe')
    H.ok(not app.state:isSafe(), 'isSafe() false while waiting')
end

-- Dead: recovery preempts everything and holds the crew.
do
    local app, state = H.app()
    state.zone = 'stratos'
    state.me.hovering = true
    local s = app.state:tick()
    H.eq(s.directive, 'WAIT', 'death yields WAIT')
    H.eq(s.reason, 'recovering', 'reason is recovering while dead')
    H.ok(H.commandSeen(state.commands, '/nav stop'), 'nav stopped during recovery')
end

-- A combat step is allowed to proceed even while in combat (host is fighting).
do
    local app, state = H.app()
    state.zone = 'stratos'
    state.tasks['Soldier of Air'] = { id = 1, objectives = { 'Open' } } -- skip pickup
    state.nearest = { { id = 100, name = 'a brass phoenix soldier' } }
    state.spawnDist[100] = 10 -- in engage range
    state.me.combatState = 'COMBAT'
    local s = app.state:tick()
    H.eq(s.directive, 'NEED_COMBAT', 'combat step is not blocked by the safety gate')
end
