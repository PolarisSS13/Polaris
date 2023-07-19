#define GET_ALLOWED_VALUES(write_to, check_key) \
	var/datum/species/S = get_species_by_key(pref.species); \
	if(!S) { \
		write_to = list(); \
	} else if(S.force_cultural_info[check_key]) { \
		write_to = list(S.force_cultural_info[check_key] = TRUE); \
	} else { \
		write_to = list(); \
		for(var/cul in S.available_cultural_info[check_key]) { \
			write_to[cul] = TRUE; \
		} \
	}

/datum/preferences
	var/list/cultural_info = list()

/datum/category_item/player_setup_item/general/background
	name = "Culture"
	sort_order = 6
	var/list/hidden
	var/list/expanded

/datum/category_item/player_setup_item/general/background/New()
	hidden = list()
	expanded = list()
	for(var/token in ALL_CULTURAL_TAGS)
		hidden[token] = TRUE
		expanded[token] = FALSE
	..()

/datum/category_item/player_setup_item/general/background/sanitize_character()

	if(!islist(pref.cultural_info))
		pref.cultural_info = list()

	// Map any non-path tokens (ie. data that has been loaded from a file) to decls.
	var/list/all_cultural_decls = decls_repository.get_decls_of_subtype(/decl/cultural_info)
	for(var/token in ALL_CULTURAL_TAGS)
		var/entry = pref.cultural_info[token]
		if(!entry || ispath(entry, /decl/cultural_info))
			continue
		entry = lowertext(entry)
		pref.cultural_info -= token
		for(var/ftype in all_cultural_decls)
			var/decl/cultural_info/culture = all_cultural_decls[ftype]
			if(culture.name && lowertext(culture.name) == entry)
				pref.cultural_info[token] = culture.type
				break

	// Sanitize and initialize our culture lists, taking data from our map
	// or other defaults if we haven't got anything loaded for the various tokens.
	for(var/token in ALL_CULTURAL_TAGS)
		var/list/_cultures
		GET_ALLOWED_VALUES(_cultures, token)
		if(!LAZYLEN(_cultures))
			pref.cultural_info[token] = global.using_map.default_cultural_info[token]
		else
			var/current_value = pref.cultural_info[token]
			if(!current_value || !_cultures[current_value])
				pref.cultural_info[token] = _cultures[1]

/datum/category_item/player_setup_item/general/background/load_character(var/savefile/S)
	for(var/token in ALL_CULTURAL_TAGS)
		S[token] >> pref.cultural_info[token]

/datum/category_item/player_setup_item/general/background/save_character(var/savefile/S)
	for(var/token in ALL_CULTURAL_TAGS)
		var/entry = pref.cultural_info[token]
		if(entry)
			if(ispath(entry, /decl/cultural_info))
				var/decl/cultural_info/culture = GET_DECL(entry)
				entry = culture.name
		S[token] << entry

/datum/category_item/player_setup_item/general/background/copy_to_mob(mob/living/carbon/human/character)
	. = ..()
	for(var/token in pref.cultural_info)
		character.set_cultural_value(token, pref.cultural_info[token], defer_language_update = TRUE)
	character.update_languages()

/datum/category_item/player_setup_item/general/background/content()
	. = ..()
	. += "<b>Background Information</b><br>"
	for(var/token in ALL_CULTURAL_TAGS)

		var/decl/cultural_info/culture = GET_DECL(pref.cultural_info[token])

		. += "<table width = '100%'>"
		. += "<tr><td colspan=3><center><h3>[ALL_CULTURAL_TAGS[token]]: <a href='?src=\ref[src];expand_options_[token]=1'>[culture.name] <small>\[[expanded[token] ? "-" : "+"]\]</small></a></h3>"
		if(expanded[token])
			var/list/valid_values
			GET_ALLOWED_VALUES(valid_values, token)
			. += "</center></td></tr>"
			. += "<tr><td colspan=3><center>"
			for(var/culture_path in valid_values)
				var/decl/cultural_info/culture_data = GET_DECL(culture_path)
				if(!culture_data.name)
					continue
				if(pref.cultural_info[token] == culture_data.type)
					. += "<span class='linkOn'>[culture_data.name]</span> "
				else
					. += "<a href='?src=\ref[src];set_token_entry_[token]=\ref[culture_data]'>[culture_data.name]</a> "
		. += "</center><hr/></td></tr>"

		var/list/culture_info = culture.get_description(!hidden[token])
		. += "<tr><td width = '200px'>"
		. += "<small>[culture_info["details"] || "No additional details."]</small>"
		. += "</td><td>"
		. += "[culture_info["body"] || "No description."]"
		. += "</td><td width = '50px'>"
		. += "<a href='?src=\ref[src];toggle_verbose_[token]=1'>[hidden[token] ? "Expand" : "Collapse"]</a>"
		. += "</td></tr>"
		. += "</table><hr>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)

	for(var/token in ALL_CULTURAL_TAGS)

		if(href_list["toggle_verbose_[token]"])
			hidden[token] = !hidden[token]
			return TOPIC_REFRESH

		if(href_list["expand_options_[token]"])
			expanded[token] = !expanded[token]
			return TOPIC_REFRESH

		var/decl/cultural_info/new_token = href_list["set_token_entry_[token]"]
		if(!isnull(new_token))
			new_token = locate(new_token)
			if(istype(new_token))
				pref.cultural_info[token] = new_token.type
				return TOPIC_REFRESH

	. = ..()

#undef GET_ALLOWED_VALUES
