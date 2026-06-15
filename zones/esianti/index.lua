--- doprog.zones.esianti.index
--- Esianti: Palace of the Winds — aggregates this zone's quests in progression order.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'esianti',
    displayName = 'Esianti: Palace of the Winds',
    quests = {
        require('doprog.zones.esianti.partisan_all_hail_the_king'),
        require('doprog.zones.esianti.partisan_serving_another_master'),
        require('doprog.zones.esianti.partisan_of_mice_and_jann'),
        require('doprog.zones.esianti.mission_contract_of_war'),
        require('doprog.zones.esianti.mercenary_armor_of_acrophobia'),
        require('doprog.zones.esianti.mercenary_not_as_swell'),
        require('doprog.zones.esianti.mercenary_beyond_expyration_date'),
        require('doprog.zones.esianti.mercenary_sweeping_up_the_brumes'),
    },
})
