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
	mind.prefs.existing_character = 1
	mind.prefs.played = 1
	//might need code for saving tattoos. Hm.
	save_character_money()

	mind.prefs.save_preferences()
	mind.prefs.save_character()

	return 1

