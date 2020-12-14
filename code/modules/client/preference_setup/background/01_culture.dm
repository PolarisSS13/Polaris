/datum/category_item/player_setup_item/proc/get_allowed_background_values(var/list/write_to, var/check_key)
	var/datum/species/S = GLOB.all_species[pref.species]
	var/status = pref.organ_data[O_BRAIN]
	var/robot = FALSE
	if(!S)
		write_to = list()
	else if(S.force_cultural_info[check_key])
		write_to = list(S.force_cultural_info[check_key] = TRUE)
	else
		write_to = list()
		if(status == "mechanical")
			robot = TRUE
			for(var/cul in GLOB.positronic_cultural_info[check_key])
				write_to[cul] = TRUE
		else if(status == "digital")
			robot = TRUE
			for(var/cul in GLOB.drone_cultural_info[check_key])
				write_to[cul] = TRUE
		for(var/cul in S.available_cultural_info[check_key])
			write_to[cul] = TRUE

	for(var/cul in write_to)
		to_world("- [cul]")
		var/decl/cultural_info/culture = SSculture.get_culture(cul)

		if((robot && culture.whitelist == CULTURE_ONLY_ORGANIC) || (!robot && culture.whitelist == CULTURE_ONLY_MACHINE))
			write_to -= cul

	return write_to

/datum/preferences
	var/list/cultural_info = list()

/datum/category_item/player_setup_item/background/culture
	name = "Culture"
	sort_order = 1
	var/list/hidden
	var/list/tokens = ALL_CULTURAL_TAGS

/datum/category_item/player_setup_item/background/culture/New()
	hidden = list()
	for(var/token in tokens)
		hidden[token] = TRUE
	..()

/datum/category_item/player_setup_item/background/culture/sanitize_character()
	if(islist(pref.background_modifiers))
		pref.background_modifiers.Cut()
	if(!islist(pref.cultural_info))
		pref.cultural_info = list()
	for(var/token in tokens)
		var/list/_cultures
		_cultures = get_allowed_background_values(_cultures, token)
		if(!LAZYLEN(_cultures))
			pref.cultural_info[token] = using_map.default_cultural_info[token]
		else
			var/current_value = pref.cultural_info[token]
			if(!current_value|| !_cultures[current_value])
				pref.cultural_info[token] = _cultures[1]

	if(!pref.home_system) pref.home_system = "Unset"
	if(!pref.citizenship) pref.citizenship = "None"
	if(!pref.faction)     pref.faction =     "None"
	if(!pref.religion)    pref.religion =    "None"
	if(!pref.custculture) pref.custculture = "None"
	if(!pref.subspecies)  pref.subspecies =  "None"

/datum/category_item/player_setup_item/background/culture/load_character(var/savefile/S)
	for(var/token in tokens)
		var/load_val
		from_file(S[token], load_val)
		pref.cultural_info[token] = load_val

	S["home_system"]			>> pref.home_system
	S["citizenship"]			>> pref.citizenship
	S["faction"]				>> pref.faction
	S["religion"]				>> pref.religion
	S["subspecies"]				>> pref.subspecies
	S["custculture"]			>> pref.custculture

	if(LAZYLEN(pref.background_modifiers))	// Sanity
		pref.background_modifiers.Cut()

	for(var/token in pref.cultural_info)
		var/decl/cultural_info/culture = SSculture.get_culture(pref.cultural_info[token])
		if(islist(culture.modifiers) && LAZYLEN(culture.modifiers))
			if(!islist(pref.background_modifiers))
				pref.background_modifiers = list()

			pref.background_modifiers |= culture.modifiers.Copy()

/datum/category_item/player_setup_item/background/culture/save_character(var/savefile/S)
	for(var/token in tokens)
		to_file(S[token], pref.cultural_info[token])

	S["home_system"]			<< pref.home_system
	S["citizenship"]			<< pref.citizenship
	S["faction"]				<< pref.faction
	S["religion"]				<< pref.religion
	S["subspecies"]				<< pref.subspecies
	S["custculture"]			<< pref.custculture

/datum/category_item/player_setup_item/background/culture/copy_to_mob(var/mob/living/carbon/human/character)
	character.cultural_info = pref.cultural_info.Copy()

	character.home_system		= pref.home_system
	character.citizenship		= pref.citizenship
	character.personal_faction	= pref.faction
	character.religion			= pref.religion
	character.subspecies		= pref.subspecies
	character.custculture		= pref.custculture

	for(var/path in pref.background_modifiers)
		character.add_modifier(path, 0)

/datum/category_item/player_setup_item/background/culture/content()
	. = list()
	for(var/token in tokens)
		var/decl/cultural_info/culture = SSculture.get_culture(pref.cultural_info[token])
		var/title = "<b>[tokens[token]]<a href='?src=\ref[src];set_[token]=1'><small>?</small></a>:</b><a href='?src=\ref[src];set_[token]=2'>[pref.cultural_info[token]]</a>"
		var/append_text = "<a href='?src=\ref[src];toggle_verbose_[token]=1'>[hidden[token] ? "Expand" : "Collapse"]</a>"

		if(culture)
			if(culture.other_tag)
				var/display = "Pref"
				switch(culture.other_tag)
					if("custculture")
						display = pref.custculture
					if("home_system")
						display = pref.home_system
					if("subspecies")
						display = pref.subspecies
					if("religion")
						display = pref.religion
					if("faction")
						display = pref.faction

				append_text += "<br><a href='?src=\ref[src];[culture.other_tag]=1'>[display]</a>"

			. += culture.get_description(title, append_text, verbose = !hidden[token])
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/culture/OnTopic(var/href,var/list/href_list, var/mob/user)

	for(var/token in tokens)

		if(href_list["toggle_verbose_[token]"])
			hidden[token] = !hidden[token]
			return TOPIC_REFRESH

		var/check_href = text2num(href_list["set_[token]"])
		if(check_href > 0)

			var/list/valid_values
			if(check_href == 1)
				valid_values = SSculture.get_all_entries_tagged_with(token)
			else
				valid_values = get_allowed_background_values(valid_values, token)

			var/choice = input("Please select an entry.") as null|anything in valid_values
			if(!choice)
				return

			// Check if anything changed between now and then.
			if(check_href == 1)
				valid_values = SSculture.get_all_entries_tagged_with(token)
			else
				valid_values = get_allowed_background_values(valid_values, token)

			if(valid_values[choice])
				var/decl/cultural_info/culture = SSculture.get_culture(choice)
				if(check_href == 1)
					user << browse(culture.get_description(), "window=[token];size=700x400")
				else
					pref.cultural_info[token] = choice
				return TOPIC_REFRESH

	if(href_list["home_system"])
		var/choice = input(user, "Please choose a home system.", "Character Preference", pref.home_system) as null|anything in home_system_choices + list("Unset","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a home system.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				pref.home_system = raw_choice
		else
			pref.home_system = choice
		return TOPIC_REFRESH

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

	else if(href_list["custculture"])
		var/raw_choice = sanitize(input(user, "Please enter a culture.", "Character Preference", pref.custculture)  as text|null, MAX_NAME_LEN)
		if(raw_choice)
			pref.custculture = sanitize(raw_choice)
		else
			return TOPIC_NOACTION
		return TOPIC_REFRESH

	. = ..()