/datum/category_item/player_setup_item/background/languages
	name = "Languages"
	sort_order = 2
	var/list/allowed_languages
	var/list/free_languages

/datum/category_item/player_setup_item/background/languages/load_character(var/savefile/S)
	from_file(S["language"], pref.alternate_languages)
	from_file(S["language_prefixes"], pref.language_prefixes)

/datum/category_item/player_setup_item/background/languages/save_character(var/savefile/S)
	to_file(S["language"],   pref.alternate_languages)
	to_file(S["language_prefixes"], pref.language_prefixes)

/datum/category_item/player_setup_item/background/languages/sanitize_character()
	if(!islist(pref.alternate_languages))	pref.alternate_languages = list()
	if(pref.species)
		var/datum/species/S = GLOB.all_species[pref.species]
		if(S && pref.alternate_languages.len > S.num_alternate_languages)
			pref.alternate_languages.len = S.num_alternate_languages // Truncate to allowed length
	if(isnull(pref.language_prefixes) || !pref.language_prefixes.len)
		pref.language_prefixes = config.language_prefixes.Copy()

/datum/category_item/player_setup_item/background/languages/content()
	. += "<b>Languages</b><br>"

	var/datum/language/L

	var/datum/species/S = GLOB.all_species[pref.species]
	if(S.language)
		L = GLOB.all_languages[S.language]
		. += "- <b>[S.language]</b><br>"
		. += "<small><b>Description:</b> [L.desc]</small><br>"
		. += "<small><b>Scrambled:</b> [L.scramble("lorem ipsum sin dolor omet", list())]</small><br>"
	if(S.default_language && S.default_language != S.language)
		L = GLOB.all_languages[S.default_language]
		. += "- <b>[S.default_language]</b><br>"
		. += "<small><b>Description:</b> [L.desc]</small><br>"
		. += "<small><b>Scrambled:</b> [L.scramble("lorem ipsum sin dolor omet", list())]</small><br>"
	if(S.num_alternate_languages)
		if(pref.alternate_languages.len)
			for(var/i = 1 to pref.alternate_languages.len)
				var/lang = pref.alternate_languages[i]
				L = GLOB.all_languages[lang]
				. += "- <b>[lang]</b> - <a href='?src=\ref[src];remove_language=[i]'>remove</a><br>"
				. += "<small><b>Description:</b> [L.desc]</small><br>"
				. += "<small><b>Scrambled:</b> [L.scramble("lorem ipsum sin dolor omet", list())]</small><br>"

		if(pref.alternate_languages.len < S.num_alternate_languages)
			. += "- <a href='?src=\ref[src];add_language=1'>add</a> ([S.num_alternate_languages - pref.alternate_languages.len] remaining)<br>"
	else
		. += "- [pref.species] cannot choose secondary languages.<br>"

	. += "<b>Language Keys</b><br>"
	. += " [jointext(pref.language_prefixes, " ")] <a href='?src=\ref[src];change_prefix=1'>Change</a> <a href='?src=\ref[src];reset_prefix=1'>Reset</a><br>"

/datum/category_item/player_setup_item/background/languages/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["remove_language"])
		var/index = text2num(href_list["remove_language"])
		pref.alternate_languages.Cut(index, index+1)
		return TOPIC_REFRESH
	else if(href_list["add_language"])
		var/datum/species/S = GLOB.all_species[pref.species]
		if(pref.alternate_languages.len >= S.num_alternate_languages)
			alert(user, "You have already selected the maximum number of alternate languages for this species!")
		else
			var/list/available_languages = S.secondary_langs.Copy()
			for(var/L in GLOB.all_languages)
				var/datum/language/lang = GLOB.all_languages[L]
				if(!(lang.flags & RESTRICTED) && (is_lang_whitelisted(user, lang)))
					available_languages |= L

			// make sure we don't let them waste slots on the default languages
			available_languages -= S.language
			available_languages -= S.default_language
			available_languages -= pref.alternate_languages

			if(!available_languages.len)
				alert(user, "There are no additional languages available to select.")
			else
				var/new_lang = input(user, "Select an additional language", "Character Generation", null) as null|anything in available_languages
				if(new_lang && pref.alternate_languages.len < S.num_alternate_languages)
					pref.alternate_languages |= new_lang
					return TOPIC_REFRESH

	else if(href_list["change_prefix"])
		var/char
		var/keys[0]
		do
			char = input("Enter a single special character.\nYou may re-select the same characters.\nThe following characters are already in use by radio: ; : .\nThe following characters are already in use by special say commands: ! * ^", "Enter Character - [3 - keys.len] remaining") as null|text
			if(char)
				if(length(char) > 1)
					alert(user, "Only single characters allowed.", "Error", "Ok")
				else if(char in list(";", ":", "."))
					alert(user, "Radio character. Rejected.", "Error", "Ok")
				else if(char in list("!","*", "^"))
					alert(user, "Say character. Rejected.", "Error", "Ok")
				else if(contains_az09(char))
					alert(user, "Non-special character. Rejected.", "Error", "Ok")
				else
					keys.Add(char)
		while(char && keys.len < 3)

		if(keys.len == 3)
			pref.language_prefixes = keys
			return TOPIC_REFRESH
	else if(href_list["reset_prefix"])
		pref.language_prefixes = config.language_prefixes.Copy()
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/background/languages/proc/rebuild_language_cache(var/mob/user)

	allowed_languages = list()
	free_languages = list()

	if(!user)
		return

	for(var/thing in pref.cultural_info)
		var/decl/cultural_info/culture = SSculture.get_culture(pref.cultural_info[thing])
		if(istype(culture))
			var/list/langs = culture.get_spoken_languages()
			if(LAZYLEN(langs))
				for(var/checklang in langs)
					free_languages[checklang] =    TRUE
					allowed_languages[checklang] = TRUE
			if(LAZYLEN(culture.secondary_langs))
				for(var/checklang in culture.secondary_langs)
					allowed_languages[checklang] = TRUE

	for(var/thing in GLOB.all_languages)
		var/datum/language/lang = GLOB.all_languages[thing]
		if(whitelist_overrides(user) || (!(lang.flags & RESTRICTED) && (lang.flags & WHITELISTED) && is_alien_whitelisted(user, lang)))
			allowed_languages[thing] = TRUE

/datum/category_item/player_setup_item/background/languages/proc/is_allowed_language(var/mob/user, var/datum/language/lang)
	if(isnull(allowed_languages) || isnull(free_languages))
		rebuild_language_cache(user)
	if(!user || ((lang.flags & RESTRICTED) && is_lang_whitelisted(user, lang)))
		return TRUE
	return allowed_languages[lang.name]

/datum/category_item/player_setup_item/background/languages/proc/sanitize_alt_languages()
	if(!istype(pref.alternate_languages))
		pref.alternate_languages = list()
	var/preference_mob = preference_mob()
	rebuild_language_cache(preference_mob)
	for(var/L in pref.alternate_languages)
		var/datum/language/lang = GLOB.all_languages[L]
		if(!lang || !is_allowed_language(preference_mob, lang))
			pref.alternate_languages -= L

	var/datum/species/S = GLOB.all_species[pref.species]

	var/list/free_languages = list()
	free_languages |= S.language
	free_languages |= S.default_language


	if(LAZYLEN(free_languages))
		for(var/lang in free_languages)
			pref.alternate_languages -= lang
			pref.alternate_languages.Insert(1, lang)

	pref.alternate_languages = uniquelist(pref.alternate_languages)
	if(pref.alternate_languages.len > S.num_alternate_languages + free_languages.len)
		pref.alternate_languages.Cut(S.num_alternate_languages + free_languages.len + 1)

/datum/category_item/player_setup_item/background/languages/proc/get_language_text()
	. = ..()
	sanitize_alt_languages()

	var/datum/species/S = GLOB.all_species[pref.species]

	var/list/free_languages = list()
	free_languages |= S.language
	free_languages |= S.default_language

	if(LAZYLEN(pref.alternate_languages))
		for(var/i = 1 to pref.alternate_languages.len)
			var/lang = pref.alternate_languages[i]
			if(free_languages[lang])
				LAZYADD(., "- [lang] (required).<br>")
			else
				LAZYADD(., "- [lang] <a href='?src=\ref[src];remove_language=[i]'>Remove.</a><br>")
	if(pref.alternate_languages.len < S.num_alternate_languages + free_languages.len)
		var/remaining_langs = S.num_alternate_languages - pref.alternate_languages.len
		LAZYADD(., "- <a href='?src=\ref[src];add_language=1'>add</a> ([remaining_langs] remaining)<br>")
