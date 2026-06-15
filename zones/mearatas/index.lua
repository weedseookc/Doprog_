--- doprog.zones.mearatas.index
--- Mearatas: The Stone Demesne — aggregates this zone's quests in progression order.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'mearatas',
    displayName = 'Mearatas: The Stone Demesne',
    quests = {
        require('doprog.zones.mearatas.partisan_earthen_dirge'),
        require('doprog.zones.mearatas.partisan_mold_seeker'),
        require('doprog.zones.mearatas.partisan_slippery_slope'),
        require('doprog.zones.mearatas.mission_relic_raider'),
        require('doprog.zones.mearatas.mercenary_thin_out_the_mephits'),
        require('doprog.zones.mearatas.mercenary_free_the_wardens'),
        require('doprog.zones.mearatas.mercenary_lost_missives'),
    },
})
