/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 3

/datum/category_item/player_setup_item/general/background/load_character(var/savefile/S)
	S["med_record"]				>> pref.med_record
	S["sec_record"]				>> pref.sec_record
	S["gen_record"]				>> pref.gen_record
	S["home_system"]			>> pref.home_system
	S["citizenship"]			>> pref.citizenship
//	S["faction"]				>> pref.faction
	S["religion"]				>> pref.religion
	S["economic_status"]		>> pref.economic_status

/datum/category_item/player_setup_item/general/background/save_character(var/savefile/S)
	S["med_record"]				<< pref.med_record
	S["sec_record"]				<< pref.sec_record
	S["gen_record"]				<< pref.gen_record
	S["home_system"]			<< pref.home_system
	S["citizenship"]			<< pref.citizenship
//	S["faction"]				<< pref.faction
	S["religion"]				<< pref.religion
	S["economic_status"]		<< pref.economic_status

/datum/category_item/player_setup_item/general/background/delete_character(var/savefile/S)
	pref.med_record = null
	pref.sec_record = null
	pref.gen_record = null
	pref.home_system = null
	pref.citizenship = null
	pref.faction = null
	pref.religion = null
	pref.economic_status = null

/datum/category_item/player_setup_item/general/background/sanitize_character()
	if(!pref.home_system) pref.home_system = "Unset"
	if(!pref.citizenship) pref.citizenship = "None"
//	if(!pref.faction)     pref.faction =     "None"
	if(!pref.religion)    pref.religion =    "None"

	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_CLASS, initial(pref.economic_status))

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/background/copy_to_mob(var/mob/living/carbon/human/character)
	character.med_record		= pref.med_record
	character.sec_record		= pref.sec_record
	character.gen_record		= pref.gen_record
	character.home_system		= pref.home_system
	character.citizenship		= pref.citizenship
	character.personal_faction	= pref.faction
	character.religion			= pref.religion

/datum/category_item/player_setup_item/general/background/content(var/mob/user)
	. += "<h1>Character Background:</h1><hr>"
	if(!pref.existing_character)
		. += "Geminus City is on the planet Pollux, and is located in Blue Colony, in the Vetra star system. You may choose a different background. Social class and the system you are born in cannot be changed once set.</br><br>"
		. += "Social Class: <a href='?src=\ref[src];econ_status=1'>[pref.economic_status]</a><br/>"
		. += "Birth System: <a href='?src=\ref[src];home_system=1'>[pref.home_system]</a><br/>"

	else
		. += "Social Class: [pref.economic_status]<br/>"
		. += "Birth System: [pref.home_system]<br/>"

	. += "Continental Citizenship: <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>"
//	. += "Faction: <a href='?src=\ref[src];faction=1'>[pref.faction]</a><br/>" // meh do we even use this?
	. += "Religion: <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>"

	. += "<br/><b>Public Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		. += "Hospital Records:<br>"
		. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br><br>"
		. += "Employment Records:<br>"
		. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br><br>"
		. += "Police Records:<br>"
		. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/suitable_classes = get_available_classes(user.client)

	if(href_list["econ_status"])
		var/new_class = input(user, "Choose your social class. This will affect the amount of money you will start with, your position in the revolution and other events.", "Character Preference", pref.economic_status)  as null|anything in suitable_classes
		if(new_class && CanUseTopic(user))
			pref.economic_status = new_class
			return TOPIC_REFRESH

	else if(href_list["home_system"])
		var/choice = input(user, "Please choose a home system.", "Character Preference", pref.home_system) as null|anything in home_system_choices
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a home system.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				pref.home_system = raw_choice
		else
			pref.home_system = choice
		return TOPIC_REFRESH

	else if(href_list["citizenship"])
		var/choice = input(user, "Please choose your current citizenship.", "Character Preference", pref.citizenship) as null|anything in citizenship_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter your current citizenship.", "Character Preference") as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				pref.citizenship = raw_choice
		else
			pref.citizenship = choice
		return TOPIC_REFRESH
/*
	else if(href_list["faction"])
		var/choice = input(user, "Please choose a faction to work for.", "Character Preference", pref.faction) as null|anything in faction_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a faction.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.faction = raw_choice
		else
			pref.faction = choice
		return TOPIC_REFRESH
*/
	else if(href_list["religion"])
		var/choice = input(user, "Please choose a religion.", "Character Preference", pref.religion) as null|anything in religion_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a religon.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.religion = sanitize(raw_choice)
		else
			pref.religion = choice
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Enter medical information here.","Character Preference", html_decode(pref.med_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Enter employment information here.","Character Preference", html_decode(pref.gen_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Enter security information here.","Character Preference", html_decode(pref.sec_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	return ..()
