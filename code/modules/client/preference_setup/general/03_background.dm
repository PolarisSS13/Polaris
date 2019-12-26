/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 3

/datum/category_item/player_setup_item/general/background/load_character(var/savefile/S)
	S["med_record"]				>> pref.med_record
	S["sec_record"]				>> pref.sec_record
	S["gen_record"]				>> pref.gen_record
	S["home_system"]				>> pref.home_system
	S["citizenship"]				>> pref.citizenship
//	S["faction"]					>> pref.faction
	S["religion"]					>> pref.religion
	S["economic_status"]			>> pref.economic_status
	S["social_class"]				>> pref.social_class
	S["crime_record"]				>> pref.crime_record
	S["health_record"]				>> pref.health_record
	S["job_record"]				>> pref.job_record

/datum/category_item/player_setup_item/general/background/save_character(var/savefile/S)
	S["med_record"]				<< pref.med_record
	S["sec_record"]				<< pref.sec_record
	S["gen_record"]				<< pref.gen_record
	S["home_system"]				<< pref.home_system
	S["citizenship"]				<< pref.citizenship
//	S["faction"]					<< pref.faction
	S["religion"]					<< pref.religion
	S["economic_status"]			<< pref.economic_status
	S["social_class"]				<< pref.social_class
	S["crime_record"]				<< pref.crime_record
	S["health_record"]				>> pref.health_record
	S["job_record"]				>> pref.job_record

/datum/category_item/player_setup_item/general/background/delete_character(var/savefile/S)
	pref.med_record = null
	pref.sec_record = null
	pref.gen_record = null
	pref.home_system = null
	pref.citizenship = null
	pref.faction = null
	pref.religion = null
	pref.economic_status = null
	pref.social_class = null
	pref.crime_record = list()
	pref.health_record = list()
	pref.job_record = list()

	pref.faction = null
	pref.religion = null

/datum/category_item/player_setup_item/general/background/sanitize_character()
	if(!pref.home_system) pref.home_system = "Unset"
	if(!pref.citizenship) pref.citizenship = "None"
//	if(!pref.faction)     pref.faction =     "None"
	if(!pref.religion)    pref.religion =    "None"
	if(!pref.crime_record) pref.crime_record = list()
	if(!pref.health_record) pref.health_record = list()
	if(!pref.job_record) pref.job_record = list()

	pref.economic_status = get_economic_class(pref.money_balance)

	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_CLASS, initial(pref.economic_status))

	if(!pref.social_class)
		pref.social_class = pref.economic_status

	pref.social_class = sanitize_inlist(pref.social_class, ECONOMIC_CLASS, initial(pref.social_class))

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
		. += "Economic Class: [pref.economic_status]<br>"
		. += "Social Class: <a href='?src=\ref[src];soc_class=1'>[pref.social_class]</a><br/>"
		. += "Birth System: <a href='?src=\ref[src];home_system=1'>[pref.home_system]</a><br/>"

	else
		. += "Social Class: [pref.social_class]<br/>"
		. += "Economic Class: [pref.economic_status]<br>"
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
		. += "Police Notes:<br>"
		if(!pref.existing_character)
			. += "<a href='?src=\ref[src];set_security_records=1'>[pref.sec_record ? "[TextPreview(pref.sec_record,40)]" : "Add Police Notes"]</a><br>"
		else
			. += "<i>[pref.sec_record ? "[pref.sec_record]" : "No police notes found."]</i><br>"


		var/crime_data
		var/record_count
		for(var/datum/record/C in pref.crime_record)
			crime_data += "<BR>\n<b>[C.name]</b>: [C.details] - [C.author] <i>([C.date_added])</i>"
			record_count++

		. += "Criminal Record:<br>"
		. += "<a href='?src=\ref[src];edit_criminal_record=1'>Edit Criminal Record[record_count ? " ([record_count])" : ""]</a><br>"
		. += "\n<b>Criminal Status:</b> [pref.criminal_status]<br>"

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/suitable_classes = get_available_classes(user.client)

	if(href_list["choice"])
		switch(href_list["choice"])
			if("remove_criminal_record")
				var/datum/record/record = locate(href_list["record"])
				pref.crime_record -= record

				return TOPIC_REFRESH

	if(href_list["soc_class"])
		var/new_class = input(user, "Choose your starting social class. This will affect the amount of money you will start with, your position in the revolution and other events.", "Character Preference", pref.economic_status)  as null|anything in suitable_classes
		if(new_class && CanUseTopic(user))
			pref.social_class = new_class
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

	else if(href_list["edit_criminal_record"])
		EditCriminalRecord(user)

		return TOPIC_REFRESH


	else if(href_list["set_criminal_record"])

		var/laws_list = get_law_names()
		var/crime = input(user, "Select a crime.", "Edit Criminal Records", null) as null|anything in laws_list
		var/sec = sanitize(input(user,"Enter security information here.","Character Preference", html_decode(pref.sec_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(isnull(sec)) return

		var/year = 0
		var/month = get_game_month()
		var/day = get_game_day()

		if(!pref.existing_character)
			year = input(user, "How many years ago? IE: 3 years ago. Input 0 for current year", "Edit Criminal Year", year) as num|null
			if(year > pref.age) return

			month = input(user, "On which month?", "Edit Month", month) as num|null
			if(!get_month_from_num(month)) return
			if(!year && month > get_game_month()) return

			day = input(user, "On what day?", "Edit Day", day) as num|null
			if((month in THIRTY_DAY_MONTHS) && month > 30 || (month in THIRTY_ONE_DAY_MONTHS) && month > 31 || (month in TWENTY_EIGHT_DAY_MONTHS) && month > 28) return
			if(!year && month == get_game_month() && day > get_game_day()) return

		if(!isnull(crime) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			var/officer_name = random_name(pick("male","female"), SPECIES_HUMAN)

			pref.crime_record += make_new_record(/datum/record/police, crime, officer_name, user.ckey, "[day]/[month]/[get_game_year() - year]", sec)

		return TOPIC_HANDLED

	return ..()

/datum/category_item/player_setup_item/general/background/proc/EditCriminalRecord(mob/user)
	var/HTML
	HTML += "<center>"
	HTML += "<b>Edit Criminal Record</b> <hr />"
	HTML += "<br></center>"

	HTML += "<br><a href='?src=\ref[src];set_criminal_record=1'>Add Criminal Record</a><br>"

	for(var/datum/record/C in pref.crime_record)
		if(!pref.existing_character)
			HTML += "\n<b>[C.name]</b>: [C.details] - [C.author] <i>([C.date_added])</i> <a href='?src=\ref[src];choice=remove_criminal_record;record=\ref[C]'>Remove</a><br>"
		else
			HTML += "\n<b>[C.name]</b>: [C.details] - [C.author] <i>([C.date_added])</i><br>"

	HTML += "<hr />"

	user << browse(HTML, "window=crim_record;size=430x300")

	onclose(user, "crim_record")
	return
