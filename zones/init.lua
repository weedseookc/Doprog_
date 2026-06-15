--- doprog.zones
---
--- The ordered TBL group-progression path. The QuestRegistry walks this list in
--- order, so the sequence here IS the progression: a zone's quests are only
--- worked once the earlier zones (and each quest's own prereqs) are satisfied.
---
--- Order follows tbl.eqresource.com progression:
---   Stratos -> Plane of Smoke (trials) -> Esianti -> Empyr -> Aalishai ->
---   Mearatas, with Doomfire / Chamber of Tears as side hubs at the end.

---@type doprog.Zone[]
return {
    require('doprog.zones.stratos.index'),
    require('doprog.zones.plane_of_smoke.index'),
    require('doprog.zones.esianti.index'),
    require('doprog.zones.empyr.index'),
    require('doprog.zones.aalishai.index'),
    require('doprog.zones.mearatas.index'),
    require('doprog.zones.doomfire.index'),
    require('doprog.zones.chamber_of_tears.index'),
}
