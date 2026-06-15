--- doprog.zones.stratos.index
--- Stratos: Zephyr's Flight — TBL entry. Soldier of Air and the Fight Fire
--- mission gate the Plane of Smoke trials, so they lead; the remaining partisan
--- and mercenary tasks follow.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'stratos',
    displayName = "Stratos: Zephyr's Flight",
    quests = {
        require('doprog.zones.stratos.mercenary_soldier_of_air'),
        require('doprog.zones.stratos.mission_fight_fire'),
        require('doprog.zones.stratos.partisan_petitioners_plight'),
        require('doprog.zones.stratos.partisan_political_awareness'),
        require('doprog.zones.stratos.partisan_key_to_the_kingdom'),
        require('doprog.zones.stratos.mercenary_do_unto_them'),
        require('doprog.zones.stratos.mercenary_earning_ones_place'),
    },
})
