// Moved from /datum/preferences/proc/save_to_preferences()
/mob/living/carbon/human/proc/save_mob_to_prefs()

	if(!config.canonicity) //if we're not canon in config or by gamemode, nothing will save.
		return 0

	if(!client)
		return 0
	//Eh, no way to go around this right now, if someone DCs their character doesn't get saved,
	//Because we can't access their client. Might find another method in future. This'll do.

	if(!real_name == client.prefs.real_name)
		return 0
	//There's no way (that I know of) to edit the "real name" of a character unless
	//it's a body transformation or antag fuckery. So this works.

	// Copy basic values
	client.prefs.nickname = nickname
	client.prefs.religion = religion //Maybe make features where people can change religion.

	//BODY

	client.prefs.biological_gender = gender
	client.prefs.identifying_gender = identifying_gender

	client.prefs.r_eyes = r_eyes
	client.prefs.g_eyes = g_eyes
	client.prefs.b_eyes = b_eyes
	client.prefs.h_style = h_style
	client.prefs.r_hair = r_hair
	client.prefs.g_hair = g_hair
	client.prefs.b_hair = b_hair
	client.prefs.f_style = f_style
	client.prefs.r_facial = r_facial
	client.prefs.g_facial = g_facial
	client.prefs.b_facial = b_facial
	client.prefs.r_skin = r_skin
	client.prefs.g_skin = g_skin
	client.prefs.b_skin = b_skin
	client.prefs.s_tone = s_tone
	client.prefs.h_style = h_style
	client.prefs.f_style = f_style
	client.prefs.b_type = b_type
	client.prefs.synth_color = synth_color
	client.prefs.r_synth = r_synth
	client.prefs.g_synth = g_synth
	client.prefs.b_synth = b_synth
	client.prefs.med_record = med_record
	client.prefs.sec_record = sec_record
	client.prefs.gen_record = gen_record
	client.prefs.exploit_record = exploit_record

	//might need code for saving tattoos. Hm.

	client.prefs.save_preferences()
	client.prefs.save_character()

	return 1

proc/save_all_characters()
	if(!config.canonicity) //if we're not canon in config or by gamemode, nothing will save.
		return 0

	for (var/mob/living/carbon/human/H in mob_list) //only humans, we don't really save AIs or robots.
		if(!H.client)
			return 0

		H.save_mob_to_prefs()
		return 1


