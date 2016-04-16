/datum/category_item/player_setup_item/general/eros
	name = "Erotic"
	sort_order = 7

/datum/category_item/player_setup_item/general/eros/load_character(var/savefile/S)
	S["c_type"]				>> pref.c_type
	S["d_type"]				>> pref.d_type
	S["v_type"]				>> pref.v_type
	S["r_genital"]			>> pref.r_genital
	S["g_genital"]			>> pref.g_genital
	S["b_genital"]			>> pref.b_genital
	S["ears_type"]			>> pref.ears_type
	S["wings_type"]			>> pref.wings_type
	S["tail_type"]			>> pref.tail_type

/datum/category_item/player_setup_item/general/eros/save_character(var/savefile/S)
	S["c_type"]				<< pref.c_type
	S["d_type"]				<< pref.d_type
	S["v_type"]				<< pref.v_type
	S["r_genital"]			<< pref.r_genital
	S["g_genital"]			<< pref.g_genital
	S["b_genital"]			<< pref.b_genital
	S["ears_type"]			<< pref.ears_type
	S["wings_type"]			<< pref.wings_type
	S["tail_type"]			<< pref.tail_type

/datum/category_item/player_setup_item/general/eros/sanitize_character(var/savefile/S)
	pref.c_type			= sanitize_inlist(pref.c_type, body_breast_list, initial(pref.c_type))
	pref.d_type			= sanitize_inlist(pref.d_type, body_dicks_list, initial(pref.d_type))
	pref.v_type			= sanitize_inlist(pref.v_type, body_vaginas_list, initial(pref.v_type))
	pref.r_genital		= sanitize_integer(pref.r_genital, 0, 255, initial(pref.r_genital))
	pref.g_genital		= sanitize_integer(pref.g_genital, 0, 255, initial(pref.g_genital))
	pref.b_genital		= sanitize_integer(pref.b_genital, 0, 255, initial(pref.b_genital))
	pref.ears_type		= sanitize_inlist(pref.ears_type, body_ears_list, initial(pref.ears_type))
	pref.wings_type		= sanitize_inlist(pref.wings_type, body_wings_list, initial(pref.wings_type))
	pref.tail_type		= sanitize_inlist(pref.tail_type, body_tails_list, initial(pref.tail_type))


/datum/category_item/player_setup_item/general/eros/content(var/mob/user)
	pref.update_preview_icon()
	if(pref.preview_icon_front && pref.preview_icon_side)
		user << browse_rsc(pref.preview_icon_front, "preview_icon.png")
		user << browse_rsc(pref.preview_icon_side, "preview_icon2.png")

	. += "<table><tr style='vertical-align:top'><td><b>Sexual Preferences</b> "
	. += "<br>"
	. += "Chest Type: <a href='?src=\ref[src];chest_type=1'>[pref.c_type]</a><br>"
	. += "Dick Type: <a href='?src=\ref[src];dick_type=1'>[pref.d_type]</a><br>"
	. += "Vagina Type: <a href='?src=\ref[src];vagina_type=1'>[pref.v_type]</a><br>"
	. += "<br><b>Genitals Color</b><br>"
	. += "<a href='?src=\ref[src];genital_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_genital, 2)][num2hex(pref.g_genital, 2)][num2hex(pref.b_genital, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_genital, 2)][num2hex(pref.g_genital, 2)][num2hex(pref.b_genital)]'><tr><td>__</td></tr></table></font><br>"
	. += "Ears Type: <a href='?src=\ref[src];cears_type=1'>[pref.ears_type]</a><br>"
	. += "Wings Type: <a href='?src=\ref[src];cwings_type=1'>[pref.wings_type]</a><br>"
	. += "Tail Type: <a href='?src=\ref[src];ctail_type=1'>[pref.tail_type]</a><br>"


/datum/category_item/player_setup_item/general/eros/OnTopic(var/href,var/list/href_list, var/mob/user)


	if(href_list["chest_type"])
		var/new_c_type = input(user, "Choose your character's Chest Type:", "Character Preference") as null|anything in body_breast_list
		if(new_c_type && CanUseTopic(user))
			pref.c_type = new_c_type
			return TOPIC_REFRESH

	else if(href_list["dick_type"])
		var/new_d_type = input(user, "Choose your character's Dick:", "Character Preference") as null|anything in body_dicks_list
		if(new_d_type && CanUseTopic(user))
			pref.d_type = new_d_type
			return TOPIC_REFRESH

	else if(href_list["vagina_type"])
		var/new_v_type = input(user, "Choose your character's Vagina:", "Character Preference") as null|anything in body_vaginas_list
		if(new_v_type && CanUseTopic(user))
			pref.v_type = new_v_type
			return TOPIC_REFRESH

	else if(href_list["genital_color"])
		var/new_genital = input(user, "Choose your character's genital colour: ", "Character Preference", rgb(pref.r_genital, pref.g_genital, pref.b_genital)) as color|null
		pref.r_genital = hex2num(copytext(new_genital, 2, 4))
		pref.g_genital = hex2num(copytext(new_genital, 4, 6))
		pref.b_genital = hex2num(copytext(new_genital, 6, 8))
		return TOPIC_REFRESH

	else if(href_list["cears_type"])
		var/new_ears_type = input(user, "Choose your character's Ears:", "Character Preference") as null|anything in body_ears_list
		if(new_ears_type && CanUseTopic(user))
			pref.ears_type = new_ears_type
			return TOPIC_REFRESH

	else if(href_list["cwings_type"])
		var/new_wings_type = input(user, "Choose your character's Wings:", "Character Preference") as null|anything in body_wings_list
		if(new_wings_type && CanUseTopic(user))
			pref.wings_type = new_wings_type
			return TOPIC_REFRESH

	else if(href_list["ctail_type"])
		var/new_tail_type = input(user, "Choose your character's Tail:", "Character Preference") as null|anything in body_tails_list
		if(new_tail_type && CanUseTopic(user))
			pref.tail_type = new_tail_type
			return TOPIC_REFRESH