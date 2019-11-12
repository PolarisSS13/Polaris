// Maps for faction bases go here.

// HOW TO ADD A NEW FACTIONS MAP:

//		Step 1:
//		Add an area in this file "factions_maps.dm" Make sure the area
//		is a subtype of the faction name.

//		Step 2:
//		Add the map file. Ensure your map is 18x18. No bigger or smaller.
//		Map file should be placed under it's faction folder, and it should
//		have the area noted in step 1. See cartel_aqua.dmm as example.

//		Step 3:
//		Under a .dm file IE: cartel_maps.dm/trustfund_maps.dm etc, add a
//		name and description and the link to the map file. See cartel_maps.dm
//		for a template. No need to check the map file. The game will pick it up
//		when a base is loaded.

//		Step 4:
//		Finally, Make sure the faction name is noted under the template datum,
//		"faction_type" necessary for it to work and be exclusive. "Generic" types
//		means this base can be used by any faction.

/datum/map_template/surface/factions
	faction_type = "Generic" //Use "Generic" if it can be spawned by all factions.

var/list/global/generic_bases = list()

var/list/global/blue_moon_cartel_bases = list()
var/list/global/trust_fund_bases = list()
var/list/global/quercus_coalition_bases = list()
var/list/global/workers_union_bases = list()

//Generic Factions map.
/area/submap/factions
	has_gravity = 1
	power_equip = 1
	power_light = 1
	power_environ = 1
	requires_power = 0
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/outdoors/dirt


//Blue Moon Cartel Bases.
/area/submap/factions/bluemooncartel/cartel_aqua
	name = "Aquatic Weapons Deal Base"
	music = "music/escape.ogg"



//Quercus Bases.
/area/submap/factions/bluemooncartel/cartel_aqua
	name = "Trendy Computer Lab"
	music = "music/escape.ogg"