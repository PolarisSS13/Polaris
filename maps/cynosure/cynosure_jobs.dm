// Pilots

var/global/const/EXPLORER 			=(1<<14)

var/global/const/access_explorer = 43

/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

//Cynosure Jobs

/datum/department/planetside
	name = DEPARTMENT_PLANET
	color = "#555555"
	sorting_order = 2 // Same as cargo in importance.

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director"
	selection_color =  "#633D63"
	economic_modifier = 4
	access = list(access_explorer, access_research)
	minimal_access = list(access_explorer, access_research)

	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things on the surface of Sif, and returns them to the station."

	alt_titles = list(
		"Pilot" = /datum/alt_title/pilot)

/datum/alt_title/pilot
	title = "Pilot"
	title_blurb = "A pilot ferries crew around in Cynosure Station's shuttle, the NTC Calvera."
	title_outfit = /decl/hierarchy/outfit/job/pilot

/datum/job/paramedic
	alt_titles = list(
					"Emergency Medical Technician" = /datum/alt_title/emt,
					"Search and Rescue" = /datum/alt_title/sar)

/datum/alt_title/sar
	title = "Search and Rescue"
	title_blurb = "A Search and Rescue operative recovers individuals who are injured or dead on the surface of Sif."
	title_outfit = /decl/hierarchy/outfit/job/medical/sar

/datum/job/rd
    access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
                        access_tox_storage, access_teleporter, access_sec_doors,
                        access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
                        access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch,
                        access_network, access_maint_tunnels, access_explorer, access_eva, access_external_airlocks)
    minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
                        access_tox_storage, access_teleporter, access_sec_doors,
                        access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
                        access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch,
                        access_network, access_maint_tunnels, access_explorer, access_eva, access_external_airlocks)

/datum/job/survivalist
	title = "Survivalist"
	departments = list(DEPARTMENT_PLANET)
	department_flag = CIVILIAN
	flag = HERMIT
	selection_color = "#6085a8"
	total_positions = 3
	spawn_positions = 3
	faction = "Station"
	supervisors = "your conscience"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/survivalist
	job_description = "There are a few small groups of people living in the wilderness of Sif, and they occasionally venture to the Cynosure to trade, ask for help, or just have someone to talk to."
	assignable = FALSE
	has_headset = FALSE
	account_allowed = FALSE
	offmap_spawn = TRUE
	substitute_announce_title = "Colonist"
	banned_job_species = null
	alt_titles = list("Crash Survivor" = /datum/alt_title/crash_survivor)

/datum/alt_title/crash_survivor
	title = "Crash Survivor"
	title_blurb = "Crashing in the wilderness of Sif's anomalous region is not a recommended holiday activity."
	title_outfit = /decl/hierarchy/outfit/job/survivalist/crash_survivor
