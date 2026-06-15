--- tests.test_targeting — doprog selects, closes on, and targets the right mob.

local H = require('tests.test_helpers')

print('test_targeting')

-- Jump straight to Soldier of Air's combat step by pre-seeding the task (pickup
-- is then already complete and the engine fast-forwards to the kill objective).
local app, state = H.app()
state.zone = 'stratos'
state.tasks['Soldier of Air'] = { id = 1, objectives = { 'Open' } }
state.nearest = {
    { id = 50, name = 'a fire mephit' },           -- must be skipped
    { id = 100, name = 'a brass phoenix soldier' }, -- the valid target
}

-- Target far away: doprog closes the distance, host holds.
state.spawnDist[100] = 300
local far = app.state:tick()
H.eq(far.directive, 'TRAVEL', 'far valid target -> doprog closes the distance')
H.ok(not app.state:shouldEngage(), 'host holds while doprog travels to the mob')
H.ok(H.commandSeen(state.commands, '/target id 100'), 'doprog targets the valid mob while closing')
H.ok(H.commandSeen(state.commands, '/nav id 100'), 'doprog navigates toward the mob')
H.ok(not H.commandSeen(state.commands, '/target id 50'), 'doprog never targets the excluded mephit')

-- Now in range: hand off to the host.
state.spawnDist[100] = 12
local near = app.state:tick()
H.eq(near.directive, 'NEED_COMBAT', 'in range -> hand off to host combat')
H.ok(near.target ~= nil and near.target.id == 100, 'the surfaced target is the Brass Phoenix mob')
