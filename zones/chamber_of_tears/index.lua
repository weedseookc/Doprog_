--- doprog.zones.chamber_of_tears.index
--- The Chamber of Tears — a quest hub referenced by eqresource. No standalone
--- group-progression quests are wired here yet; add them as files in this
--- folder and list them below.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'chamberoftears',
    displayName = 'The Chamber of Tears',
    quests = {},
})
