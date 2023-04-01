//////////////////////////////////
//		Head of Security
//////////////////////////////////
/datum/job/hos
	title = "Sheriff"
	flag = HOS
	departments_managed = list(DEPARTMENT_SECURITY)
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron, the Steward and Lonestar Law"
	selection_color = "#8E2929"
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_pest, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_pest, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimum_character_age = 25
	min_age_by_species = list(SPECIES_HUMAN_VATBORN = 14)
	minimal_player_age = 14
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_VOX, SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital", SPECIES_UNATHI, "mechanical")

	outfit_type = /decl/hierarchy/outfit/job/security/sheriff
	job_description = "	The Sheriff is the primary peace keeper of the station, ensuring the population is safe from threats both external and internal. They are \
						expected to keep the other Department Heads, and the rest of the crew, aware of developing situations that may be a threat. If necessary, \
						the Sheriff may deputize members of the crew to preform duties of absent Security roles, but only in dire situations."
	alt_titles = list("Sheriff's Sergeant" = /datum/alt_title/sheriff_serg, "Chief of Security" = /datum/alt_title/sec_chief)

// Head of Security Alt Titles
/datum/alt_title/sheriff_serg
	title = "Sheriff's Sergeant"

/datum/alt_title/sec_chief
	title = "Chief of Security"

//////////////////////////////////
//			Warden
//////////////////////////////////
/datum/job/warden
	title = "Warden"
	flag = WARDEN
	departments = list(DEPARTMENT_SECURITY)
	sorting_order = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Prison Baron, the Marshal and Lonestar Law"
	selection_color = "#601C1C"
	economic_modifier = 5
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 5
	banned_job_species = list(SPECIES_VOX, SPECIES_ZADDAT, SPECIES_TESHARI, SPECIES_DIONA)

	min_age_by_species = list(SPECIES_PROMETHEAN = 8)


	outfit_type = /decl/hierarchy/outfit/job/security/warden
	job_description = "The Warden watches over the Lonestar Facility: the Slammer. Their task is making sure the brig is in order at all times. They oversee \
						prisoners that have been processed and brigged, and are responsible for inmate productivity. The Warden should also remember to keep \
						their prisoners alive and in under watchful eye, as most convict redemption activities involve extra vehicular activity where a crafty \
						or cunning prisoner could escape."

/*
//////////////////////////////////
//			Detective
//////////////////////////////////
/datum/job/detective
	title = "Prison Guard"
	flag = DETECTIVE
	departments = list(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Prison Baron, the Warden and Lonestar Law"
	selection_color = "#601C1C"
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks)
	economic_modifier = 5
	minimal_player_age = 3

	outfit_type = /decl/hierarchy/outfit/job/security/detective
	job_description = "A Prison Guard works to help the Warden keep prisoners in line and working towards their fiscal freedom. Making sure prisoners return \
						with loads of goods by directly overseeing them as they work in harsh space environments falls under some of their direct duties, as \
						well as keeping those same working prisoners alive and safe while they work."

*/

//////////////////////////////////
//		Security Officer
//////////////////////////////////
/datum/job/officer
	title = "Deputy"
	flag = OFFICER
	departments = list(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the Sheriff"
	selection_color = "#601C1C"
	economic_modifier = 4
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 3
	banned_job_species = list(SPECIES_VOX, SPECIES_ZADDAT, SPECIES_TESHARI, SPECIES_DIONA)

	outfit_type = /decl/hierarchy/outfit/job/security/officer

	outfit_type = /decl/hierarchy/outfit/job/security/officer
	job_description = "A Deputy is concerned with maintaining the safety and security of the station as a whole, dealing with external threats and \
						apprehending criminals. A Deputy is responsible for the health, safety, and processing of any prisoner they arrest. \
						No one is above the Law, not Security or Command."
	alt_titles = list("Exchange Officer" = /datum/alt_title/exchange_officer, "Forensic Technician" = /datum/alt_title/forensic_tech)

// Security Officer Alt Titles
/datum/alt_title/exchange_officer
	title = "Exchange Officer"
	title_blurb = "An Exchange Officer is inexperienced in the ways of Lonestar, being that they come from off station.. They likely have training, \
					but not the relevant knowledge of the area, and are frequently paired off with a helpful deputy or other officer. Exchange Officers \
					are are typically not permanently stationed at any given facility on Lonestar, though they can request this."

/datum/alt_title/forensic_tech
	title = "Forensic Technician"
	title_blurb = "A Forensic Technician works more with hard evidence and labwork than a Deputy, but they share the purpose of solving crimes."
	title_outfit = /decl/hierarchy/outfit/job/security/forensic