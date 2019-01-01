/datum/map/geminus
	name = "Geminus"
	full_name = "Geminus City"
	path = "geminus"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("pollux")

	zlevel_datum_type = /datum/map_z_level/geminus

	station_name  = "Geminus City"
	station_short = "Geminus"
	dock_name     = "Geminus City Spaceport"
	boss_name     = "United Polluxian Government"
	boss_short    = "Pollux Gov"
	company_name  = "Nanotrasen"
	company_short = "NT"
	starsys_name  = "Vetra"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has docked with the station at docks one and two. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "A crew transfer to %Dock_name% has been scheduled. The shuttle has been called. Those leaving should procede to docks one and two in approximately %ETA%"
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station at docks one and two. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at docks one and two in approximately %ETA%"
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	allowed_spawns = list("Arrivals Shuttle")

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_NORTHERN_STAR,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

#define Z_LEVEL_FIRST_GEMINUS						1
#define Z_LEVEL_SECOND_GEMINUS					2
#define Z_LEVEL_SKY_GEMINUS						3

/datum/map/geminus/perform_map_generation()
	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_FIRST_GEMINUS	, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_FIRST_GEMINUS	, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_SECOND_GEMINUS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SECOND_GEMINUS, 64, 64)         // Create the mining ore distribution map.

	return 1

/datum/map_z_level/geminus/first
	z = Z_LEVEL_FIRST_GEMINUS
	name = "Underground Sewers"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 50
	base_turf = /turf/simulated/floor/plating

/datum/map_z_level/geminus/second
	z = Z_LEVEL_SECOND_GEMINUS
	name = "Geminus City"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 50
	base_turf = /turf/simulated/floor/outdoors/dirt

/datum/map_z_level/geminus/sky
	z = Z_LEVEL_SKY_GEMINUS
	name = "Sky"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT
	transit_chance = 50
	base_turf = /turf/simulated/sky/moving


/datum/planet/sif
	expected_z_levels = list(
		Z_LEVEL_SKY_GEMINUS,
		Z_LEVEL_SECOND_GEMINUS
	)
