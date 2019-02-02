/datum/job/rd
	title = "Research Director"
	flag = RD
	faction = "City"
	department = "Science"
	department_flag = MEDSCI
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	selection_color = "#AD6BAD"
	idtype = /obj/item/weapon/card/id/science/head
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)

	minimum_character_age = 30
	minimal_player_age = 10
	ideal_character_age = 50

	outfit_type = /decl/hierarchy/outfit/job/science/rd
	alt_titles = list("Research Supervisor")

/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	faction = "City"
	department = "Science"
	department_flag = MEDSCI
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#633D63"
	idtype = /obj/item/weapon/card/id/science/scientist
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)
	minimum_character_age = 20
	minimal_player_age = 3

	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	alt_titles = list("Xenoarchaeologist", "Anomalist", "Phoron Researcher")

/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	faction = "City"
	department = "Science"
	department_flag = MEDSCI
	total_positions = 3
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#633D63"
	idtype = /obj/item/weapon/card/id/science/xenobiologist
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage)
	minimum_character_age = 20
	minimal_player_age = 3

	outfit_type = /decl/hierarchy/outfit/job/science/xenobiologist
	alt_titles = list("Xenobotanist")

/datum/job/roboticist
	title = "Roboticist"
	flag = ROBOTICIST
	faction = "City"
	department = "Science"
	department_flag = MEDSCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "research director"
	selection_color = "#633D63"
	idtype = /obj/item/weapon/card/id/science/roboticist
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimum_character_age = 20
	minimal_player_age = 3

	outfit_type = /decl/hierarchy/outfit/job/science/roboticist
	alt_titles = list("Biomechanical Engineer","Mechatronic Engineer","Car Engineer")
