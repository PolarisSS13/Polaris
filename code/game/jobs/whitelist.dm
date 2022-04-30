var/global/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(config.usewhitelist)
		load_whitelist()
	return TRUE

/proc/load_whitelist()
	whitelist = file2list("data/whitelist.txt")
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return FALSE
	return ("[M.ckey]" in whitelist)

var/global/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config.usealienwhitelist)
		load_alienwhitelist()
	return TRUE

/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		alien_whitelist = splittext(text, "\n")

/proc/is_alien_whitelisted(mob/M, var/datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !species)
		return FALSE

	//The species isn't even whitelisted
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return TRUE

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [species.name]"))
				return TRUE
			if(findtext(s,"[M.ckey] - All"))
				return TRUE

/proc/is_lang_whitelisted(mob/M, var/datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !language)
		return FALSE

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return TRUE

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [language.name]"))
				return TRUE
			if(findtext(s,"[M.ckey] - All"))
				return TRUE

/proc/whitelist_overrides(mob/M)
	return !config.usealienwhitelist || check_rights(R_ADMIN|R_EVENT, 0, M)

var/global/list/genemod_whitelist = list()
/hook/startup/proc/LoadGenemodWhitelist()
	global.genemod_whitelist = file2list("config/genemodwhitelist.txt")
	return TRUE

/proc/is_genemod_whitelisted(mob/M)
	return M && M.client && M.client.ckey && LAZYLEN(global.genemod_whitelist) && (M.client.ckey in global.genemod_whitelist)

/proc/foo()
	to_world(list2text(global.genemod_whitelist))
