// To be filled out when more progress on the new map occurs.

#define Z_LEVEL_STATION_ONE				1
#define Z_LEVEL_STATION_TWO				2
#define Z_LEVEL_STATION_THREE			3
#define Z_LEVEL_EMPTY_SPACE				4
#define Z_LEVEL_MINING_PRISON			5
#define Z_LEVEL_MINING_SALVAGE			6
#define Z_LEVEL_MISC					7
#define Z_LEVEL_CENTCOM					8
#define Z_LEVEL_TRANSIT					9
#define Z_LEVEL_MINING_ROIDS			10

/datum/map/lonestar
	name = "Lonestar Station"
	full_name = "Lonestar Station"
	path = "lonestar_staion"

/*
	lobby_tracks = list(
		/decl/music_track/chasing_time,
		/decl/music_track/epicintro2015,
		/decl/music_track/human,
		/decl/music_track/marhaba,
		/decl/music_track/treacherous_voyage,
		/decl/music_track/asfarasitgets,
		/decl/music_track/space_oddity,
		/decl/music_track/martiancowboy)
*/

/*	lobby_icon = 'icons/misc/title.dmi'	*/
	lobby_screens = list('maps/lonestar/title_lonestar.png') // lets get a rotation of our most famous cowboys if possible
	//also it would be cool if the 'end game' of the station was to get your character's face plastered up there with the greats

	holomap_smoosh = list(list(
		Z_LEVEL_STATION_ONE,
		Z_LEVEL_STATION_TWO,
		Z_LEVEL_STATION_THREE))

	zlevel_datum_type = /datum/map_z_level/lonestar

	station_name  = "Vima"
	station_short = "Lonestar Station"
	dock_name     = "Lonestar Transit Satellite"
	boss_name     = "Central Command"
	boss_short    = "Centcom"
	company_name  = "Solar Confederate Government"
	company_short = "SolGov"
	starsys_name  = "Sol"
	use_overmap = TRUE

	shuttle_docked_message = "That there shuttle t'the %dock_name% has docked with the station on the third floor: Dockin' port 1-A! That sucker's gonna leave in about  %ETD%."
	shuttle_leaving_dock = "That there Transfer Shuttle's left the station! Reckon %ETA% til she lands at %dock_name%."
	shuttle_called_message = "A  transfer to %dock_name% has been scheduled. The shuttle has been called. Any of y'all leaving should git t'the third floor in approximately %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station on the third floor: Dockin' port 1-A! Y'all have about %ETD% till it leaves the slowpokes behind."
	emergency_shuttle_leaving_dock = "There she goes! Emergency Shuttle's left the station. Reckon %ETA% til that puppy docks over at %dock_name%."
	emergency_shuttle_called_message = "An Evacuation Order has been called. A shuttle will arrive on the third floor in about %ETA%."
	emergency_shuttle_recall_message = "Cancel that evac order."

	// Networks that will show up as options in the camera monitor program
	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIRCUITS,
							NETWORK_CIVILIAN,
							NETWORK_BAR,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_FIRST_DECK,
							NETWORK_SECOND_DECK,
							NETWORK_THIRD_DECK,
							NETWORK_MAIN_OUTPOST,
							NETWORK_MEDICAL,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_GARAGE,
							NETWORK_RANCH,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_TELECOM
							)
	// Camera networks that exist, but don't show on regular camera monitors.
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE,
							NETWORK_SUPPLY
							)
	usable_email_tlds = list("freemail.nt")
	allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")


	use_overmap = 			TRUE
	overmap_size = 			20
	overmap_event_areas = 	6
	default_skybox = /datum/skybox_settings/lonestar

	unit_test_exempt_areas = list(/area/ninja_dojo, /area/ninja_dojo/firstdeck, /area/ninja_dojo/arrivals_dock)
	unit_test_exempt_from_atmos = null //list(/area/lonestar/command/server)

	planet_datums_to_make = list(/datum/planet/mining)

	map_levels = list(
			Z_LEVEL_STATION_ONE,
			Z_LEVEL_STATION_TWO,
			Z_LEVEL_STATION_THREE,
			Z_LEVEL_MINING_PRISON,
			Z_LEVEL_MINING_SALVAGE,
			Z_LEVEL_MINING_ROIDS
		)

/datum/map/lonestar/perform_map_generation()
	// First, place a bunch of submaps. This comes before tunnel/forest generation as to not interfere with the submap.

	// Slammer submaps are first.
	SSmapping.seed_area_submaps(
		list(Z_LEVEL_MINING_PRISON),
		75,
		/area/lonestar/away/slammer/normal,
		/datum/map_template/space/slammer/normal
	)
	SSmapping.seed_area_submaps(
		list(Z_LEVEL_MINING_PRISON),
		75,
		/area/lonestar/away/slammer/deep,
		/datum/map_template/space/slammer/deep
	)

	// Then we fill up the wrecking yard.
	SSmapping.seed_area_submaps(
		list(Z_LEVEL_MINING_SALVAGE),
		150,
		/area/lonestar/away/yard/wrecking,
		/datum/map_template/space/derelicts
	)

	// the Roids are next.
	SSmapping.seed_area_submaps(
		list(Z_LEVEL_MINING_ROIDS),
		100,
		/area/lonestar/away/roids/close,
		/datum/map_template/space/roids/close
	)

	SSmapping.seed_area_submaps(
		list(Z_LEVEL_MINING_ROIDS),
		75,
		/area/lonestar/away/roids/far,
		/datum/map_template/space/roids/far
	)

	// If other submaps are made, add a line to make them here as well.

	// Now for the tunnels.
	var/time_started = REALTIMEOFDAY
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_MINING_PRISON, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_MINING_PRISON, 64, 64)   								 // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_MINING_ROIDS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_MINING_ROIDS, 64, 64) 									// Create the mining ore distribution map.
	to_world_log("Generated caves in [(REALTIMEOFDAY - time_started) / 10] second\s.")
	time_started = REALTIMEOFDAY
	return 1

/datum/map/lonestar/get_map_info()
	. = list()
	. +=  "[full_name] is a a cluster of goods production facilities on Comanche, a super-massive asteroid in the Main Asteroid Belt of the Sol System.<br>"
	. +=  "Following the Skathari Incursion, an invasion of reality-bending creatures from the remnants of a dead universe, the known galaxy has been thrown into disarray.<br>"
	. +=  "The Solar Confederate Government struggles under its own weight, with new factions arising with promises of autonomy, security or profit like circling vultures.<br>"
	. +=  "Humanity already stands on the precipice of a technological singularity that few are ready to face, and the winds of change whip at their backs.<br>"
	. +=  "In the middle of Solar Confederate territory, Lonestar seeks to exploit the lack of Sol Gov oversight, and blaze a trail to freedom."
	return jointext(., "<br>")

// Skybox Settings
/datum/skybox_settings/lonestar
	icon_state = "dyable"
	random_color = TRUE

// For making the 6-in-1 holomap, we calculate some offsets
#define LONESTAR_STATION_MAP_SIZE 160 // Width and height of compiled in Sou- uhhh... lonestar z levels.
#define LONESTAR_STATION_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define LONESTAR_STATION_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*LONESTAR_STATION_MAP_SIZE) - LONESTAR_STATION_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define LONESTAR_STATION_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*LONESTAR_STATION_MAP_SIZE)) / 2) // 60

/datum/map_z_level/lonestar/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/lonestar/station/station_one
	z = Z_LEVEL_STATION_ONE
	name = "Deck 1"
	base_turf = /turf/space
	transit_chance = 6
	holomap_offset_x = LONESTAR_STATION_HOLOMAP_MARGIN_X - 40
	holomap_offset_y = LONESTAR_STATION_HOLOMAP_MARGIN_Y + LONESTAR_STATION_MAP_SIZE*0

/datum/map_z_level/lonestar/station/station_two
	z = Z_LEVEL_STATION_TWO
	name = "Deck 2"
	base_turf = /turf/simulated/open
	transit_chance = 6
	holomap_offset_x = LONESTAR_STATION_HOLOMAP_MARGIN_X - 40
	holomap_offset_y = LONESTAR_STATION_HOLOMAP_MARGIN_Y + LONESTAR_STATION_MAP_SIZE*1

/datum/map_z_level/lonestar/station/station_three
	z = Z_LEVEL_STATION_THREE
	name = "Deck 3"
	base_turf = /turf/simulated/open
	transit_chance = 6
	holomap_offset_x = HOLOMAP_ICON_SIZE - LONESTAR_STATION_HOLOMAP_MARGIN_X - LONESTAR_STATION_MAP_SIZE - 40
	holomap_offset_y = LONESTAR_STATION_HOLOMAP_MARGIN_Y + LONESTAR_STATION_MAP_SIZE*1

/datum/map_z_level/lonestar/empty_space
	z = Z_LEVEL_EMPTY_SPACE
	name = "Empty"
	flags = MAP_LEVEL_PLAYER
	transit_chance = 76

/datum/map_z_level/lonestar/slammer
	z = Z_LEVEL_MINING_PRISON
	name = "LSF The Slammer"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED|MAP_LEVEL_CONSOLES
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_z_level/lonestar/derelicts
	z = Z_LEVEL_MINING_SALVAGE
	name = "Carls Wrecking Yard"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED|MAP_LEVEL_CONSOLES
	base_turf = /turf/space

/datum/map_z_level/lonestar/belt
	z = Z_LEVEL_MINING_ROIDS
	name = "LSF Carls Corner II"
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES
	base_turf = /turf/space

/datum/map_z_level/lonestar/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_PLAYER
	transit_chance = 6

/datum/map_z_level/lonestar/centcom
	z = Z_LEVEL_CENTCOM
	name = "Centcom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT

/datum/map_z_level/lonestar/transit
	z = Z_LEVEL_TRANSIT
	name = "Transit"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT

//Teleport from Slammer to Wrecking Yard

/obj/effect/step_trigger/teleporter/yard/to_yard/New()
	..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_MINING_SALVAGE

/obj/effect/step_trigger/teleporter/yard/from_yard/New()
	..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_MINING_PRISON

//Teleport from Wrecking Yard to Carl's Corner

/obj/effect/step_trigger/teleporter/rim/to_rim/New()
	..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_MINING_ROIDS

/obj/effect/step_trigger/teleporter/rim/from_rim/New()
	..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_MINING_SALVAGE


/datum/planet/mining
	expected_z_levels = list(
		Z_LEVEL_MINING_PRISON,
		Z_LEVEL_MINING_SALVAGE,
		Z_LEVEL_MINING_ROIDS
	)

/obj/effect/step_trigger/teleporter/bridge/east_to_west/Initialize()
	teleport_x = src.x - 4
	teleport_y = src.y
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/east_to_west/small/Initialize()
	teleport_x = src.x - 3
	teleport_y = src.y
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/west_to_east/Initialize()
	teleport_x = src.x + 4
	teleport_y = src.y
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/west_to_east/small/Initialize()
	teleport_x = src.x + 3
	teleport_y = src.y
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/north_to_south/Initialize()
	teleport_x = src.x
	teleport_y = src.y - 4
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/south_to_north/Initialize()
	teleport_x = src.x
	teleport_y = src.y + 4
	teleport_z = src.z
	return ..()

/obj/effect/map_effect/portal/master/side_a/slammer_to_yard
	portal_id = "slammer_yard-normal"

/obj/effect/map_effect/portal/master/side_b/yard_to_slammer
	portal_id = "slammer_yard-normal"

/obj/effect/map_effect/portal/master/side_a/slammer_to_yard/cliff
	portal_id = "slammer_yard-cliff"

/obj/effect/map_effect/portal/master/side_b/yard_to_slammer/cliff
	portal_id = "slammer_yard-cliff"


/obj/effect/map_effect/portal/master/side_a/yard_to_rim
	portal_id = "yard_rim-normal"

/obj/effect/map_effect/portal/master/side_b/rim_to_yard
	portal_id = "yard_rim-normal"

/obj/effect/map_effect/portal/master/side_a/yard_to_rim/cliff
	portal_id = "yard_rim-cliff"

/obj/effect/map_effect/portal/master/side_b/rim_to_yard/cliff
	portal_id = "yard_rim-cliff"

//Suit Storage Units

/obj/machinery/suit_cycler/pilot
	name = "Pilot suit cycler"
	model_text = "Pilot"
	req_access = null
	req_one_access = list(access_pilot)