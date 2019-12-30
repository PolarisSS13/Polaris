#define Z_LEVEL_FIRST_GEMINUS					1
#define Z_LEVEL_SECOND_GEMINUS					2
#define Z_LEVEL_SKY_GEMINUS						3

/datum/map/geminus
	name = "Geminus"
	full_name = "Geminus City"
	path = "geminus"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("pollux")

	holomap_smoosh = list(list(
		Z_LEVEL_FIRST_GEMINUS,
		Z_LEVEL_SECOND_GEMINUS))

	zlevel_datum_type = /datum/map_z_level/geminus

	station_name  = "Geminus City"
	station_short = "Geminus"
	dock_name     = "Geminus City Spaceport"
	boss_name     = "Central Polluxian Government"
	boss_short    = "Pollux Gov"
	company_name  = "Nanotrasen"
	company_short = "NT"
	starsys_name  = "Vetra"

	shuttle_docked_message = "The scheduled air shuttle to the %dock_name% has arrived far west of the city. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Civilian Transfer shuttle has left. Estimate %ETA% until the airbus docks at %dock_name%."
	shuttle_called_message = "A civilian transfer to %Dock_name% has been scheduled. The airbus has been called. Those leaving should procede to the far west side of the city by %ETA%"
	shuttle_recall_message = "The scheduled civilian transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Evacuation Shuttle has arrived at the far west side of the city. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the city. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at the west side of the city in approximately %ETA%"
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	allowed_spawns = list("City Arrivals Airbus", "Cryogenic Storage", "Prison")

	usable_email_tlds = list("freemail.net", "ntmail.nt", "interpollux.org", "solnet.org", "vetralife.nt", "andromedian.org")
	default_law_type = /datum/ai_laws/pollux

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

// For making the 6-in-1 holomap, we calculate some offsets
#define GEMINUS_MAP_SIZE 177 // Width and height of compiled in Southern Cross z levels.
#define GEMINUS_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define GEMINUS_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*GEMINUS_MAP_SIZE) - GEMINUS_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define GEMINUS_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*GEMINUS_MAP_SIZE)) / 2) // 60


/datum/map/geminus/perform_map_generation()
//	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_FIRST_GEMINUS	, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_FIRST_GEMINUS	, 64, 64)         // Create the mining ore distribution map.

//	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_SECOND_GEMINUS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SECOND_GEMINUS, 64, 64)         // Create the mining ore distribution map.

	return 1

/datum/map_z_level/geminus/first
	z = Z_LEVEL_FIRST_GEMINUS
	name = "Underground Sewers"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 50
	base_turf = /turf/simulated/floor/plating
	holomap_legend_x = 220
	holomap_legend_y = 200

/datum/map_z_level/geminus/second
	z = Z_LEVEL_SECOND_GEMINUS
	name = "Geminus City"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 50
	base_turf = /turf/simulated/floor/outdoors/dirt
	holomap_offset_x = 220
	holomap_offset_y = GEMINUS_HOLOMAP_MARGIN_Y + GEMINUS_MAP_SIZE*1

/datum/map_z_level/geminus/sky
	z = Z_LEVEL_SKY_GEMINUS
	name = "Sky"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT
	transit_chance = 50
	base_turf = /turf/simulated/floor/outdoors/dirt
//	holomap_offset_x = GEMINUS_HOLOMAP_MARGIN_X - 40
//	holomap_offset_y = GEMINUS_HOLOMAP_MARGIN_Y + GEMINUS_MAP_SIZE*0

/datum/planet/sif
	expected_z_levels = list(
		Z_LEVEL_SKY_GEMINUS,
		Z_LEVEL_SECOND_GEMINUS
	)

/datum/map/geminus/get_map_info()
	. = list()
	. +=  "[full_name] is a very well-known metropolitan city in Blue Colony located on the planet Pollux.<br>"
	. +=  "Pollux exists in the Vetra star system which is entirely monopolized by NanoTrasen acting as a quasi-corporate government."
	. +=  "Being one of the first cities and initially a mining colony, Geminus has a rich history and is home to many descendants of the first prospectors.<br> "
	. +=  "There's a definite class struggle, as working class Geminians feel pushed out by the richer colonists who wish to further gentrify the city and make it... <i>more profitable, more corporate, more <b>chic</b></i>."
	return jointext(., "<br>")

