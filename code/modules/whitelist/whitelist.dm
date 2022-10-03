/client/var/list/whitelists = null


// Prints the client's whitelist entries
/client/verb/print_whitelist()
	set name = "Show Whitelist Entries"
	set desc = "Print the set of things you're whitelisted for."
	set category = "OOC"

	to_chat(src, "You are whitelisted for:")
	for(var/key in src.whitelists)
		to_chat(src, key)


// Load the whitelist from file.
/client/proc/load_whitelist()
	// If it's already loaded.
	if(src.whitelists != null)
		return

	var/filename = "data/player_saves/[copytext(ckey(src.ckey),1,2)]/[ckey(src.ckey)]/whitelist.json"
	try
		// Check the player-specific whitelist file, if it exists.
		if(fexists(filename))
			// Load the whitelist entries from file, or empty string if empty.`
			src.whitelists = list()
			for(var/T in json_decode(file2text(filename) || ""))
				T = text2path(T)
				if(!ispath(T))
					continue
				src.whitelists[T] = TRUE

		// Something was removing an entry from the whitelist and interrupted mid-overwrite.
		else if(fexists(filename + ".tmp") && fcopy(filename + ".tmp", filename))
			src.load_whitelist()
			if(!fdel(filename + ".tmp"))
				error("Exception when deleting tmp whitelist file [filename].tmp")

		// Whitelist file doesn't exist, so they aren't whitelisted for anything. Create the file.
		else
			text2file("", filename)
			src.whitelists = list()

	catch(var/exception/E)
		error("Exception when loading whitelist file [filename]: [E]")


// Returns true if the specified path is in the player's whitelists, false otw.
/client/proc/is_whitelisted(var/path)
	if(istext(path))
		path = text2path(path)
	if(!ispath(path))
		return
	if(src.whitelists == null)
		src.load_whitelist()
	return src.whitelists[path]


// Add the selected path to the player's whitelists, if it's valid.
/client/proc/add_whitelist(var/path)
	if(istext(path))
		path = text2path(path)
	if(!ispath(path))
		return
	// If they're already whitelisted, do nothing (Also loads the whitelist)
	if(is_whitelisted(path))
		return

	src.whitelists[path] = TRUE
	src.write_whitelist()


// Remove the selected path from the player's whitelists.
/client/proc/remove_whitelist(var/path)
	if(!ispath(path))
		return
	// If they're not whitelisted, do nothing (Also loads the whitelist)
	if(!is_whitelisted(path))
		return

	src.whitelists -= path
	src.write_whitelist()


// Rewrites the client's whitelists to disk
/client/proc/write_whitelist()
	var/filename = "data/player_saves/[copytext(ckey(src.ckey),1,2)]/[ckey(src.ckey)]/whitelist.json"
	try
		// Byond doesn't have a mechanism for in-place modification of a file, so we have to make a new one and then overwrite the old one.
		// If this is interrupted, the .tmp file exists and can be loaded at the start of the next round.
		// The in-game list represents the set of valid entries within the whitelist file, so we may as well remove invalid lines in the process.
		text2file(json_encode(src.whitelists), filename + ".tmp")
		if(!fdel(filename))
			error("Exception when overwriting whitelist file [filename]")
		if(fcopy(filename + ".tmp", filename))
			if(!fdel(filename + ".tmp"))
				error("Exception when deleting tmp whitelist file [filename].tmp")
	catch(var/exception/E)
		error("Exception when writing to whitelist file [filename]: [E]")


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

	return M.client.is_whitelisted(species.type)


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

	return M.client.is_whitelisted(language.type)


/proc/whitelist_overrides(mob/M)
	return !config.usealienwhitelist || check_rights(R_ADMIN|R_EVENT, 0, M)
