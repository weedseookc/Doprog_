--- doprog.zones.doomfire.index
--- Doomfire, the Burning Lands — aggregates this zone's quests in progression order.
local Zone = require('doprog.domain.zone')

---@type doprog.Zone
return Zone.new({
    shortName = 'doomfire',
    displayName = 'Doomfire, the Burning Lands',
    quests = {
        require('doprog.zones.doomfire.task_delivery'),
        require('doprog.zones.doomfire.task_remodeling'),
        require('doprog.zones.doomfire.task_strange_magic'),
    },
})
