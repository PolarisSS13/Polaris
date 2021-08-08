
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	for(var/client/C in GLOB.clients)
		if(!check_rights_for(src, R_ADMIN|R_MOD))
			Lines += "\t[C.holder?.fakekey || C.key]"
			continue
		var/entry = "\t[C.key]"
		if(C.holder?.fakekey)
			entry += " <i>(as [C.holder.fakekey])</i>"
		entry += " - Playing as [C.mob.real_name]"
		switch(C.mob.stat)
			if(UNCONSCIOUS)
				entry += " - <font color='darkgray'><b>Unconscious</b></font>"
			if(DEAD)
				if(isobserver(C.mob))
					var/mob/observer/dead/O = C.mob
					if(O.started_as_observer)
						entry += " - <font color='gray'>Observing</font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
				else
					entry += " - <font color='black'><b>DEAD</b></font>"

		if(C.player_age != initial(C.player_age) && isnum(C.player_age)) // database is on
			var/age = C.player_age
			switch(age)
				if(0 to 1)
					age = "<font color='#ff0000'><b>[age] days old</b></font>"
				if(1 to 10)
					age = "<font color='#ff8c00'><b>[age] days old</b></font>"
				else
					entry += " - [age] days old"

		if(is_special_character(C.mob))
			entry += " - <b><font color='red'>Antagonist</font></b>"

		if(C.is_afk())
			var/seconds = C.last_activity_seconds()
			entry += " (AFK - [round(seconds / 60)] minutes, [seconds % 60] seconds)"

		entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
		Lines += entry

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	to_chat(src,msg)

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/msg = ""
	var/modmsg = ""
	var/devmsg = ""
	var/eventMmsg = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	var/num_devs_online = 0
	var/num_event_managers_online = 0
	for(var/client/C in admins)
		var/temp = ""
		var/category = R_ADMIN
		if(check_rights(R_ADMIN, FALSE, C)) // admins
			if(C.holder.fakekey && !check_rights_for(src, R_ADMIN|R_MOD))	// Only admins and mods can see stealthmins
				continue
			num_admins_online++
		else if(check_rights(R_MOD, FALSE, C)) // mods
			category = R_MOD
			num_mods_online++
		else if(check_rights(R_SERVER, FALSE, C)) // developers
			category = R_SERVER
			num_devs_online++
		else if(check_rights(R_EVENT, FALSE, C)) // event managers
			category = R_EVENT
			num_event_managers_online++
		
		temp += "\t[C] is a [C.holder.rank]"
		if(holder)
			if(C.holder.fakekey)
				temp += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				temp += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				temp += " - Lobby"
			else
				temp += " - Playing"

			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				temp += " (AFK - [round(seconds / 60)] minutes, [seconds % 60] seconds)"
		temp += "\n"
		switch(category)
			if(R_ADMIN)
				msg += temp
			if(R_MOD)
				modmsg += temp
			if(R_SERVER)
				devmsg += temp
			if(R_EVENT)
				eventMmsg += temp

	if(config.admin_irc)
		to_chat(src, "<span class='info'>Adminhelps are also sent to IRC. If no admins are available in game try anyway and an admin on IRC may see it and respond.</span>")
	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg

	if(config.show_mods)
		msg += "\n<b> Current Moderators ([num_mods_online]):</b>\n" + modmsg

	if(config.show_devs)
		msg += "\n<b> Current Developers ([num_devs_online]):</b>\n" + devmsg

	if(config.show_event_managers)
		msg += "\n<b> Current Event Managers ([num_event_managers_online]):</b>\n" + eventMmsg

	to_chat(src,msg)
