/datum/job/hos
	title = "Chief of Police"
	flag = HOS
	faction = "City"
	department = "Security"
	department_flag = ENGSEC
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Mayor"
	selection_color = "#8E2929"
	idtype = /obj/item/weapon/card/id/security/head
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_security, access_warrant, access_bodyguard, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_warrant, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimum_character_age = 30
	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/security/hos
	alt_titles = list("Head of Police", "Police Commander", "Police Commissioner")

/datum/job/warden
	title = "Prison Warden"
	flag = WARDEN
	faction = "City"
	department = "Security"
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief of police"
	selection_color = "#601C1C"
	idtype = /obj/item/weapon/card/id/security/warden
	economic_modifier = 5
	access = list(access_security, access_bodyguard, access_warrant, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_warrant, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 5
	minimum_character_age = 28

	outfit_type = /decl/hierarchy/outfit/job/security/warden
	alt_titles = list("Correctional Officer")

/datum/job/detective
	title = "Detective"
	flag = DETECTIVE
	faction = "City"
	department = "Security"
	department_flag = ENGSEC
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief of police"
	selection_color = "#601C1C"
	idtype = /obj/item/weapon/card/id/security/detective
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks, access_medical)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks)
	economic_modifier = 5
	minimal_player_age = 3
	minimum_character_age = 25

	outfit_type = /decl/hierarchy/outfit/job/security/detective
	alt_titles = list("Forensic Technician" = /decl/hierarchy/outfit/job/security/detective/forensic, "Investigator")

/datum/job/officer
	title = "Police Officer"
	flag = OFFICER
	faction = "City"
	department = "Security"
	department_flag = ENGSEC
	total_positions = 8
	spawn_positions = 8
	supervisors = "the chief of police"
	selection_color = "#601C1C"
	idtype = /obj/item/weapon/card/id/security/officer
	economic_modifier = 4
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 3
	minimum_character_age = 23

	outfit_type = /decl/hierarchy/outfit/job/security/officer
	alt_titles = list("Police Cadet","Traffic Warden" = /decl/hierarchy/outfit/job/security/traffic)

/datum/job/prosecutor
	title = "District Prosecutor"
	flag = PROSECUTOR
	faction = "City"
	department = "Security"
	department_flag = ENGSEC
	total_positions = 2
	spawn_positions = 2
	req_admin_notify = 1
	supervisors = "the chief of police and city clerk"
	selection_color = "#601C1C"
	idtype = /obj/item/weapon/card/id/security/prosecutor
	economic_modifier = 7
	access = list(access_prosecutor, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_prosecutor, access_sec_doors, access_heads)
//	minimal_player_age = 7 (need more prostitut-- prosecutors.)
	minimum_character_age = 21
	alt_titles = list("Prosecutor","Prosecuting Attorney","Prosecution Officer","Prosecuting Lawyer")

	outfit_type = /decl/hierarchy/outfit/job/prosecution

/datum/job/bguard
	title = "City Hall Guard"
	flag = BRIDGE
	department = "Security"
	department_flag = ENGSEC
	faction = "City"
	total_positions = 2
	spawn_positions = 3
	supervisors = "the mayor or the judge"
	selection_color = "#601C1C"
	idtype = /obj/item/weapon/card/id/silver/secretary
	minimal_player_age = 5
	economic_modifier = 7
	minimum_character_age = 25
	access = list(access_heads, access_bodyguard, access_keycard_auth, access_security, access_sec_doors)
	minimal_access = list(access_heads, access_bodyguard, access_keycard_auth, access_security, access_sec_doors)

	outfit_type = /decl/hierarchy/outfit/job/heads/secretary
	alt_titles = list("Council Bodyguard", "City Hall Security", "Bailiff")
