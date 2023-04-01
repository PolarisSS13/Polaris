//////////////////////////////////
//			Assistant
//////////////////////////////////
/datum/job/assistant
	title = "Tourist"
	flag = ASSISTANT
	departments = list(DEPARTMENT_CIVILIAN)
	sorting_order = -1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

	outfit_type = /decl/hierarchy/outfit/job/assistant
	job_description = "A Tourist could come from just about anywhere, they shouldn't be expected to understand the local customs."
	alt_titles = list("City Slicker" = /datum/alt_title/cityslick,
						"Visitor" = /datum/alt_title/visitor)

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

// Assistant Alt Titles
/datum/alt_title/cityslick
	title = "City Slicker"
	title_blurb = "A City Slicker visits Lonestar for a host of reasons. Maybe they're visiting someone, or maybe they have heard about good \
					savlage opportunities in the local area. A City Slicker has no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/cityslick

/datum/alt_title/visitor
	title = "Visitor"
	title_blurb = "A Visitor is anyone who has arrived at the facility from Lonestar itself, typically without any current assigned job. Many \
					off-duty crewmembers who care to make a trip to the station's other facilities arrive as Visitors. Properly registered \
					Vistors are considered to be part of the crew for most if not all purposes, but they have no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/visitor

/datum/alt_title/resident		// Just in case it makes a comeback
	title = "Resident"
	title_blurb = "A Resident is an individual who resides at or near , frequently in a different part of the station than what is seen. \
					They are considered to be part of the crew for most purposes, but have no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/resident
