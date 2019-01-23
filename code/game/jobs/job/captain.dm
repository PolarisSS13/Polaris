var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/heads/ // this is just for grabbing all of them at once

/datum/job/heads/captain
	title = "Mayor"
	flag = CAPTAIN
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "government officials and the president"
	selection_color = "#1D1D4F"
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	minimum_character_age = 30
	ideal_character_age = 50 // Old geezer captains ftw // Get your MILF/DILF fetish out of here

	outfit_type = /decl/hierarchy/outfit/job/heads/captain
//	alt_titles = list("Site Manager", "Overseer")

/*
/datum/job/heads/captain/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(src)
*/
/datum/job/heads/captain/get_access()
	return get_all_station_access()

/datum/job/heads/president
	title = "President"
	flag = PRESIDENT
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "NanoTrasen"
	selection_color = "#1D1D4F"
	idtype = /obj/item/weapon/card/id/centcom/station/president
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 40

	minimum_character_age = 30
	ideal_character_age = 50
	outfit_type = /decl/hierarchy/outfit/job/heads/president

/datum/job/heads/president/get_access()
	get_all_station_access()
	get_all_centcom_access()
	return


/datum/job/heads/hop
	title = "City Clerk"
	flag = HOP
	department = "Command"
	head_position = 1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Mayor"
	selection_color = "#2F2F7F"
	idtype = /obj/item/weapon/card/id/silver/hop
	req_admin_notify = 1
	minimal_player_age = 10
	economic_modifier = 10

	minimum_character_age = 25
	ideal_character_age = 40

	outfit_type = /decl/hierarchy/outfit/job/heads/hop

	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)

/datum/job/heads/judge
	title = "Judge"
	flag = JUDGE
	total_positions = 1
	spawn_positions = 1
	supervisors = "government officials and the President"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/heads/judge
	economic_modifier = 13
	access = list(access_judge, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_judge, access_sec_doors, access_heads)
	minimal_player_age = 7
	minimum_character_age = 25
	alt_titles = list("Magistrate")

	outfit_type = /decl/hierarchy/outfit/job/heads/judge


/datum/job/heads/secretary
	title = "City Hall Guard"
	flag = BRIDGE
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the mayor or the judge"
	selection_color = "#2F2F7F"
	idtype = /obj/item/weapon/card/id/silver/secretary
	minimal_player_age = 5
	economic_modifier = 7
	minimum_character_age = 20

	access = list(access_heads, access_keycard_auth, access_security, access_sec_doors)
	minimal_access = list(access_heads, access_keycard_auth, access_security, access_sec_doors)

	outfit_type = /decl/hierarchy/outfit/job/heads/secretary
	alt_titles = list("Public Bodyguard", "City Hall Security", "Bailiff")
