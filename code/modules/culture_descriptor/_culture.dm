GLOBAL_LIST_INIT(default_culture_for_unset_tags, list(
	TAG_CULTURE =   list(/decl/cultural_info/culture/other),
	TAG_HOMEWORLD = list(/decl/cultural_info/location/human/vir),
	TAG_FACTION =   list(/decl/cultural_info/faction/other),
	TAG_RELIGION =  list(/decl/cultural_info/religion/other)
))

/decl/cultural_info
	var/name
	var/description
	var/economic_power = 1
	var/language
	var/name_language
	var/default_language
	var/list/additional_langs
	var/list/secondary_langs
	var/category
	var/subversive_potential = 0
	var/hidden
	var/hidden_from_codex
	var/list/restricted_to_species
	var/list/blacklisted_from_species

/decl/cultural_info/proc/get_description(var/verbose = TRUE)
	LAZYSET(., "details", jointext(get_text_details(), "<br>"))
	var/body = get_text_body()
	if(verbose || length(body) <= 50)
		LAZYSET(., "body", body)
	else
		LAZYSET(., "body", "[copytext(get_text_body(), 1, 44)] <small>\[...\]</small>")

/decl/cultural_info/proc/get_text_body()
	return description

/decl/cultural_info/proc/get_text_details()
	. = list()
	var/list/spoken_langs = get_spoken_languages()
	if(LAZYLEN(spoken_langs))
		var/list/spoken_lang_names = list()
		for(var/thing in spoken_langs)
			var/datum/language/lang = GLOB.all_languages[thing]
			spoken_lang_names |= lang.name
		. += "<b>Language(s):</b> [english_list(spoken_lang_names)]."
	if(LAZYLEN(secondary_langs))
		var/list/secondary_lang_names = list()
		for(var/thing in secondary_langs)
			var/datum/language/lang = GLOB.all_languages[thing]
			secondary_lang_names |= lang.name
		. += "<b>Optional language(s):</b> [english_list(secondary_lang_names)]."
	if(!isnull(economic_power))
		. += "<b>Economic power:</b> [round(100 * economic_power)]%"

/decl/cultural_info/proc/get_spoken_languages()
	. = list()
	if(language)                  . |= language
	if(default_language)          . |= default_language
	if(LAZYLEN(additional_langs)) . |= additional_langs

/decl/cultural_info/proc/override_fbp_brain_type(var/old_brain_type)
	return

/decl/cultural_info/proc/is_available_to_species(var/datum/species/species, var/include_hidden = FALSE)
	if(length(restricted_to_species) && !(species.name in restricted_to_species))
		return FALSE
	if(length(blacklisted_from_species) && (species.name in blacklisted_from_species))
		return FALSE
	if(!include_hidden && hidden)
		return FALSE
	return TRUE
