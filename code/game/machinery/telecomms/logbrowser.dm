/obj/machinery/computer/telecomms/server
	name = "Telecommunications Server Monitor"
	desc = "View communication logs here. Translation not guaranteed."
	icon_screen = "comm_logs"
	icon_keyboard = "tech_key"
	circuit = /obj/item/circuitboard/comm_server
	req_access = list(access_tcomsat)
	var/list/servers = list() // the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedServer
	var/network = "NULL" // the network to probe
	var/list/temp // temporary feedback messages
	var/universal_translate = FALSE // set to 1 if it can translate nonhuman speech


/obj/machinery/computer/telecomms/server/tgui_data(mob/user)
	var/list/data = list()
	data["universal_translate"] = universal_translate
	data["network"] = network
	data["temp"] = temp
	var/list/servers = list()
	for(var/obj/machinery/telecomms/machine in servers)
		servers += list(list(
			"id" = machine.id,
			"name" = machine.name,
		))
	data["servers"] = servers
	data["selectedServer"] = null
	if (SelectedServer)
		data["selectedServer"] = list(
			"id" = SelectedServer.id,
			"totalTraffic" = SelectedServer.totaltraffic,
		)
		var/i = 0
		var/list/logs = list()
		for (var/datum/comm_log_entry/log as anything in SelectedServer.log_entries)
			var/static/list/acceptable_params = list("uspeech", "intelligible", "message", "name", "race", "job", "timecode")
			var/list/parameters = list()
			for (var/log_param in acceptable_params)
				parameters["[log_param]"] = log.parameters["[log_param]"]
			logs += list(list(
				"name" = log.name,
				"input_type" = log.input_type,
				"id" = ++i,
				"parameters" = parameters,
			))
		data["selectedServer"]["logs"] = logs
	return data


/obj/machinery/computer/telecomms/server/attack_hand(mob/user)
	if (stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)


/obj/machinery/computer/telecomms/server/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new (user, src, "TelecommsLogBrowser", name)
		ui.open()


/obj/machinery/computer/telecomms/server/tgui_act(action, params)
	if (..())
		return TRUE
	add_fingerprint(usr)
	switch(action)
		if ("view")
			for (var/obj/machinery/telecomms/machine in servers)
				if (machine.id == params["id"])
					SelectedServer = machine
					break
			. = TRUE
		if ("mainmenu")
			SelectedServer = null
			. = TRUE
		if ("release")
			servers = list()
			SelectedServer = null
			. = TRUE
		if ("scan")
			if (length(servers))
				set_temp("FAILED: CANNOT PROBE WHEN BUFFER FULL", "bad")
				return TRUE
			for (var/obj/machinery/telecomms/server/server in range(25, src))
				if (server.network == network)
					servers += server
			if (length(servers))
				set_temp("[servers.len] SERVERS PROBED & BUFFERED", "good")
			else
				set_temp("FAILED: UNABLE TO LOCATE SERVERS IN \[[network]\]", "bad")
			. = TRUE
		if ("delete")
			if (!allowed(usr) && !emagged)
				to_chat(usr, "<span class='warning'>ACCESS DENIED.</span>")
				return
			if (SelectedServer)
				var/datum/comm_log_entry/log = SelectedServer.log_entries[text2num(params["id"])]
				set_temp("DELETED ENTRY: [log.name]", "bad")
				SelectedServer.log_entries -= log
				qdel(log)
			else
				set_temp("FAILED: NO SELECTED MACHINE", "bad")
			. = TRUE
		if ("network")
			var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null | text
			if (newnet && (issilicon(usr) || (usr in range(1, src))))
				if (length(newnet) > 15)
					set_temp("FAILED: NETWORK TAG STRING TOO LENGTHY", "bad")
					return TRUE
				network = newnet
				servers = list()
				set_temp("NEW NETWORK TAG SET IN ADDRESS \[[network]\]", "good")
			. = TRUE
		if ("cleartemp")
			temp = null
			. = TRUE


/obj/machinery/computer/telecomms/server/emag_act(remaining_charges, mob/user)
	if (emagged)
		return
	playsound(src, 'sound/effects/sparks4.ogg', 75, TRUE)
	emagged = TRUE
	to_chat(user, SPAN_NOTICE("You you disable the security protocols"))
	updateUsrDialog()
	return 1


/obj/machinery/computer/telecomms/server/proc/set_temp(text, color = "average")
	temp = list("color" = color, "text" = text)
