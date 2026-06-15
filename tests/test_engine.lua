--- tests.test_engine — the directive state machine end-to-end against mock mq.

local H = require('tests.test_helpers')

print('test_engine')

local app, state = H.app()

-- Fresh in Stratos, no tasks, giver not yet found -> we should be traveling.
state.zone = 'stratos'
state.spawnId = 0
local s1 = app.state:tick()
H.ok(s1.directive == 'TRAVEL' or s1.directive == 'PICKUP',
    'first tick works the first Stratos quest (got ' .. s1.directive .. ')')
H.eq(s1.questName, 'Soldier of Air', 'first actionable quest is Soldier of Air')

-- "Arrive" at the giver (spawn resolves) -> we accept the task.
state.spawnId = 100
local s2 = app.state:tick()
H.eq(s2.directive, 'PICKUP', 'at giver, directive is PICKUP')
H.ok(H.commandSeen(state.commands, '/say Hail'), 'pickup hails the giver')

-- The task now exists with an open objective -> advance to combat handoff.
-- doprog must pick the RIGHT mob: skip the mephit (doesn't count), target the
-- Brass Phoenix mob, and only hand off once it is in range.
state.tasks['Soldier of Air'] = { id = 1, objectives = { 'Open' } }
state.nearest = {
    { id = 50, name = 'a fire mephit' },          -- excluded: doesn't count
    { id = 100, name = 'a brass phoenix soldier' }, -- the valid target
}
state.spawnDist[100] = 10 -- already in engage range
local s3 = app.state:tick()
H.eq(s3.directive, 'NEED_COMBAT', 'with a valid in-range target, hand off to combat')
H.ok(app.state:shouldEngage(), 'shouldEngage() is true during NEED_COMBAT')
H.ok(s3.target ~= nil and s3.target.id == 100, 'doprog surfaces the Brass Phoenix mob (id 100)')
H.ok(H.commandSeen(state.commands, '/target id 100'), 'doprog targets the valid mob')
H.ok(not H.commandSeen(state.commands, '/target id 50'), 'doprog never targets the mephit')

-- doprog must NEVER fight: no attack/assist commands should ever be issued.
H.ok(not H.commandSeen(state.commands, '/attack'), 'doprog never issues /attack')
H.ok(not H.commandSeen(state.commands, '/assist'), 'doprog never issues /assist')

-- Objective done -> Soldier of Air complete -> engine moves to the next quest.
state.tasks['Soldier of Air'].objectives = { 'Done' }
local s4 = app.state:tick()
H.ok(s4.questName ~= 'Soldier of Air',
    'completed quest is no longer active (now ' .. tostring(s4.questName) .. ')')
