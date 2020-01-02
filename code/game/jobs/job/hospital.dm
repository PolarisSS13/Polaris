/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	head_position = 1
	department_flag = MEDSCI
	department = "City Council"
	faction = "City"
	total_positions = 1
	spawn_positions = 1
	email_domain = "med.gov.nt"
	supervisors = "the Mayor"
	selection_color = "#026865"
	idtype = /obj/item/weapon/card/id/medical/head
	req_admin_notify = 1
	wage = 540
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels)

	minimum_character_age = 30
	minimal_player_age = 3
	ideal_character_age = 50

	outfit_type = /decl/hierarchy/outfit/job/medical/cmo
	alt_titles = list(
		"Chief of Medicine", "Medical Director")

/datum/job/cmo/get_job_email()	// whatever this is set to will be the job's communal email. should be persistent.
	return using_map.council_email

/datum/job/doctor
	title = "Doctor"
	email_domain = "med.gov.nt"
	flag = DOCTOR
	department_flag = MEDSCI
	department = "Public Healthcare"
	faction = "City"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#013D3B"
	idtype = /obj/item/weapon/card/id/medical/doctor
	wage = 80
	minimum_character_age = 25
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_eva)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology, access_eva)
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor
	alt_titles = list(
		"Surgeon" = /decl/hierarchy/outfit/job/medical/doctor/surgeon,
		"Emergency Physician" = /decl/hierarchy/outfit/job/medical/doctor/emergency_physician,
		"Nurse" = /decl/hierarchy/outfit/job/medical/doctor/nurse)

//Chemist is a medical job damnit	//YEAH FUCK YOU SCIENCE	-Pete	//Guys, behave -Erro // Chemistry does more actual science than RnD at this point. But I'm glad you took time to bicker about which file it should go in instead of properly organizing the parenting. - Nappist
/datum/job/chemist
	email_domain = "med.gov.nt"
	title = "Chemist"
	flag = CHEMIST
	department = "Public Healthcare"
	department_flag = MEDSCI
	faction = "City"
	total_positions = 2
	spawn_positions = 2
	minimum_character_age = 25
	supervisors = "the chief medical officer"
	selection_color = "#013D3B"
	idtype = /obj/item/weapon/card/id/medical/chemist
	wage = 60
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology)
	minimal_access = list(access_medical, access_medical_equip, access_chemistry)
	alt_titles = list("Pharmacist")

	minimal_player_age = 3

	outfit_type = /decl/hierarchy/outfit/job/medical/chemist

/datum/job/geneticist
	title = "Geneticist"
	flag = GENETICIST
	department = "Civilian"
	department_flag = MEDSCI
//	faction = "City"
	total_positions = 0
	spawn_positions = 0
	supervisors = "your private company director"
	selection_color = "#013D3B"
	idtype = /obj/item/weapon/card/id/medical/geneticist
	wage = 60
	access = list(access_genetics)
	minimal_access = list(access_genetics)

	outfit_type = /decl/hierarchy/outfit/job/medical/geneticist


/datum/job/psychiatrist
	title = "Psychiatrist"
	email_domain = "med.gov.nt"
	flag = PSYCHIATRIST
	department_flag = MEDSCI
	department = "Public Healthcare"
	faction = "City"
	total_positions = 4
	spawn_positions = 1
	wage = 40
	minimum_character_age = 25
	supervisors = "the chief medical officer"
	selection_color = "#013D3B"
	idtype = /obj/item/weapon/card/id/medical/psychiatrist
	access = list(access_medical, access_medical_equip, access_morgue, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist
	alt_titles = list("Daycare Worker", "Therapist", "Social Worker", "Psychologist" = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist)


/datum/job/medicalintern
	title = "Medical Intern"
	flag = MEDICALINTERN
	department_flag = MEDSCI
	email_domain = "med.gov.nt"
	department = "Public Healthcare"
	faction = "City"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#013D3B"
	idtype = /obj/item/weapon/card/id/medical/intern
	wage = 26
	minimum_character_age = 18 //Excuse me electric, what.
	access = list(access_medical)
	minimal_access = list(access_medical, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/medical/intern
