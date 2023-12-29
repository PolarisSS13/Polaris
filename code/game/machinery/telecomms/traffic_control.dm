/obj/machinery/computer/telecomms/traffic
	name = "Telecommunications Traffic Control"
	desc = "Used to upload code to telecommunication consoles for execution."
	icon_screen = "generic"
	icon_keyboard = "tech_key"
	circuit = /obj/item/circuitboard/comm_traffic
	req_access = list(access_tcomsat)
	var/const/SCREEN_MAIN_MENU = 0
	var/const/SCREEN_VIEW_SERVER = 1
	var/screen = SCREEN_MAIN_MENU
	var/list/servers = list()	// the servers located by the computer
	var/mob/editingcode
	var/mob/lasteditor
	var/list/viewingcode = list()
	var/obj/machinery/telecomms/server/SelectedServer
	var/network = "NULL" // the network to probe
	var/temp = "" // temporary feedback messages
	var/storedcode = "" // code stored


/obj/machinery/computer/telecomms/traffic/Destroy()
	if (editingcode)
		winshow(editingcode, "Telecomms IDE", FALSE)
		editingcode.unset_machine()
		editingcode = null
	for (var/mob/viewer in viewingcode)
		winshow(viewer, "Telecomms IDE", FALSE)
		viewer.unset_machine()
	LAZYCLEARLIST(viewingcode)
	SelectedServer = null
	return ..()


/obj/machinery/computer/telecomms/traffic/attack_hand(mob/user)
	if (stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	var/dat = "<TITLE>Telecommunication Traffic Control</TITLE><center><b>Telecommunications Traffic Control</b></center>"
	switch(screen)
		if (SCREEN_MAIN_MENU) // Main Menu
			dat += "<br>[temp]<br>"
			dat += "<br>Current Network: <a href='?src=\ref[src];network=1'>[network]</a><br>"
			if(length(servers))
				dat += "<br>Detected Telecommunication Servers:<ul>"
				for(var/obj/machinery/telecomms/machine in servers)
					dat += "<li><a href='?src=\ref[src];viewserver=[machine.id]'>\ref[machine] [machine.name]</a> ([machine.id])</li>"
				dat += "</ul>"
				dat += "<br><a href='?src=\ref[src];operation=release'>\[Flush Buffer\]</a>"
			else
				dat += "<br>No servers detected. Scan for servers: <a href='?src=\ref[src];operation=scan'>\[Scan\]</a>"
		if (SCREEN_VIEW_SERVER) // Viewing Server
			dat += "<br>[temp]<br>"
			dat += "<center><a href='?src=\ref[src];operation=mainmenu'>\[Main Menu\]</a>     <a href='?src=\ref[src];operation=refresh'>\[Refresh\]</a></center>"
			dat += "<br>Current Network: [network]"
			dat += "<br>Selected Server: [SelectedServer.id]<br><br>"
			dat += "<br><a href='?src=\ref[src];operation=editcode'>\[Edit Code\]</a>"
			dat += "<br>Signal Execution: "
			if (SelectedServer.autoruncode)
				dat += "<a href='?src=\ref[src];operation=togglerun'>ALWAYS</a>"
			else
				dat += "<a href='?src=\ref[src];operation=togglerun'>NEVER</a>"
	user << browse(dat, "window=traffic_control;size=575x400")
	onclose(user, "server_control")
	temp = ""
	return


/obj/machinery/computer/telecomms/traffic/emag_act(remaining_charges, mob/user)
	if (emagged)
		return
	playsound(src, 'sound/effects/sparks4.ogg', 75, TRUE)
	emagged = TRUE
	to_chat(user, SPAN_NOTICE("You you disable the security protocols"))
	updateUsrDialog()
	return 1


/obj/machinery/computer/telecomms/traffic/Topic(href, href_list)
	if (..())
		return
	add_fingerprint(usr)
	usr.set_machine(src)
	if (!emagged && !allowed(usr))
		to_chat(usr, "<span class='warning'>ACCESS DENIED.</span>")
		return
	if (href_list["viewserver"])
		screen = SCREEN_VIEW_SERVER
		for (var/obj/machinery/telecomms/machine in servers)
			if(machine.id == href_list["viewserver"])
				SelectedServer = machine
				break
	if (href_list["operation"])
		switch (href_list["operation"])
			if ("release")
				servers = list()
				screen = SCREEN_MAIN_MENU
			if ("mainmenu")
				screen = SCREEN_MAIN_MENU
			if ("scan")
				if(length(servers))
					temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font>"
				else
					for (var/obj/machinery/telecomms/server/server in range(25, src))
						if (server.network == network)
							servers += server
					if(!length(servers))
						temp = "<font color = #336699>- 0 SERVERS PROBED & BUFFERED -</font>"
					else
						temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE SERVERS IN \[[network]\] -</font>"
					screen = SCREEN_MAIN_MENU
			if ("editcode")
				if (editingcode == usr)
					return
				if (usr in viewingcode)
					return
				if (!editingcode)
					lasteditor = usr
					editingcode = usr
					winshow(editingcode, "Telecomms IDE", TRUE)
					winset(editingcode, "tcscode", "is-disabled=false")
					winset(editingcode, "tcscode", "text=\"\"")
					var/showcode = replacetext(storedcode, "\\\"", "\\\\\"")
					showcode = replacetext(storedcode, "\"", "\\\"")
					winset(editingcode, "tcscode", "text=\"[showcode]\"")
					spawn()
						update_ide()
				else
					viewingcode += usr
					winshow(usr, "Telecomms IDE", TRUE)
					winset(usr, "tcscode", "is-disabled=true")
					winset(editingcode, "tcscode", "text=\"\"")
					var/showcode = replacetext(storedcode, "\"", "\\\"")
					winset(usr, "tcscode", "text=\"[showcode]\"")
			if ("togglerun")
				SelectedServer.autoruncode = !(SelectedServer.autoruncode)
	if (href_list["network"])
		var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null | text
		if(newnet && (issilicon(usr) || (usr in range(1, src))))
			if(length(newnet) > 15)
				temp = "<font color = #D70B00>- FAILED: NETWORK TAG STRING TOO LENGHTY -</font>"
			else
				network = newnet
				screen = SCREEN_MAIN_MENU
				servers = list()
				temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -</font>"
	updateUsrDialog()


/obj/machinery/computer/telecomms/traffic/proc/update_ide()
	while (editingcode)
		if (!editingcode.client)
			editingcode = null
			break
		if (editingcode)
			storedcode = "[winget(editingcode, "tcscode", "text")]"
		if (editingcode)
			winset(editingcode, "tcscode", "is-disabled=false")
		if (!issilicon(editingcode) && (editingcode.machine != src || !(editingcode in range(1, src))))
			if (editingcode)
				winshow(editingcode, "Telecomms IDE", FALSE)
			editingcode = null
			break
		if (length(viewingcode))
			var/showcode = replacetext(storedcode, "\\\"", "\\\\\"")
			showcode = replacetext(storedcode, "\"", "\\\"")
			for (var/mob/viewer in viewingcode)
				if (issilicon(viewer) || (viewer.machine == src && (viewer in view(1, src))))
					winset(viewer, "tcscode", "is-disabled=true")
					winset(viewer, "tcscode", "text=\"[showcode]\"")
				else
					viewingcode -= viewer
					winshow(viewer, "Telecomms IDE", FALSE)
		sleep(5)
	if (length(viewingcode))
		editingcode = pick(viewingcode)
		viewingcode -= editingcode
		update_ide()
