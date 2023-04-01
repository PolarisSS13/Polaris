//////////////////////////////////
//		Chief Medical Officer
//////////////////////////////////
/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	departments_managed = list(DEPARTMENT_MEDICAL)
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_COMMAND)
	sorting_order = 3
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Steward, the Surgeon General, and their oath to Lonestar"
	selection_color = "#026865"
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels)

	minimum_character_age = 25
	min_age_by_species = list(SPECIES_UNATHI = 70, "mechanical" = 10, SPECIES_HUMAN_VATBORN = 14)
	minimal_player_age = 10
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_UNATHI = 140, "mechanical" = 20, SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_VOX, SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital")


	outfit_type = /decl/hierarchy/outfit/job/medical/cmo
	job_description = "The CMO manages the Medical department and is a position requiring experience and skill; their goal is to ensure that their \
						staff keep the station's crew healthy and whole. They are primarily interested in making sure that patients are safely found and \
						transported to Medical for treatment. They are expected to keep the crew informed about threats to their health and safety, and \
						about the importance of Suit Sensors."

//////////////////////////////////
//		Medical Doctor
//////////////////////////////////
/datum/job/doctor
	title = "Medical Officer"
	flag = DOCTOR
	departments = list(DEPARTMENT_MEDICAL)
	sorting_order = 2
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 6
	spawn_positions = 3
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	economic_modifier = 7
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_eva, access_operations, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology, access_eva)
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor
	job_description = "A Medical Officer is a Jack-of-All-Trades Medical title, covering a variety of skill levels and minor specializations. They are likely \
						familiar with basic first aid, and a number of accompanying medications, and can generally save, if not cure, a majority of the \
						patients they encounter. In some cases a Medical Officer will be required to lead Commandos into the field."
	alt_titles = list(
					"Surgeon" = /datum/alt_title/surgeon,
					"Nurse" = /datum/alt_title/nurse,
					"Virologist" = /datum/alt_title/virologist,
					"Pharmacy Officer" = /datum/alt_title/pharmacy_officer)

	min_age_by_species = list(SPECIES_PROMETHEAN = 3)

//Medical Doctor Alt Titles
/datum/alt_title/surgeon
	title = "Surgical Officer"
	title_blurb = "A Surgical Officer specializes in providing surgical aid to injured patients, up to and including amputation and limb reattachement. They \
					are expected to know the ins and outs of anesthesia and surgery."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/surgeon

/datum/alt_title/nurse
	title = "Nurse"
	title_blurb = "A Nurse acts as a general purpose Doctor's Aide, providing basic care to non-critical patients, and stabilizing critical patients during \
					busy periods. They frequently watch the suit sensors console, to help manage the time of other Doctors. In rare occasions, a Nurse can be \
					called upon to revive deceased crew members."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/nurse

/datum/alt_title/virologist
	title = "Virologist"
	title_blurb = "A Virologist cures active diseases in the crew, and prepares antibodies for possible infections. They also have the skills \
					to produce the various types of virus foods or mutagens."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/virologist

/datum/alt_title/pharmacy_officer
	title = "Pharmacy Officer"
	title_blurb = "A Pharmacy Officer focuses on the chemical needs of the Medical Department, and often offers to fill crew prescriptions at their discretion."

//////////////////////////////////
//			Chemist
//////////////////////////////////
/*
/datum/job/chemist
	title = "Medical Cadet"
	flag = CHEMIST
	departments = list(DEPARTMENT_MEDICAL)
	sorting_order = 1
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	economic_modifier = 5
	access = list(access_operations, access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_operations, access_medical, access_medical_equip, access_chemistry)
	minimal_player_age = 3

	outfit_type = /decl/hierarchy/outfit/job/medical/cadet
	job_description = "A Medical Cadet is much like an intern. However, in Lonestar it is felt that the best training takes place on the front lines. \
						To that end, Medical Cadets can often be found trailing groups of Lonestar Commandos as they head toward their missions. "
*/
/* I'm commenting out Geneticist so you can't actually see it in the job menu, given that you can't play as one - Jon.
//////////////////////////////////
//			Geneticist
//////////////////////////////////
/datum/job/geneticist
	title = "Geneticist"
	flag = GENETICIST
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Chief Medical Officer and Research Director"
	selection_color = "#013D3B"
	economic_modifier = 7
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_research)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)

	outfit_type = /decl/hierarchy/outfit/job/medical/geneticist
	job_description = "A Geneticist operates genetic manipulation equipment to repair any genetic defects encountered in crew, from cloning or radiation as examples. \
						When required, geneticists have the skills to clone, and are the superior choice when available for doing so."


//////////////////////////////////
//			Psychiatrist
//////////////////////////////////
/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = PSYCHIATRIST
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	access = list(access_medical, access_medical_equip, access_morgue, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist
	job_description = "A Psychiatrist provides mental health services to crew members in need. They may also be called upon to determine whatever \
					ails the mentally unwell, frequently under Security supervision. They understand the effects of various psychoactive drugs."
	alt_titles = list("Psychologist" = /datum/alt_title/psychologist)

//Psychiatrist Alt Titles
/datum/alt_title/psychologist
	title = "Psychologist"
	title_blurb =  "A Psychologist provides mental health services to crew members in need, focusing more on therapy than medication. They may also be \
					called upon to determine whatever ails the mentally unwell, frequently under Security supervision."
	title_outfit = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist
*/
//////////////////////////////////
//			Paramedic
//////////////////////////////////
/datum/job/paramedic
	title = "Commando"
	flag = PARAMEDIC
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	economic_modifier = 4
	access = list(access_medical, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks, access_operations)
	minimal_access = list(access_medical, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks, access_operations)
	outfit_type = /decl/hierarchy/outfit/job/medical/commando
	job_description = "Lonestar Station Defense Commandos are primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their own. \
						They are also likely be called upon in case of an attack on the facility they are stationed on, or to bolster the ranks of other departments to serve as \
						needed. The CMO may also decide to assign commandos to an away mission. Remember, most medical staff are considered your ranking officers."
	banned_job_species = list(SPECIES_VOX, SPECIES_DIONA)

	min_age_by_species = list(SPECIES_PROMETHEAN = 2)

