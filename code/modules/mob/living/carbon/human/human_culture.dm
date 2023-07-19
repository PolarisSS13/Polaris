
//Syncs cultural tokens to the currently set species, and may trigger a language update
/mob/living/carbon/human/proc/apply_species_cultural_info()
	var/update_lang
	LAZYINITLIST(cultural_info)
	for(var/token in ALL_CULTURAL_TAGS)
		if(species.force_cultural_info && species.force_cultural_info[token])
			update_lang = TRUE
			set_cultural_value(token, species.force_cultural_info[token], defer_language_update = TRUE)
		else if(!cultural_info[token] || !(cultural_info[token] in species.available_cultural_info[token]))
			update_lang = TRUE
			set_cultural_value(token, species.default_cultural_info[token], defer_language_update = TRUE)
	if(update_lang)
		update_languages()

/mob/living/carbon/human/proc/set_cultural_value(var/token, var/decl/cultural_info/_culture, var/defer_language_update)
	if(ispath(_culture, /decl/cultural_info))
		_culture = GET_DECL(_culture)
	if(istype(_culture))
		LAZYSET(cultural_info, token, _culture)
		if(!defer_language_update)
			update_languages()

/mob/living/carbon/human/proc/get_cultural_value(var/token)
	. = LAZYACCESS(cultural_info, token)
	if(!istype(., /decl/cultural_info))
		. = using_map.default_cultural_info[token]
		crash_with("get_cultural_value() tried to return a non-instance value for token '[token]' - full culture list: [json_encode(cultural_info)] default species culture list: [json_encode(using_map.default_cultural_info)]")

/mob/living/carbon/human/proc/update_languages()
	if(!length(cultural_info))
		log_adminwarn("'[src]'([x], [y], [z]) doesn't have any cultural info set and is attempting to update its language!!")

	var/list/permitted_languages = list()
	var/list/free_languages =      list()
	var/list/default_languages =   list()

	for(var/thing in cultural_info)
		var/decl/cultural_info/check = cultural_info[thing]
		if(istype(check))
			if(check.default_language)
				free_languages      |= check.default_language
				default_languages   |= check.default_language
			if(check.language)
				free_languages      |= check.language
			if(check.name_language)
				free_languages      |= check.name_language
			for(var/lang in check.additional_langs)
				free_languages      |= lang
			for(var/lang in check.get_spoken_languages())
				permitted_languages |= lang

	for(var/lang_name in languages)
		var/datum/language/lang = GLOB.all_languages[lang_name]
		if(!lang)
			continue
		// Forbidden languages are always removed.
		if(!(lang.flags & FORBIDDEN))
			// Admin can have whatever available language they want.
			if(check_rights(R_ADMIN, 0, src))
				continue
			// Whitelisted languages are fine.
			if((lang.flags & WHITELISTED) && is_alien_whitelisted(src, lang))
				continue
			// Culture-granted languages are fine.
			if(lang.name in permitted_languages)
				continue
		// This language is Not Fine, remove it.
		if(lang.name == default_language)
			default_language = null
		remove_language(lang.name)

	for(var/thing in free_languages)
		add_language(thing)

	if(length(default_languages) && isnull(default_language))
		default_language = default_languages[1]
