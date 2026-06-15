--- doprog.zones.plane_of_smoke.index
--- The Plane of Smoke. Progression requires completing ONE Trial of Smoke. We
--- default to the Trial of Three; swap the require (or make it config-driven) to
--- pick another. The optional mercenary kill-grind is intentionally not listed
--- here (its giver name needs in-game confirmation) so it never gates progress.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'smoke',
    displayName = 'The Plane of Smoke',
    quests = {
        require('doprog.zones.plane_of_smoke.trials.trial_three'),
    },
})
