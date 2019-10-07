/datum/job/chief_engineer
	title = "Fire Chief"
	flag = CHIEF
	faction = "City"
	head_position = 1
	department_flag = ENGSEC
	department = "City Council"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Mayor"
	selection_color = "#7F6E2C"
	idtype = /obj/item/weapon/card/id/engineering/head
	req_admin_notify = 1
	email_domain = "cityworks.gov.nt"
	wage = 330

	minimum_character_age = 30
	ideal_character_age = 50


	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload, access_medical, access_medical_equip)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload, access_medical, access_medical_equip)
	alt_titles = list("Batallion Chief","Fire Commissioner")
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/engineering/chief_engineer
/*
/datum/job/engineer
	title = "Firefighter"
	email_domain = "fire.cityworks.gov.nt"
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "City"
	department = "Emergency and Maintenance"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the fire chief"
	selection_color = "#5B4D20"
	idtype = /obj/item/weapon/card/id/engineering/engineer
	wage = 5
	access = list(access_engine, access_engine_equip, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)
	alt_titles = list("Firefighter/EMT")
	minimum_character_age = 18
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer
*/
/datum/job/atmos
	title = "Firefighter"
	email_domain = "cityworks.gov.nt"
	flag = ATMOSTECH
	department_flag = ENGSEC
	faction = "City"
	email_domain = "cityworks.gov.nt"
	department = "Emergency and Maintenance"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/weapon/card/id/engineering/atmos
	wage = 50
	access = list(access_engine, access_engine_equip, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)

	minimal_player_age = 3
	minimum_character_age = 18

	outfit_type = /decl/hierarchy/outfit/job/engineering/atmos

// Popping Paramedic In right here.

/datum/job/paramedic
	title = "Paramedic"
	email_domain = "cityworks.gov.nt"
	flag = PARAMEDIC
	department_flag = ENGSEC
	department = "Emergency and Maintenance"
	faction = "City"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the fire chief"
	selection_color = "#5B4D20"
	idtype = /obj/item/weapon/card/id/medical/paramedic
	wage = 80
	access = list(access_engine, access_engine_equip, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_construction, access_atmospherics, access_external_airlocks, access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/medical/paramedic
	alt_titles = list("Firefighter Medic" = /decl/hierarchy/outfit/job/medical/paramedic/emt)
