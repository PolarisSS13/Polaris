/datum/job/nanotrasen
	title = "Nanotrasen Representative"
	flag = NANOTRASEN
	department = "City Council"
	head_position = 0
	department_flag = GOVLAW
	faction = "City"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the NanoTrasen CEO"
	selection_color = "#0F0F6F"
	idtype = /obj/item/weapon/card/id/nanotrasen/ntrep
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

	outfit_type = /decl/hierarchy/outfit/job/nanotrasen/representative

	alt_titles = list("Nanotrasen Security" = /decl/hierarchy/outfit/job/nanotrasen/guard,
                      "Nanotrasen Officer" = /decl/hierarchy/outfit/job/nanotrasen/officer)
	email_domain = "nanotrasen.gov.nt"
	wage = 1000
	minimum_character_age = 25 // Pushing it I guess, but possible
	ideal_character_age = 40
	req_admin_notify = 1

	hard_whitelisted = 1

/datum/job/nanotrasen/get_job_email()	// whatever this is set to will be the job's communal email. should be persistent.
	return using_map.rep_email

/datum/job/nanotrasen/New()
	..()
	department = "[station_name()] Funds"


/datum/job/nanotrasen/get_access()
	return get_all_centcom_access()

/datum/job/nanotrasen/ceo
	title = "NanoTrasen Sector Administrator"
	total_positions = 1
	spawn_positions = 1
	flag = CEO
	alt_titles = list("NanoTrasen Regional Director", "NanoTrasen CEO", "NanoTrasen COO")
	wage = 10000
	outfit_type = /decl/hierarchy/outfit/job/nanotrasen/captain
	idtype = /obj/item/weapon/card/id/nanotrasen/ceo
	minimum_character_age = 30

/datum/job/nanotrasen/cbia
	title = "PDSI Agent"
	flag = CBIA
	alt_titles = list("PDSI Director")
	department = "City Council"
	head_position = 0
	department_flag = GOVLAW
	faction = "City"
	total_positions = -1
	spawn_positions = -1
	supervisors = "NanoTrasen"
	selection_color = "#0F0F6F"
	idtype = /obj/item/weapon/card/id/nanotrasen/cbia
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	alt_titles = list()

	email_domain = "nanotrasen.gov.nt"
	outfit_type = /decl/hierarchy/outfit/job/nanotrasen/cbia

	wage = 1000
	minimum_character_age = 25 // Pushing it I guess, but possible
	ideal_character_age = 40
	req_admin_notify = 1

/datum/job/nanotrasen/cbia/get_job_email()	// whatever this is set to will be the job's communal email. should be persistent.
	return using_map.investigation_email

/datum/job/nanotrasen/president
	title = "President"
	flag = PRESIDENT
	head_position = 1
	department_flag = GOVLAW
	faction = "City"
	total_positions = 1
	spawn_positions = 1
	supervisors = "NanoTrasen"
	selection_color = "#1D1D4F"
	idtype = /obj/item/weapon/card/id/nanotrasen/president
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	email_domain = "nanotrasen.gov.nt"
	wage = 9000
	alt_titles = list()

	minimum_character_age = 30
	ideal_character_age = 50
	outfit_type = /decl/hierarchy/outfit/job/heads/president


/datum/job/nanotrasen/president/get_job_email()	// whatever this is set to will be the job's communal email. should be persistent.
	return using_map.president_email