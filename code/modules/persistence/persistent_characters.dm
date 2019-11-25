// Moved from /datum/preferences/proc/save_to_preferences()
/mob/living/carbon/human/proc/save_mob_to_prefs()

	if(!config.canonicity) //if we're not canon in config or by gamemode, nothing will save.
		return 0

	if(!mind)
		return 0

	if(!unique_id)
		return 0

	if(!(unique_id == mind.prefs.unique_id))
		return 0

	var/var/datum/data/record/police_record = get_sec_record(src)
	var/var/datum/data/record/hospital_record = get_med_record(src)
	var/var/datum/data/record/employment_record = get_gen_record(src)


	//There's no way (that I know of) to edit the "real name" of a character unless
	//it's a body transformation, admin or antag fuckery. So this works.


	// Copy basic values
	mind.prefs.nickname = nickname
	mind.prefs.religion = religion //Maybe make features where people can change religion.

	//BODY
	//List of basic things we want saved.
	mind.prefs.biological_gender = gender
	mind.prefs.identifying_gender = identifying_gender

	mind.prefs.r_eyes = r_eyes
	mind.prefs.g_eyes = g_eyes
	mind.prefs.b_eyes = b_eyes
	mind.prefs.h_style = h_style
	mind.prefs.r_hair = r_hair
	mind.prefs.g_hair = g_hair
	mind.prefs.b_hair = b_hair
	mind.prefs.f_style = f_style
	mind.prefs.r_facial = r_facial
	mind.prefs.g_facial = g_facial
	mind.prefs.b_facial = b_facial
	mind.prefs.r_skin = r_skin
	mind.prefs.g_skin = g_skin
	mind.prefs.b_skin = b_skin
	mind.prefs.s_tone = s_tone
	mind.prefs.h_style = h_style
	mind.prefs.f_style = f_style
	mind.prefs.b_type = b_type
	mind.prefs.synth_color = synth_color
	mind.prefs.r_synth = r_synth
	mind.prefs.g_synth = g_synth
	mind.prefs.b_synth = b_synth
	mind.prefs.med_record = med_record
	mind.prefs.sec_record = sec_record
	mind.prefs.gen_record = gen_record
	mind.prefs.exploit_record = exploit_record
	mind.prefs.lip_style = lip_style
	mind.prefs.lip_color = lip_color
	mind.prefs.calories = calories
	mind.prefs.weight = calories_to_weight(calories)

	if(police_record)
		mind.prefs.crime_record = police_record.fields["crim_record"]
		mind.prefs.sec_record = police_record.fields["notes"]
		mind.prefs.criminal_status = police_record.fields["criminal"]

		mind.prefs.prison_date = police_record.fields["prison_date"]
		mind.prefs.prison_release_date = police_record.fields["prison_release_date"]

	if(hospital_record)
		mind.prefs.med_record = hospital_record.fields["notes"]

	if(employment_record)
		mind.prefs.gen_record = employment_record.fields["notes"]

	mind.prefs.existing_character = 1
	mind.prefs.played = 1
	//might need code for saving tattoos. Hm.
	save_character_money()

	mind.prefs.save_preferences()
	mind.prefs.save_character()

	return 1

/proc/handle_jail(var/mob/living/carbon/human/H)
	var/var/datum/data/record/police_record = get_sec_record(H)

	var/crim_statuses = list("*Arrest*", "Incarcerated")

	if(!police_record.fields["criminal"] in crim_statuses)
		return 0

	// If this returns 1, the character will have their criminal status changed and will be locked to the prison role next round.
	var/turf/location = get_turf(location)
	if(!location || !floor)
		return 0

	if(istype(location, /turf/simulated/shuttle)
		if(istype(floor, /turf/simulated/shuttle/floor4)) // Fails traitors if they are in the shuttle brig -- Polymorph
			if (!C.handcuffed)
				police_record.fields["criminal"] = "Incarcerated"



	var/area/check_area = location.loc
	if(istype(check_area, /area/shuttle/escape/centcom))
		return 1
	if(istype(check_area, /area/shuttle/escape_pod1/centcom))
		return 1
	if(istype(check_area, /area/shuttle/escape_pod2/centcom))
		return 1
	if(istype(check_area, /area/shuttle/escape_pod3/centcom))
		return 1
	if(istype(check_area, /area/shuttle/escape_pod5/centcom))
		return 1