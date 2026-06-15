--- doprog.zones.empyr.index
--- Empyr: Realms of Ash — aggregates this zone's quests in progression order.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'empyr',
    displayName = 'Empyr: Realms of Ash',
    quests = {
        require('doprog.zones.empyr.partisan_prisoners_dilemma'),
        require('doprog.zones.empyr.partisan_palace_of_embers'),
        require('doprog.zones.empyr.partisan_fire_and_fury'),
        require('doprog.zones.empyr.mission_prince_ralaifin'),
        require('doprog.zones.empyr.mercenary_scalding_webs'),
        require('doprog.zones.empyr.mercenary_crafted_from_ash'),
        require('doprog.zones.empyr.mercenary_slimy_yet_sizzling'),
    },
})
