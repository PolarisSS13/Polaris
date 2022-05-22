/**
* If not set, clients are allowed to use any job.
* If set, a list of clients permitted to use listed jobs, of the form:
* list("ckey" = list("all" | "ckey(job.title)", ...), ...)
*/
GLOBAL_LIST(allow_list_job)

/// Checks whether a client is allowed to use a job.
/proc/check_allowed_job(client/client, datum/job/job)
	if (istype(job))
		job = job.title
	return check_allow_list("job", GLOB.allow_list_job, client, job)


/**
* If not set, clients are allowed to use any species.
* If set, a list of clients permitted to use listed species, of the form:
* list("ckey" = list("all" | "ckey(species.name)", ...), ...)
*/
GLOBAL_LIST(allow_list_species)

/// Checks whether a client is allowed to use a species.
/proc/check_allowed_species(client/client, datum/species/species)
	if (istype(species))
		if (!(species.spawn_flags & SPECIES_IS_WHITELISTED))
			return TRUE
		species = species.name
	return check_allow_list("species", GLOB.allow_list_species, client, species)


/**
* If not set, clients are allowed to use any language.
* If set, a list of clients permitted to use listed languages, of the form:
* list("ckey" = list("all" | "ckey(language.name)", ...), ...)
*/
GLOBAL_LIST(allow_list_language)

/// Checks whether a client is allowed to use a language.
/proc/check_allowed_language(client/client, datum/language/language)
	if (istype(language))
		if (!(language.flags & WHITELISTED))
			return TRUE
		language = language.name
	return check_allow_list("language", GLOB.allow_list_language, client, language)


/**
* If not set, clients are allowed to use any sprite accessory.
* If set, a list of clients permitted to use listed sprite accessories, of the form:
* list("ckey" = list("all" | "ckey(sprite_accessory.allow_list_tag)", ...), ...)
*/
GLOBAL_LIST(allow_list_sprite_accessory)

/// Checks whether a client is allowed to use a sprite accessory.
/proc/check_allowed_sprite_accessory(client/client, datum/sprite_accessory/accessory)
	if (istype(accessory))
		accessory = accessory.allow_list_tag
	return check_allow_list("sprite accessory", GLOB.allow_list_sprite_accessory, client, accessory)


/**
* Checks whether a client is allowed to use a given item in an allow list, or
* is otherwise permitted by the allow list not being set, the client having the
* appropriate access level, or the client having "all" in their allow list.
*/
/proc/check_allow_list(hint, list/allow_list, client/client, item)
	if (!allow_list)
		return TRUE
	var/item_ckey = ckey(item)
	if (!item || !item_ckey)
		log_debug("check_allow_list ([hint]) passed an invalid item: [!item ? "null" : item]")
		return
	if (!client || !(client = resolve_client(client)))
		log_debug("check_allow_list ([hint]) passed an invalid client / ckey: [client]")
		return
	if (check_rights(R_ADMIN|R_EVENT, FALSE, client))
		return TRUE
	var/list/client_allowed = allow_list[client.ckey]
	if (!client_allowed)
		return FALSE
	if (("all" in client_allowed))
		return TRUE
	return (item_ckey in client_allowed)


/**
* Loads an allow list from from_file into into in-place, also returning into.
* An allow list file is a list of strictly "ckey - ckey(item)" pairs, one per line, with # comments.
* For example, languages might look like:
blandmelon19 - schechi
# frosting123 - voxpidgin
tepidfluid - sintaunathi
blandmelon19 - solcommon
* and produce an allow list like:
* list(
*   "blandmelon19" = list("schechi", "solcommon"),
*   "tepidfluid" = list("sintaunathi")
* )
*/
/proc/load_allow_list(from_file, list/into = list())
	var/list/entries = file2text(from_file)
	if (entries)
		entries = replacetext_char(entries, regex(@"\r", "g"), "")
		entries = replacetext_char(entries, regex(@"\n+", "g"), "\n")
		var/regex/trim_whitespace = regex(@"(^\s+)|(\s+$)", "g")
		for (var/list/entry in splittext_char(entries, "\n"))
			entry = replacetext_char(entry, trim_whitespace, "")
			if (!length(entry) || entry[1] == "#")
				continue
			entry = splittext_char(entry, "-")
			if (length(entry) != 2)
				log_debug("Invalid entry in allow_list_job.txt: [jointext(entry, "-")]")
				continue
			var/ckey = ckey(entry[1])
			var/job = ckey(entry[2])
			if (!ckey || !job)
				log_debug("Invalid entry in allow_list_job.txt: [jointext(entry, "-")]")
				continue
			var/list/user = into[ckey]
			if (!user)
				user = list()
				into[ckey] = user
			user += job
	return into


/// Loads the various allow lists at startup.
/hook/startup/proc/LoadAllowLists()
	if (config.use_allow_list_job)
		GLOB.allow_list_job = load_allow_list("config/allow_list_job.txt")
	if (config.use_allow_list_species)
		GLOB.allow_list_species = load_allow_list("config/allow_list_species.txt")
	if (config.use_allow_list_language)
		GLOB.allow_list_language = load_allow_list("config/allow_list_language.txt")
	if (config.use_allow_list_sprite_accessory)
		GLOB.allow_list_sprite_accessory = load_allow_list("config/allow_list_sprite_accessory.txt")
	return TRUE
