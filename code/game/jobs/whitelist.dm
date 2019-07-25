#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(config.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	whitelist = file2list(WHITELISTFILE)
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return 0
	return ("[M.ckey]" in whitelist)

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config.usealienwhitelist)
		load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		alien_whitelist = splittext(text, "\n")

/proc/is_alien_whitelisted(mob/M, var/datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !species)
		return 0

	//The species isn't even whitelisted
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return 1

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [species.name]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

/proc/is_lang_whitelisted(mob/M, var/datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !language)
		return 0

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return 1

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [language.name]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

/proc/whitelist_overrides(mob/M)
	if(!config.usealienwhitelist)
		return 1
	if(check_rights(R_ADMIN, 0, M))
		return 1

	return 0

/var/list/hard_whitelist = list()

/hook/startup/proc/loadhardWhitelist()
	load_hardwhitelist()
	return 1

/proc/load_hardwhitelist()
	var/text = file2text("config/hardwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/hardwhitelist.txt")
	else
		hard_whitelist = splittext(text, "\n")

/proc/is_hard_whitelisted(mob/M, var/datum/job/jobs)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//The job isn't even whitelisted
	if(!jobs.hard_whitelisted)
		return 1

	//If we have a loaded file, search it
	if(jobs.hard_whitelisted)
		for (var/s in hard_whitelist)
			if(findtext(s,"[M.ckey] - [jobs.title]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1



/proc/get_available_classes(client/C)

	if(!isnum(C.player_age))
		return ECONOMIC_CLASS

	if(59 < C.player_age)
		return ECONOMIC_CLASS //60 days unlocks all classes

	else if (29 < C.player_age)
		return list(CLASS_WORKING, CLASS_MIDDLE)

	else
		return CLASS_WORKING


	return CLASS_WORKING



#undef WHITELISTFILE
