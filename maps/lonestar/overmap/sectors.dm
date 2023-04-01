// prison facility
/obj/effect/overmap/visitable/lonestar_station/mining_areas
	name = "Lonestar_Mining"
	map_z = list(Z_LEVEL_MINING_PRISON, Z_LEVEL_MINING_SALVAGE, Z_LEVEL_MINING_ROIDS)
	in_space = 1
	start_x  = 10
	start_y  = 10

/obj/effect/overmap/visitable/lonestar_station/mining_areas/Initialize()
	/*
	atmosphere = new(CELL_VOLUME)
	atmosphere.adjust_gas_temp("oxygen", MOLES_O2STANDARD, 273)
	atmosphere.adjust_gas_temp("nitrogen", MOLES_N2STANDARD, 273)

	. = ..()
*/
/obj/effect/overmap/visitable/lonestar_station/mining_areas/Initialize()
	. = ..()
	docking_codes = null

//lonestar general facilities
/obj/effect/overmap/visitable/lonestar_station/neo_vima
	name = "Lonestar_Station"
	icon_state = "object"
	base = 1
	in_space = 1
	start_x =  10
	start_y =  10
	map_z = list(Z_LEVEL_STATION_ONE, Z_LEVEL_STATION_TWO, Z_LEVEL_STATION_THREE)
	extra_z_levels = list(Z_LEVEL_TRANSIT) // Hopefully temporary, so arrivals announcements work.

/obj/effect/overmap/visitable/lonestar_station/neo_vima/Initialize()
	. = ..()
	docking_codes = null