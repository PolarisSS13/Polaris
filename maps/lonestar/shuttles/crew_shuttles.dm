//Shuttle 1

/obj/machinery/computer/shuttle_control/web/shuttle1
	name = "shuttle control console"
	shuttle_tag = "Shuttle 1"
	req_access = list(access_pilot)

/datum/shuttle/autodock/web_shuttle/shuttle1
	name = "Shuttle 1"
	warmup_time = 0
	shuttle_area = /area/shuttle/shuttle1/start
	current_location = "hangar_1"
	docking_controller_tag = "shuttle1_shuttle"
	web_master_type = /datum/shuttle_web_master/shuttle1
	autopilot = FALSE
	can_autopilot = TRUE
	autopilot_delay = 60
	autopilot_first_delay = 150 // Five minutes at roundstart. Two minutes otherwise.

/datum/shuttle_web_master/shuttle1
	destination_class = /datum/shuttle_destination/shuttle1
	autopath_class = /datum/shuttle_autopath/shuttle1
	starting_destination = /datum/shuttle_destination/shuttle1/root

/datum/shuttle_autopath/shuttle1/to_outpost
	start = /datum/shuttle_destination/shuttle1/root

	path_nodes = list(
		/datum/shuttle_destination/shuttle1/outside_LS,
		/datum/shuttle_destination/shuttle1/station_orbit,
		/datum/shuttle_destination/shuttle1/carls_corner
	)

/datum/shuttle_autopath/shuttle1/to_home
	start = /datum/shuttle_destination/shuttle1/carls_corner

	path_nodes = list(
		/datum/shuttle_destination/shuttle1/station_orbit,
		/datum/shuttle_destination/shuttle1/outside_LS,
		/datum/shuttle_destination/shuttle1/root
	)

//Shuttle 2

/obj/machinery/computer/shuttle_control/web/shuttle2
	name = "shuttle control console"
	shuttle_tag = "Shuttle 2"
	req_access = list(access_pilot)

/datum/shuttle/autodock/web_shuttle/shuttle2
	name = "Shuttle 2"
	warmup_time = 0
	shuttle_area = /area/shuttle/shuttle2/start
	current_location = "hangar_2"
	docking_controller_tag = "shuttle2_shuttle"
	web_master_type = /datum/shuttle_web_master/shuttle2
	autopilot = FALSE
	can_autopilot = TRUE
	autopilot_delay = 60
	autopilot_first_delay = 270 // Nine minutes at roundstart. Two minutes otherwise. This should leave when the first shuttle departs the outpost.

/datum/shuttle_web_master/shuttle2
	destination_class = /datum/shuttle_destination/shuttle2
	autopath_class = /datum/shuttle_autopath/shuttle2
	starting_destination = /datum/shuttle_destination/shuttle2/root

/datum/shuttle_autopath/shuttle2/to_outpost
	start = /datum/shuttle_destination/shuttle2/root

	path_nodes = list(
		/datum/shuttle_destination/shuttle2/outside_LS,
		/datum/shuttle_destination/shuttle2/station_orbit,
		/datum/shuttle_destination/shuttle2/carls_corner
	)

/datum/shuttle_autopath/shuttle2/to_home
	start = /datum/shuttle_destination/shuttle2/carls_corner

	path_nodes = list(
		/datum/shuttle_destination/shuttle2/station_orbit,
		/datum/shuttle_destination/shuttle2/outside_LS,
		/datum/shuttle_destination/shuttle2/root
	)

//Shuttle 3

/obj/machinery/computer/shuttle_control/web/shuttle3
	name = "shuttle control console"
	shuttle_tag = "Shuttle 3"
	req_access = list(access_pilot)

/datum/shuttle/autodock/web_shuttle/shuttle3
	name = "Shuttle 3"
	warmup_time = 0
	shuttle_area = /area/shuttle/shuttle3/start
	current_location = "hangar_3"
	docking_controller_tag = "shuttle3_shuttle"
	web_master_type = /datum/shuttle_web_master/shuttle3
	autopilot = FALSE
	can_autopilot = TRUE
	autopilot_delay = 60
	autopilot_first_delay = 270 // Nine minutes at roundstart. Two minutes otherwise. This should leave when the first shuttle departs the outpost.

/datum/shuttle_web_master/shuttle3
	destination_class = /datum/shuttle_destination/shuttle3
	autopath_class = /datum/shuttle_autopath/shuttle3
	starting_destination = /datum/shuttle_destination/shuttle3/root

/datum/shuttle_autopath/shuttle3/to_outpost
	start = /datum/shuttle_destination/shuttle3/root

	path_nodes = list(
		/datum/shuttle_destination/shuttle3/outside_LS,
		/datum/shuttle_destination/shuttle3/station_orbit,
		/datum/shuttle_destination/shuttle3/carls_corner
	)

/datum/shuttle_autopath/shuttle3/to_home
	start = /datum/shuttle_destination/shuttle3/carls_corner

	path_nodes = list(
		/datum/shuttle_destination/shuttle3/station_orbit,
		/datum/shuttle_destination/shuttle3/outside_LS,
		/datum/shuttle_destination/shuttle3/root
	)

//

/datum/shuttle_destination/shuttle1/root
	name = "Vima LS Hangar Pad One"
	my_landmark = "hangar_1"
	preferred_interim_tag = "shuttle1_transit"

	radio_announce = 1
	announcer = "Lonestar Docking Computer"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/outside_LS = 0,
	)

/datum/shuttle_destination/shuttle1/root/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to Hangar Pad One."

/datum/shuttle_destination/shuttle1/root/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed Hangar Pad One."

/datum/shuttle_destination/shuttle2/root
	name = "Vima LS Hangar Pad Two"
	my_landmark = "hangar_2"
	preferred_interim_tag = "shuttle2_transit"

	radio_announce = 1
	announcer = "Lonestar Docking Computer"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/outside_LS = 0,
	)

/datum/shuttle_destination/shuttle2/root/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to Hangar Pad Two."

/datum/shuttle_destination/shuttle2/root/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed Hangar Pad Two."

/datum/shuttle_destination/shuttle3/root
	name = "Vima LS Hangar Pad Three"
	my_landmark = "hangar_3"
	preferred_interim_tag = "shuttle3_transit"

	radio_announce = 1
	announcer = "Lonestar Docking Computer"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle3/outside_LS = 0,
	)

/datum/shuttle_destination/shuttle3/root/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to Hangar Pad Three."

/datum/shuttle_destination/shuttle3/root/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed Hangar Pad Three."

//

/datum/shuttle_destination/shuttle1/outside_LS
	name = "Outside of Vima LS"
	my_landmark = "shuttle1_seconddeck"
	preferred_interim_tag = "shuttle1_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/station_orbit = 30 SECONDS,
		/datum/shuttle_destination/shuttle1/docked_LS = 0
	)

/datum/shuttle_destination/shuttle2/outside_LS
	name = "Outside of Vima LS"
	my_landmark = "shuttle2_seconddeck"
	preferred_interim_tag = "shuttle2_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/station_orbit = 30 SECONDS,
		/datum/shuttle_destination/shuttle2/docked_LS = 0
	)

/datum/shuttle_destination/shuttle3/outside_LS
	name = "Outside of Vima LS"
	my_landmark = "shuttle3_seconddeck"
	preferred_interim_tag = "shuttle3_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle3/station_orbit = 30 SECONDS,
		/datum/shuttle_destination/shuttle3/docked_LS = 0
	)

//

/datum/shuttle_destination/shuttle1/docked_LS
	name = "Lonestar Station Docking Port"
	my_landmark = "shuttle1_arrivals_dock"
	preferred_interim_tag = "shuttle1_transit"

	radio_announce = 1
	announcer = "Lonestar Docking Computer"

/datum/shuttle_destination/shuttle1/docked_LS/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Arrivals Dock."

/datum/shuttle_destination/shuttle1/docked_LS/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Arrivals Dock."


/datum/shuttle_destination/shuttle2/docked_LS
	name = "Lonestar Station Docking Port"
	my_landmark = "shuttle2_arrivals_dock"
	preferred_interim_tag = "shuttle2_transit"

	radio_announce = 1
	announcer = "Lonestar Station Docking Computer"

/datum/shuttle_destination/shuttle2/docked_LS/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Arrivals Dock."

/datum/shuttle_destination/shuttle2/docked_LS/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Arrivals Dock."

/datum/shuttle_destination/shuttle3/docked_LS
	name = "Lonestar Station Docking Port"
	my_landmark = "shuttle3_arrivals_dock"
	preferred_interim_tag = "shuttle3_transit"

	radio_announce = 1
	announcer = "Lonestar Station Docking Computer"

/datum/shuttle_destination/shuttle3/docked_LS/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Arrivals Dock."

/datum/shuttle_destination/shuttle3/docked_LS/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Arrivals Dock."

//

/datum/shuttle_destination/shuttle1/station_orbit
	name = "Lonestar Orbit"
	my_landmark = "shuttle1_orbit"
	preferred_interim_tag = "shuttle1_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/carls_corner = 15 SECONDS,
		/datum/shuttle_destination/shuttle1/the_slammer = 15 SECONDS
	)

/datum/shuttle_destination/shuttle2/station_orbit
	name = "Lonestar Orbit"
	my_landmark = "shuttle2_orbit"
	preferred_interim_tag = "shuttle2_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/carls_corner = 15 SECONDS,
		/datum/shuttle_destination/shuttle2/the_slammer = 15 SECONDS
	)

/datum/shuttle_destination/shuttle3/station_orbit
	name = "Lonestar Orbit"
	my_landmark = "shuttle3_orbit"
	preferred_interim_tag = "shuttle3_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle3/carls_corner = 15 SECONDS,
		/datum/shuttle_destination/shuttle3/the_slammer = 15 SECONDS
	)

//


/datum/shuttle_destination/shuttle1/carls_corner
	name = "LSF Carl's Corner II"
	my_landmark = "shuttle1_roids"
	preferred_interim_tag = "shuttle1_transit"

	radio_announce = 1
	announcer = "Truckstop Automated ATC"

/datum/shuttle_destination/shuttle1/carls_corner/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at Carl's Corner."

/datum/shuttle_destination/shuttle1/carls_corner/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed Carl's Corner."

/datum/shuttle_destination/shuttle2/carls_corner
	name = "LSF Carl's Corner II"
	my_landmark = "shuttle2_roids"
	preferred_interim_tag = "shuttle2_transit"

	radio_announce = 1
	announcer = "Truckstop Automated ATC"

/datum/shuttle_destination/shuttle2/carls_corner/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at Carl's Corner."

/datum/shuttle_destination/shuttle2/carls_corner/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed Carl's Corner."

/datum/shuttle_destination/shuttle3/carls_corner
	name = "LSF Carl's Corner II"
	my_landmark = "shuttle3_roids"
	preferred_interim_tag = "shuttle3_transit"

	radio_announce = 1
	announcer = "Truckstop Automated ATC"

/datum/shuttle_destination/shuttle3/carls_corner/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at Carl's Corner."

/datum/shuttle_destination/shuttle3/carls_corner/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed Carl's Corner."

//


/datum/shuttle_destination/shuttle1/the_slammer
	name = "LSF The Slammer"
	// Note: Left area under this landmark as /area/shuttle/shuttle1/mining so it doesn't get seeded with POIs
	my_landmark = "shuttle1_prison"
	preferred_interim_tag = "shuttle1_transit"

	radio_announce = 1
	announcer = "Prison Automated ATC"

/datum/shuttle_destination/shuttle1/the_slammer/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at The Slammer."

/datum/shuttle_destination/shuttle1/the_slammer/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed The Slammer."

/datum/shuttle_destination/shuttle2/the_slammer
	name = "LSF The Slammer"
	// Note: Left area under this landmark as /area/shuttle/shuttle2/mining so it doesn't get seeded with POIs
	my_landmark = "shuttle2_prison"
	preferred_interim_tag = "shuttle2_transit"

	radio_announce = 1
	announcer = "Prison Automated ATC"

/datum/shuttle_destination/shuttle2/the_slammer/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at The Slammer."

/datum/shuttle_destination/shuttle2/the_slammer/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed The Slammer."

/datum/shuttle_destination/shuttle3/the_slammer
	name = "LSF The Slammer"
	// Note: Left area under this landmark as /area/shuttle/shuttle2/mining so it doesn't get seeded with POIs
	my_landmark = "shuttle3_prison"
	preferred_interim_tag = "shuttle3_transit"

	radio_announce = 1
	announcer = "Prison Automated ATC"

/datum/shuttle_destination/shuttle3/the_slammer/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at The Slammer."

/datum/shuttle_destination/shuttle3/the_slammer/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed The Slammer."