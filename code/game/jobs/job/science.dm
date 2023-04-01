//////////////////////////////////
//		Ranch Overseer
//////////////////////////////////
/datum/job/ranch_head
	title = "Ranch Overseer"
	flag = RANCH_HEAD
	departments_managed = list(DEPARTMENT_RANCH)
	departments = list(DEPARTMENT_RANCH, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron, Steward and Lonestar Regulation"
	selection_color = "#633D63"
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics,
			            access_tox_storage, access_maint_tunnels, access_research,
			            access_xenobiology, access_RC_announce, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics,
			            access_tox_storage, access_research,
			            access_xenobiology, access_RC_announce, access_network)

	minimum_character_age = 25
	minimal_player_age = 14
	min_age_by_species = list(SPECIES_UNATHI = 70, "mechanical" = 10, SPECIES_HUMAN_VATBORN = 14)
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_UNATHI = 140, "mechanical" = 20, SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_VOX, SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital")


	outfit_type = /decl/hierarchy/outfit/job/science/ranch_head
	job_description = "The Ranch Overseer manages and maintains the Ranch. These experienced farmers are present to guide their staff as they grow crops \
						and tend livestock, as well as to inform the crew of any disruptions that might originate from the Ranch. An Overseer should have \
						a good awareness of both the needs of crewmembers and the most profitable exports."
	alt_titles = list("Ranch Supervisor" = /datum/alt_title/ranch_supervisor)

// Ranch Overseer Alt Titles
/datum/alt_title/ranch_supervisor
	title = "Ranch Supervisor"

//////////////////////////////////
//			Head Mechanic
//////////////////////////////////
/datum/job/garage_head
	title = "Head Mechanic"
	flag = GARAGE_HEAD
	departments_managed = list(DEPARTMENT_GARAGE)
	departments = list(DEPARTMENT_GARAGE, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron, Steward and Lonestar Regulation"
	selection_color = "#AD6BAD"
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_morgue, access_maint_tunnels,
			            access_tox_storage, access_teleporter,
			            access_research, access_robotics, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_morgue,
			            access_tox_storage, access_teleporter,
			            access_research, access_robotics, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)

	minimum_character_age = 25
	minimal_player_age = 14
	min_age_by_species = list(SPECIES_UNATHI = 70, "mechanical" = 10, SPECIES_HUMAN_VATBORN = 14)
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_UNATHI = 140, "mechanical" = 20, SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_VOX, SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital")


	outfit_type = /decl/hierarchy/outfit/job/science/head_mechanic
	job_description = "The Head Mechanic manages and maintains the Garage. They are in charge of the approval process of their department's production, \
						and should keep their staff focused on the needs of the station or the relevant current exports. Though they should delegate tasks  \
						to their staff, the Head Mechanic is expected to know a good deal about mechanical prosthetic, hard suit and vehicle construction."

/*
	alt_titles = list("Xenoarchaeologist" = /datum/alt_title/xenoarch, "Anomalist" = /datum/alt_title/anomalist, \
						"Phoron Researcher" = /datum/alt_title/phoron_research)

// Scientist Alt Titles
/datum/alt_title/xenoarch
	title = "Xenoarchaeologist"
	title_blurb = "A Xenoarchaeologist enters digsites in search of artifacts of alien origin. These digsites are frequently in vacuum or other inhospitable \
					locations, and as such a Xenoarchaeologist should be prepared to handle hostile evironmental conditions."

/datum/alt_title/anomalist
	title = "Anomalist"
	title_blurb = "An Anomalist is a Scientist whose expertise is analyzing alien artifacts. They are familar with the most common methods of testing artifact \
					function. They work closely with Xenoarchaeologists, or Miners, if either role is present."

/datum/alt_title/phoron_research
	title = "Phoron Researcher"
	title_blurb = "A Phoron Researcher is a specialist in the practical applications of phoron, and has knowledge of its practical uses and dangers. \
					Many Phoron Researchers are interested in the combustability and explosive properties of gaseous phoron, as well as the specific hazards \
					of working with the substance in that state."
*/

//////////////////////////////////
//			Xenobiologist
//////////////////////////////////
/datum/job/xenobiologist
	title = "Ranch Hand"
	flag = XENOBIOLOGIST
	departments = list(DEPARTMENT_RANCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 2
	supervisors = "the Ranch Overseer"
	selection_color = "#633D63"
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage)

	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/science/ranch_hand
	job_description = "A Ranch Hand works to grow and cultivate Lonestar's various GMOs. They should always be wary of the side effects their work has, as well \
						as well as how to mitigate those effects while they work. A good knowledge of the needs of the crew is also encouraged, as the Ranch is \
						the main food source for the facility."


	alt_titles = list("Xenobotanist" = /datum/alt_title/xenobot, "Biologist" = /datum/alt_title/biologist, \
						"Genetic Researcher" = /datum/alt_title/genetic_research)

// Xenibiologist Alt Titles
/datum/alt_title/xenobot
	title = "Xenobotanist"

/datum/alt_title/biologist
	title = "Biologist"

/datum/alt_title/genetic_research
	title = "Genetic Researcher"

//////////////////////////////////
//			Roboticist
//////////////////////////////////
/datum/job/roboticist
	title = "Mechanic"
	flag = ROBOTICIST
	departments = list(DEPARTMENT_GARAGE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 2
	supervisors = "the Head Mechanic"
	selection_color = "#AD6BAD"
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/science/mechanic
	job_description = "A Mechanic maintains and repairs the station's synthetics, including crew with prosthetic limbs. \
						They can also assist the station by producing simple robots and even pilotable exosuits."

	alt_titles = list("Biomechanical Engineer" = /datum/alt_title/biomech, "Mechatronic Engineer" = /datum/alt_title/mech_tech)

// Roboticist Alt Titles
/datum/alt_title/biomech
	title = "Biomechanical Engineer"

/datum/alt_title/mech_tech
	title = "Mechatronic Engineer"
