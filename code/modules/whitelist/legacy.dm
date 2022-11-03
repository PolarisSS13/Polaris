// Proc to convert the old whitelist systems into the new, shiny, modern system.
// This has to do a lot of file I/O because it handles _everyone's_ whitelists, so it's expected to be pretty expensive.
// Hence, this has to be manually called by an admin.
/proc/load_legacy_whitelist()
	var/static/list/alienwhitelist_dict = list(
		"Alai" = /datum/language/tajsign,
		"Common Skrellian" = /datum/language/skrell,
		"Diona" = /datum/species/diona,
		"Promethean" = /datum/species/shapeshifter/promethean,
		"Schechi" = /datum/language/teshari,
		"Siik" = /datum/language/tajaran,
		"Sinta'Unathi" = /datum/language/unathi,
		"Skrell" = /datum/species/skrell,
		"Sol Common" = /datum/language/human,
		"Tajara" = /datum/species/tajaran,
		"Teshari" = /datum/species/teshari,
		"Unathi" = /datum/species/unathi,
		"Zaddat" = /datum/species/zaddat,
	)

	var/list/whitelists_to_write = list()

	// Load in the alien whitelists
	for(var/line in read_lines("config/alienwhitelist.txt"))
		if(!length(line))
			continue
		var/static/regex/R = regex(" - ")
		var/list/tok = splittext(line, R)
		// Whitelist is no longer valid.
		if(length(tok) < 2 || !(tok[2] in alienwhitelist_dict))
			continue

		var/key = ckey(tok[1])
		// If they don't have a preferences save file, then they probably don't play here any more.
		if(!fexists("data/player_saves/[copytext(key,1,2)]/[key]/preferences.sav"))
			continue

		LAZYADDASSOC(whitelists_to_write[key], alienwhitelist_dict[tok[2]], TRUE)

	// Load in the genemod whitelist
	for(var/line in read_commentable("config/genemodwhitelist.txt"))
		var/key = ckey(line)
		// If they don't have a preferences save file, then they probably don't play here any more.
		if(!fexists("data/player_saves/[copytext(key,1,2)]/[key]/preferences.sav"))
			continue

		LAZYADDASSOC(whitelists_to_write[key], "/whitelist/genemod", TRUE)

	// Write the whitelists to files. Second stage, so we don't make a million individual writes.
	for(var/key in whitelists_to_write)
		var/filename = "data/player_saves/[copytext(key,1,2)]/[key]/whitelist.json"
		var/list/whitelist = whitelists_to_write[key]
		try
			// If the file already exists, don't just blindly overwrite it.
			if(fexists(filename))
				var/prior_whitelist = file2text(filename) || ""
				if(length(prior_whitelist))
					whitelist |= json_decode(prior_whitelist)
			text2file(json_encode(whitelist), filename + ".tmp")
			if(fexists(filename) && !fdel(filename))
				error("Error overwriting whitelist file [filename]")
			if(!fcopy(filename + ".tmp", filename) || !fdel(filename + ".tmp"))
				error("Exception when deleting tmp whitelist file [filename].tmp")
		catch(var/exception/E)
			error("Exception when writing to whitelist file [filename]: [E]")

/proc/translate_whitelist_v1_1(var/list/decode)
	var/static/list/alienwhitelist_dict_v1_1 = list(
		"/datum/language/human" = /decl/whitelist/language/human,
		"/datum/language/skrell" = /decl/whitelist/language/skrell,
		"/datum/language/skrellfar" = /decl/whitelist/language/skrell/high,
		"/datum/language/teshari" = /decl/whitelist/language/teshari,
		"/datum/language/akhani" = /decl/whitelist/language/taj/akhani,
		"/datum/language/tajaran" = /decl/whitelist/language/taj,
		"/datum/language/tajsign" = /decl/whitelist/language/taj/sign,
		"/datum/language/unathi" = /decl/whitelist/language/unathi,
		"/datum/species/diona" = /decl/whitelist/species/diona,
		"/datum/species/shapeshifter/promethean" = /decl/whitelist/species/promethean,
		"/datum/species/skrell" = /decl/whitelist/species/skrell,
		"/datum/species/tajaran" = /decl/whitelist/species/tajara,
		"/datum/species/teshari" = /decl/whitelist/species/teshari,
		"/datum/species/unathi" = /decl/whitelist/species/unathi,
		"/datum/species/vox" = /decl/whitelist/species/vox,
		"/datum/species/zaddat" = /decl/whitelist/species/zaddat,
		"/whitelist/genemod" = /decl/whitelist/genemod,
	)

	. = list()
	for(var/T in decode)
		var/decl/D
		var/P = text2path(T)
		if(ispath(P))
			var/datum/d = P
			D = GET_DECL(initial(d.whitelist_decl))
		else if(T in alienwhitelist_dict_v1_1)
			D = GET_DECL(alienwhitelist_dict_v1_1[T])

		if(istype(D))
			. += D
