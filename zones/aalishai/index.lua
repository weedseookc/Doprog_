--- doprog.zones.aalishai.index
--- Aalishai: Palace of Embers — aggregates this zone's quests in progression order.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'aalishai',
    displayName = 'Aalishai: Palace of Embers',
    quests = {
        require('doprog.zones.aalishai.partisan_royal_visits'),
        require('doprog.zones.aalishai.partisan_enter_mearatas'),
        require('doprog.zones.aalishai.partisan_fragmented_coterie'),
        require('doprog.zones.aalishai.mission_brass_palace'),
        require('doprog.zones.aalishai.mercenary_gathering_elements_air'),
        require('doprog.zones.aalishai.mercenary_gathering_elements_water'),
        require('doprog.zones.aalishai.mercenary_gathering_elements_earth'),
    },
})
