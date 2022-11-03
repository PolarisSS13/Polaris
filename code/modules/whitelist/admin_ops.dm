// Rewrites the client's whitelists to disk
/proc/write_whitelist(var/key, var/list/whitelist)
	var/filename = "data/player_saves/[copytext(ckey(key),1,2)]/[ckey(key)]/whitelist.json"
	log_admin("Writing whitelists to disk for [key] at `[filename]`")
	try
		// Byond doesn't have a mechanism for in-place modification of a file, so we have to make a new one and then overwrite the old one.
		// If this is interrupted, the .tmp file exists and can be loaded at the start of the next round.
		// The in-game list represents the set of valid entries within the whitelist file, so we may as well remove invalid lines in the process.
		var/list/L = list()
		for(var/decl/whitelist/W in whitelist)
			L += W.uid
		text2file(
			json_encode(list("version" = WHITELIST_REV, "whitelists" = L)),
			filename + ".tmp")
		if(fexists(filename) && !fdel(filename))
			error("Exception when overwriting whitelist file [filename]")
		if(fcopy(filename + ".tmp", filename))
			if(!fdel(filename + ".tmp"))
				error("Exception when deleting tmp whitelist file [filename].tmp")
	catch(var/exception/E)
		error("Exception when writing to whitelist file [filename]: [E]")


// Add the selected path to the player's whitelists, if it's valid.
/client/proc/add_whitelist(var/decl/whitelist/D)
	if(!istype(D))
		return
	// If they're already whitelisted, do nothing (Also loads the whitelist)
	if(is_whitelisted(D))
		return

	log_and_message_admins("[usr ? usr : "SYSTEM"] giving [D.display_name] whitelist to [src]", usr)
	src.whitelists += D
	write_whitelist(src.ckey, src.whitelists)

// Remove the selected path from the player's whitelists.
/client/proc/remove_whitelist(var/decl/whitelist/D)
	if(!istype(D))
		return
	// If they're not whitelisted, do nothing (Also loads the whitelist)
	if(!is_whitelisted(D))
		return

	log_and_message_admins("[usr ? usr : "SYSTEM"] removing [D.display_name] whitelist from [src]", usr)
	src.whitelists -= D
	write_whitelist(src.ckey, src.whitelists)


/client/proc/admin_add_whitelist()
	set name = "Whitelist Add Player"
	set category = "Admin"
	set desc = "Whitelist a target player for something"
	admin_modify_whitelist(TRUE)


/client/proc/admin_del_whitelist()
	set name = "Whitelist Remove Player"
	set category = "Admin"
	set desc = "Remove a whitelist from the target player"
	admin_modify_whitelist(FALSE)


/client/proc/admin_modify_whitelist(var/set_value, var/key = null)
	if(!check_rights(R_ADMIN|R_DEBUG))
		return

	// Get the person to whitelist.
	if(!key)
		key = input(src, "Please enter the CKEY of the player whose whitelist you wish to modify:", "Whitelist ckey", "") as text|null
	if(!key || !length(key))
		return

	key = ckey(key)
	if(!fexists("data/player_saves/[copytext(key,1,2)]/[key]/preferences.sav"))
		to_chat(src, "That player doesn't seem to exist...")
		return

	// Get the whitelist thing to modify.
	var/decl/whitelist/to_modify = null
	var/list/whitelistable = list()
	for(var/decl/whitelist/W in decls_repository.get_decls_unassociated(subtypesof(/decl/whitelist)))
		whitelistable += W.display_name
	var/entry = input(src, "Please enter the path of the whitelist you wish to modify:", "Whitelist target", "") as null|anything in whitelistable
	if(!entry)
		return
	for(var/decl/whitelist/W in decls_repository.get_decls_unassociated(subtypesof(/decl/whitelist)))
		if(entry == W.display_name)
			to_modify = W
			break
	if(!istype(to_modify))
		return

	// If they're logged in, modify it directly.
	var/client/C = ckey2client(key)
	if(istype(C))
		set_value ? C.add_whitelist(to_modify) : C.remove_whitelist(to_modify)
		return

	log_and_message_admins("[src] [set_value ? "giving [to_modify.display_name] whitelist to" : "removing [to_modify.display_name] whitelist from"] [key]", src)

	// Else, we have to find and modify the whitelist file ourselves.
	var/list/whitelists = load_whitelist(key)

	// They're already whitelisted.
	if(whitelists[entry] == set_value)
		return

	if(set_value)
		whitelists += to_modify
	else
		whitelists -= to_modify
	write_whitelist(key, whitelists)


/client/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_ADD_WHITELIST, "Add whitelist")
	VV_DROPDOWN_OPTION(VV_HK_DEL_WHITELIST, "Remove whitelist")


/client/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION(VV_HK_ADD_WHITELIST)
		if(!check_rights(R_ADMIN|R_DEBUG))
			return
		var/client/C = locate(href_list["target"])
		if(istype(C))
			admin_modify_whitelist(TRUE, C.ckey)
	IF_VV_OPTION(VV_HK_DEL_WHITELIST)
		if(!check_rights(R_ADMIN|R_DEBUG))
			return
		var/client/C = locate(href_list["target"])
		if(istype(C))
			admin_modify_whitelist(FALSE, C.ckey)
