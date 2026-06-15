--- doprog.zones.plane_of_smoke.index
--- The Plane of Smoke. Progression requires completing ONE Trial of Smoke. We
--- default to the Trial of Three; swap the require below (or make it
--- config-driven) to pick a different trial. The mercenary kill task is optional
--- grind and listed after.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'smoke',
    displayName = 'The Plane of Smoke',
    quests = {
        require('doprog.zones.plane_of_smoke.trials.trial_three'),
        require('doprog.zones.plane_of_smoke.mercenary_plane_of_smoke'),
    },
})
