/datum/category_item/player_setup_item/general/equipment
	name = "Clothing"
	sort_order = 4

/datum/category_item/player_setup_item/general/equipment/load_character(var/savefile/S)
	S["underwear_top"]	>> pref.underwear_top
	S["underwear_bottom"]	>> pref.underwear_bottom
	S["undershirt"]	>> pref.undershirt
	S["socks"]		>> pref.socks
	S["backbag"]	>> pref.backbag
	S["pdachoice"]	>> pref.pdachoice

/datum/category_item/player_setup_item/general/equipment/save_character(var/savefile/S)
	S["underwear_top"]	<< pref.underwear_top
	S["underwear_bottom"] << pref.underwear_bottom
	S["undershirt"]	<< pref.undershirt
	S["socks"]		<< pref.socks
	S["backbag"]	<< pref.backbag
	S["pdachoice"]	<< pref.pdachoice

/datum/category_item/player_setup_item/general/equipment/sanitize_character()
	pref.backbag	= sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))
	pref.pdachoice	= sanitize_integer(pref.pdachoice, 1, pdachoicelist.len, initial(pref.pdachoice))

	if(!islist(pref.gear)) pref.gear = list()

	var/undies_top = get_undies_top()
	var/undies_bottom = get_undies_bottom()
	if(!get_key_by_value(undies_top, pref.underwear_top))
		pref.underwear_top = undies_top[1]
	if(!get_key_by_value(undies_bottom, pref.underwear_bottom))
		pref.underwear_bottom = undies_bottom[1]
	if(!get_key_by_value(undershirt_t, pref.undershirt))
		pref.undershirt = undershirt_t[1]
	if(!get_key_by_value(socks_t, pref.socks))
		pref.socks = socks_t[1]

/datum/category_item/player_setup_item/general/equipment/content()
	. += "<b>Equipment:</b><br>"
	. += "Underwear Top: <a href='?src=\ref[src];change_underwear_top=1'><b>[get_key_by_value(get_undies_top(),pref.underwear_top)]</b></a><br>"
	. += "Underwear Bottom: <a href='?src=\ref[src];change_underwear_bottom=1'><b>[get_key_by_value(get_undies_bottom(),pref.underwear_bottom)]</b></a><br>"
	. += "Undershirt: <a href='?src=\ref[src];change_undershirt=1'><b>[get_key_by_value(undershirt_t,pref.undershirt)]</b></a><br>"
	. += "Socks: <a href='?src=\ref[src];change_socks=1'><b>[get_key_by_value(socks_t,pref.socks)]</b></a><br>"
	. += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[pref.backbag]]</b></a><br>"
	. += "PDA Type: <a href='?src=\ref[src];change_pda=1'><b>[pdachoicelist[pref.pdachoice]]</b></a><br>"

/datum/category_item/player_setup_item/general/equipment/proc/get_undies_top()
	return underwear_top_t
/datum/category_item/player_setup_item/general/equipment/proc/get_undies_bottom()
	return underwear_bottom_t

/datum/category_item/player_setup_item/general/equipment/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_underwear_top"])
		var/underwear_top_options = get_undies_top()
		var/new_underwear_top = input(user, "Choose your character's top underwear:", "Character Preference", get_key_by_value(get_undies_top(),pref.underwear_top)) as null|anything in underwear_top_options
		if(!isnull(new_underwear_top) && CanUseTopic(user))
			pref.underwear_top = underwear_top_options[new_underwear_top]
			return TOPIC_REFRESH

	else if(href_list["change_underwear_bottom"])
		var/underwear_bottom_options = get_undies_bottom()
		var/new_underwear_bottom = input(user, "Choose your character's bottom underwear:", "Character Preference", get_key_by_value(get_undies_bottom(),pref.underwear_bottom)) as null|anything in underwear_bottom_options
		if(!isnull(new_underwear_bottom) && CanUseTopic(user))
			pref.underwear_bottom = underwear_bottom_options[new_underwear_bottom]
			return TOPIC_REFRESH

	else if(href_list["change_undershirt"])
		var/new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference", get_key_by_value(undershirt_t,pref.undershirt)) as null|anything in undershirt_t
		if(!isnull(new_undershirt) && CanUseTopic(user))
			pref.undershirt = undershirt_t[new_undershirt]
			return TOPIC_REFRESH

	else if(href_list["change_socks"])
		var/new_socks = input(user, "Choose your character's socks:", "Character Preference", get_key_by_value(socks_t,pref.socks)) as null|anything in socks_t
		if(!isnull(new_socks) && CanUseTopic(user))
			pref.socks = socks_t[new_socks]
			return TOPIC_REFRESH

	else if(href_list["change_backpack"])
		var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference", backbaglist[pref.backbag]) as null|anything in backbaglist
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH

	else if(href_list["change_pda"])
		var/new_pdachoice = input(user, "Choose your character's style of PDA:", "Character Preference", pdachoicelist[pref.pdachoice]) as null|anything in pdachoicelist
		if(!isnull(new_pdachoice) && CanUseTopic(user))
			pref.pdachoice = pdachoicelist.Find(new_pdachoice)
			return TOPIC_REFRESH
	return ..()
