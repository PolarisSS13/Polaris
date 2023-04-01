/obj/machinery/computer/shuttle_control/multi/response
	name = "response shuttle console"
	shuttle_tag = "Response Operations"
	req_access = list(access_cent_specops)
/*
/datum/shuttle/multi_shuttle/response
	name = "Response Operations"
	warmup_time = 5
	origin = /area/shuttle/response_ship/start
	interim = /area/shuttle/response_ship/transit
	start_location = "Response Team Ship"
	destinations = list(
		"Northwest of First deck" = /area/shuttle/response_ship/firstdeck,
		"Southeast of Second deck" = /area/shuttle/response_ship/seconddeck,
		"Northeast of Third deck" = /area/shuttle/response_ship/thirddeck,
		"Planetside Site" = /area/shuttle/response_ship/planet,
		"Docking Port" = /area/shuttle/response_ship/arrivals_dock,
		)
	docking_controller_tag = "response_shuttle"
	destination_dock_targets = list(
		"Response Team Base" = "response_ship",
		"Docking Port" = "response_shuttle_dock_airlock",
		)
*/
/obj/machinery/computer/shuttle_control/web/ert
	name = "response shuttle control console"
	req_access = list(access_cent_specops)
	shuttle_tag = "Response Operations"

/datum/shuttle/autodock/web_shuttle/ert
	name = "Response Operations"
	warmup_time = 0
	can_cloak = TRUE
	cloaked = FALSE
	shuttle_area = /area/shuttle/response_ship/start
	current_location = "response_ship_start"
	docking_controller_tag = "response_shuttle"
	web_master_type = /datum/shuttle_web_master/ert
	flight_time_modifier = 3	// could be a bit faster...

/datum/shuttle_web_master/ert
	destination_class = /datum/shuttle_destination/ert
	starting_destination = /datum/shuttle_destination/ert/root

/datum/shuttle_destination/ert/root
	name = "Central Command"
	my_landmark = "response_ship_start"
	preferred_interim_tag = "response_ship_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ert/orbit = 1 MINUTE,
	)

/datum/shuttle_destination/ert/orbit
	name = "Orbit Over Lonestar"
	my_landmark = "response_ship_orbit"
	preferred_interim_tag = "response_ship_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ert/outside_LS_1d = 30 SECONDS,
		/datum/shuttle_destination/ert/outside_LS_2d = 30 SECONDS,
		/datum/shuttle_destination/ert/outside_LS_3d = 30 SECONDS,
		/datum/shuttle_destination/ert/root = 1 MINUTE
	)

/datum/shuttle_destination/ert/outside_LS_1d
	name = "Vima LS - Off First Deck"
	my_landmark = "response_ship_firstdeck"
	preferred_interim_tag = "response_ship_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ert/outside_LS_2d = 0,
		/datum/shuttle_destination/ert/outside_LS_3d = 0,
		/datum/shuttle_destination/ert/docked_LS = 0
	)


/datum/shuttle_destination/ert/outside_LS_2d
	name = "Vima LS - Off Second Deck"
	my_landmark = "response_ship_seconddeck"
	preferred_interim_tag = "response_ship_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ert/outside_LS_1d = 0,
		/datum/shuttle_destination/ert/outside_LS_3d = 0,
		/datum/shuttle_destination/ert/docked_LS = 0
	)

/datum/shuttle_destination/ert/outside_LS_3d
	name = "Vima LS - Off Third Deck"
	my_landmark = "response_ship_thirddeck"
	preferred_interim_tag = "response_ship_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ert/outside_LS_1d = 0,
		/datum/shuttle_destination/ert/outside_LS_2d = 0,
		/datum/shuttle_destination/ert/docked_LS = 0
	)

/datum/shuttle_destination/ert/docked_LS
	name = "LS Dock 5-C"
	my_landmark = "response_ship_arrivals_dock"
	preferred_interim_tag = "response_ship_transit"

	announcer = "Lonestar Station Docking Computer"

/datum/shuttle_destination/ert/docked_LS/get_arrival_message()
	return "Attention, the Emergency Response Team's shuttle has arrived to the Arrivals Dock."

/datum/shuttle_destination/ert/docked_LS/get_departure_message()
	return "Attention, the Emergency Response Team's shuttle has departed the Arrivals Dock."

/*
/datum/shuttle_destination/ert/sky
	name = "Skies of Sif"
	my_landmark = "response_ship_sky"
	preferred_interim_tag = "response_ship_sky_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ert/planet = 15 SECONDS
	)

/datum/shuttle_destination/ert/planet
	name = "Sif Surface"
	my_landmark = "response_ship_planet"
	preferred_interim_tag = "response_ship_sky_transit"
*/