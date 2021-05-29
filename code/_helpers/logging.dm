//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""


/proc/error(msg)
	to_world_log("## ERROR: [msg][log_end]")

#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	to_world_log("## WARNING: [msg][log_end]")

//print a testing-mode debug message to world.log
/proc/testing(msg)
	to_world_log("## TESTING: [msg][log_end]")

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"

/proc/log_adminpm(text, client/source, client/dest)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMINPM: [key_name(source)]->[key_name(dest)]: [html_decode(text)][log_end]"

/proc/log_debug(text)
	if (config.log_debug)
		debug_log << "\[[time_stamp()]]DEBUG: [text][log_end]"

	for(var/client/C in admins)
		if(C.is_preference_enabled(/datum/client_preference/debug/show_debug_logs))
			to_chat(C, "<span class='filter_debuglog'>DEBUG: [text]</span>")

/proc/log_game(text)
	if (config.log_game)
		diary << "\[[time_stamp()]]GAME: [text][log_end]"

/proc/log_vote(text)
	if (config.log_vote)
		diary << "\[[time_stamp()]]VOTE: [text][log_end]"

/proc/log_access_in(client/new_client)
	if (config.log_access)
		var/message = "[key_name(new_client)] - IP:[new_client.address] - CID:[new_client.computer_id] - BYOND v[new_client.byond_version]"
		diary << "\[[time_stamp()]]ACCESS IN: [message][log_end]"

/proc/log_access_out(mob/last_mob)
	if (config.log_access)
		var/message = "[key_name(last_mob)] - IP:[last_mob.lastKnownIP] - CID:Logged Out - BYOND Logged Out"
		diary << "\[[time_stamp()]]ACCESS OUT: [message][log_end]"

/proc/log_say(text, mob/speaker)
	if (config.log_say)
		diary << "\[[time_stamp()]]SAY: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

	//Log the message to in-game dialogue logs, as well.
	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:#32cd32\">[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:#32cd32\">[text]</span>"

/proc/log_ooc(text, client/user)
	if (config.log_ooc)
		diary << "\[[time_stamp()]]OOC: [user.simple_info_line()]: [html_decode(text)][log_end]"

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>OOC:</u> - <span style=\"color:blue\"><b>[text]</b></span>"

/proc/log_aooc(text, client/user)
	if (config.log_ooc)
		diary << "\[[time_stamp()]]AOOC: [user.simple_info_line()]: [html_decode(text)][log_end]"

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>AOOC:</u> - <span style=\"color:red\"><b>[text]</b></span>"

/proc/log_looc(text, client/user)
	if (config.log_ooc)
		diary << "\[[time_stamp()]]LOOC: [user.simple_info_line()]: [html_decode(text)][log_end]"

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>LOOC:</u> - <span style=\"color:orange\"><b>[text]</b></span>"

/proc/log_whisper(text, mob/speaker)
	if (config.log_whisper)
		diary << "\[[time_stamp()]]WHISPER: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:gray\"><i>[text]</i></span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:gray\"><i>[text]</i></span>"


/proc/log_emote(text, mob/speaker)
	if (config.log_emote)
		diary << "\[[time_stamp()]]EMOTE: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style=\"color:#CCBADC\">[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style=\"color:#CCBADC\">[text]</span>"

/proc/log_attack(attacker, defender, message)
	if (config.log_attack)
		diary << "\[[time_stamp()]]ATTACK: [attacker] against [defender]: [message][log_end]"

/proc/log_adminsay(text, mob/speaker)
	if (config.log_adminchat)
		diary << "\[[time_stamp()]]ADMINSAY: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

/proc/log_modsay(text, mob/speaker)
	if (config.log_adminchat)
		diary << "\[[time_stamp()]]MODSAY: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

/proc/log_eventsay(text, mob/speaker)
	if (config.log_adminchat)
		diary << "\[[time_stamp()]]EVENTSAY: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

/proc/log_ghostsay(text, mob/speaker)
	if (config.log_say)
		diary << "\[[time_stamp()]]DEADCHAT: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - <span style=\"color:green\">[text]</span>"
	GLOB.round_text_log += "<font size=1><span style=\"color:#7e668c\"><b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - [text]</span></font>"


/proc/log_ghostemote(text, mob/speaker)
	if (config.log_emote)
		diary << "\[[time_stamp()]]DEADEMOTE: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		diary << "\[[time_stamp()]]ADMINWARN: [html_decode(text)][log_end]"

/proc/log_pda(text, mob/speaker)
	if (config.log_pda)
		diary << "\[[time_stamp()]]PDA: [speaker.simple_info_line()]: [html_decode(text)][log_end]"

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style=\"color:[COLOR_GREEN]\">[text]</span>"
	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style=\"color:[COLOR_GREEN]\">[text]</span>"


/proc/log_to_dd(text)
	to_world_log(text) //this comes before the config check because it can't possibly runtime
	if(config.log_world_output)
		diary << "\[[time_stamp()]]DD_OUTPUT: [text][log_end]"

/proc/log_error(text)
	to_world_log(text)
	error_log << "\[[time_stamp()]]RUNTIME: [text][log_end]"

/proc/log_misc(text)
	diary << "\[[time_stamp()]]MISC: [text][log_end]"

/proc/log_unit_test(text)
	to_world_log("## UNIT_TEST: [text]")

/proc/log_tgui(user_or_client, text)
	var/entry = ""
	if(!user_or_client)
		entry += "no user"
	else if(istype(user_or_client, /mob))
		var/mob/user = user_or_client
		entry += "[user.ckey] (as [user])"
	else if(istype(user_or_client, /client))
		var/client/client = user_or_client
		entry += "[client.ckey]"
	entry += ":\n[text]"
	diary << "\[[time_stamp()]]TGUI: [entry][log_end]"

/proc/log_asset(text)
	diary << "\[time_stamp()]] ASSET: [text]"

/proc/report_progress(var/progress_message)
	admin_notice("<span class='boldannounce'>[progress_message]</span>", R_DEBUG)
	to_world_log(progress_message)

//pretty print a direction bitflag, can be useful for debugging.
/proc/print_dir(var/dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")

//more or less a logging utility
//Always return "Something/(Something)", even if it's an error message.
/proc/key_name(var/whom, var/include_link = FALSE, var/include_name = TRUE, var/highlight_special_characters = TRUE)
	var/mob/M
	var/client/C
	var/key

	if(!whom)
		return "INVALID/INVALID"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
	else if(istype(whom, /datum/mind))
		var/datum/mind/D = whom
		key = D.key
		M = D.current
		if(D.current)
			C = D.current.client
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "INVALID/([D.type])"
	else if(istext(whom))
		return "AUTOMATED/[whom]" //Just give them the text back
	else
		return "INVALID/INVALID"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_msg=\ref[C]'>"

		if(C && C.holder && C.holder.fakekey)
			. += "Administrator"
		else
			. += key

		if(include_link)
			if(C)	. += "</a>"
			else	. += " (DC)"
	else
		. += "INVALID"

	if(include_name)
		var/name = "INVALID"
		if(M)
			if(M.real_name)
				name = M.real_name
			else if(M.name)
				name = M.name

			if(include_link && is_special_character(M) && highlight_special_characters)
				name = "<font color='#FFA500'>[name]</font>" //Orange

		. += "/([name])"

	return .

/proc/key_name_admin(var/whom, var/include_name = 1)
	return key_name(whom, 1, include_name)

// Helper procs for building detailed log lines
/datum/proc/log_info_line()
	return "[src] ([type])"

/atom/log_info_line()
	var/turf/t = get_turf(src)
	if(istype(t))
		return "([t]) ([t.x],[t.y],[t.z]) ([t.type])"
	else if(loc)
		return "([loc]) (0,0,0) ([loc.type])"
	else
		return "(NULL) (0,0,0) (NULL)"

/mob/log_info_line()
	return "[..()] ([ckey])"

/proc/log_info_line(var/datum/d)
	if(!istype(d))
		return
	return d.log_info_line()

/mob/proc/simple_info_line()
	return "[key_name(src)] ([x],[y],[z])"

/client/proc/simple_info_line()
	return "[key_name(src)] ([mob.x],[mob.y],[mob.z])"
