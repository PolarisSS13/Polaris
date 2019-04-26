// Moved from /datum/preferences/proc/save_to_preferences()
/datum/category_item/player_setup_item/general/body/mob_to_save(var/mob/living/carbon/human/character)
	// Copy basic values
	pref.r_eyes = character.r_eyes
	pref.g_eyes = character.g_eyes
	pref.b_eyes = character.b_eyes
	pref.h_style = character.h_style
	pref.r_hair = character.r_hair
	pref.g_hair = character.g_hair
	pref.b_hair = character.b_hair
	pref.f_style = character.f_style
	pref.r_facial = character.r_facial
	pref.g_facial = character.g_facial
	pref.b_facial = character.b_facial
	pref.r_skin = character.r_skin
	pref.g_skin = character.g_skin
	pref.b_skin = character.b_skin
	pref.s_tone = character.s_tone
	pref.h_style = character.h_style
	pref.f_style = character.f_style
	pref.b_type = character.b_type
	pref.synth_color = character.synth_color
	pref.r_synth = character.r_synth
 	pref.g_synth = character.g_synth
	pref.b_synth = character.b_synth
  
	//might need code for saving tattoos. Hm.
  
proc/
