/datum/job/assistant
	title = "Civilian"
	flag = ASSISTANT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the mayor and the city clerk"
	selection_color = "#515151"
	minimum_character_age = 1
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit_type = /decl/hierarchy/outfit/job/assistant
	alt_titles = list("Tourist","Expat","Asylum Seeker",
					"Visitor" = /decl/hierarchy/outfit/job/assistant/visitor,
					"Resident" = /decl/hierarchy/outfit/job/assistant/resident)

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()



