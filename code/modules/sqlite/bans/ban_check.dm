//Blocks an attempt to connect before even creating our client datum thing.
/*
/world/IsBanned(key, address, computer_id)
	var/list/ban_check_result = sqlite_check_is_server_banned(key, address, computer_id)
	if(islist(ban_check_result))
		return ban_check_result
	return ..() //default pager ban stuff
*/

/proc/sqlite_check_is_server_banned(var/key, var/address, var/computer_id)
	if(isnull(computer_id))
		message_admins("[key] has logged in with a blank computer id in the ban check.")
	if(isnull(address))
		message_admins("[key] has logged in with a blank ip in the ban check.")

	// Guest checking.
	if(!config.guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("<font color='blue'>Failed Login: [key] - Guests not allowed</font>")
		return list("reason"="guest", "desc"="\nReason: Sorry! Guests are not allowed on this server. Please sign in with a BYOND account and rejoin.")

	// Check if the IP address is a known TOR node.
	if(config && config.ToRban && ToRban_isbanned(address))
		log_access("Failed Login: [src] - Banned: ToR")
		message_admins("\blue Failed Login: [src] - Banned: ToR")
		//ban their computer_id and ckey for posterity
		sqlite_add_ban(
			_ckey = ckey(key),
			_cid = computer_id,
			_reason = "Use of ToR",
			_banningkey = "Automated Ban"
			)
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a mistake, please request help at [config.banappeals]")

	// Server ban checking.
	var/ckeytext = ckey(key)
	for(var/thing in serverbans)
		var/datum/ban/B = thing
		if(B.data["ckey"] == ckeytext || B.data["cid"] == computer_id || B.data["ip"] == address)
			if(B.expired() || B.lifted() )
				continue
			var/desc = "\nReason: You, or another user of this computer or connection ([B.data["ckey"]]) is banned from playing here. The ban reason is:\n[B.data["reason"]]\nThis ban was applied by [B.data["banning_ckey"]] on [B.get_banned_datetime()] and expires [B.get_expiry_datetime() ? "on [B.get_expiry_datetime()]" : "NEVER"]."
			return list("reason"="[B.data["bantype"]]", "desc"="[desc]")

/proc/sqlite_check_is_jobbanned(var/mob/M, var/rank)
	if(!M || !rank)
		return FALSE

	rank = lowertext(rank)

	if(guest_jobbans(rank))
		if(config.guest_jobban && IsGuestKey(M.key))
			return "Guest Job-ban"
		if(config.usewhitelist && !check_whitelist(M))
			return "Whitelisted Job"
	for(var/datum/ban/JB in jobbans)
		if(M.ckey == JB.data["ckey"] && rank == JB.data["job"]) // Is it their ban?
			if(JB.expired() || JB.lifted() ) // If so, is it still in effect?
				continue
			return JB.data["reason"]
	return FALSE

/proc/server_isbanned(var/mob/M)
	if(!M)
		return 0
	for(var/thing in serverbans)
		var/datum/ban/B = thing
		if(M.ckey == B.data["ckey"] )
			return B.data["reason"]
	return 0