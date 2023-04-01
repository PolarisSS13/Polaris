/obj/machinery/computer/shuttle_control/web/ninja
	name = "stealth shuttle control console"
	req_access = list(access_syndicate)
	shuttle_tag = "Ninja"

/datum/shuttle/autodock/web_shuttle/ninja
	name = "Ninja"
	visible_name = "Unknown Vessel"
	warmup_time = 0
	can_cloak = TRUE
	cloaked = TRUE
	shuttle_area = /area/ninja_dojo/start
	current_location = "ninja_start"
	docking_controller_tag = "ninja_shuttle"
	web_master_type = /datum/shuttle_web_master/ninja
	flight_time_modifier = 0.5	// Nippon steel.

/datum/shuttle_web_master/ninja
	destination_class = /datum/shuttle_destination/ninja
	starting_destination = /datum/shuttle_destination/ninja/root

/datum/shuttle_destination/ninja/root
	name = "Dojo Outpost"
	my_landmark = "ninja_start"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/orbit = 30 SECONDS,
	)

/datum/shuttle_destination/ninja/orbit
	name = "Orbit of Lonestar"
	my_landmark = "ninja_orbit"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_LS_1d = 30 SECONDS,
		/datum/shuttle_destination/ninja/outside_LS_2d = 30 SECONDS,
		/datum/shuttle_destination/ninja/outside_LS_3d = 30 SECONDS,
		/datum/shuttle_destination/ninja/carls = 30 SECONDS,
		/datum/shuttle_destination/ninja/root = 30 SECONDS,
	)

/datum/shuttle_destination/ninja/outside_LS_1d
	name = "LSF Neo Vima - off First Deck"
	my_landmark = "ninja_firstdeck"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_LS_2d = 0,
		/datum/shuttle_destination/ninja/outside_LS_3d = 0,
		/datum/shuttle_destination/ninja/docked_LS = 0
	)

/datum/shuttle_destination/ninja/outside_LS_2d
	name = "LSF Neo Vima - off Second Deck"
	my_landmark = "ninja_seconddeck"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_LS_1d = 0,
		/datum/shuttle_destination/ninja/outside_LS_3d = 0,
		/datum/shuttle_destination/ninja/docked_LS = 0,
		/datum/shuttle_destination/ninja/cave
	)

/datum/shuttle_destination/ninja/outside_LS_3d
	name = "LSF Neo Vima - off Third Deck"
	my_landmark = "ninja_thirddeck"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_LS_1d = 0,
		/datum/shuttle_destination/ninja/outside_LS_2d = 0,
		/datum/shuttle_destination/ninja/docked_LS = 0
	)


/datum/shuttle_destination/ninja/docked_LS
	name = "LS Dock 5-B"
	my_landmark = "ninja_arrivals_dock"
	preferred_interim_tag = "ninja_transit"

	announcer = "Lonestar Station Docking Computer"

/datum/shuttle_destination/syndie/docked_LS/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Arrivals Dock."

/datum/shuttle_destination/syndie/docked_LS/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Arrivals Dock."

/datum/shuttle_destination/ninja/cave
	name = "Hidden Lonestar Cave"
	my_landmark = "ninja_cave"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_LS_2d = 0 SECONDS
	)

/datum/shuttle_destination/ninja/sky
	name = "Skies of Sif"
	my_landmark = "ninja_sky"
	preferred_interim_tag = "ninja_sky_transit"


/datum/shuttle_destination/ninja/carls
	name = "\improper Carl's Corner"
	my_landmark = "ninja_carls"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/orbit = 30 SECONDS
	)