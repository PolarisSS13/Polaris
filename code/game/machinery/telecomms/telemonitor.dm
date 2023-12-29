/* Telecomms Monitor
* Tracks the overall trafficing of a telecommunications network and
* displays a heirarchy of linked machines.
*/

/obj/machinery/computer/telecomms/monitor
	name = "Telecommunications Monitor"
	desc = "Used to traverse a telecommunication network. Helpful for debugging connection issues."
	icon_screen = "comm_monitor"
	icon_keyboard = "tech_key"
	circuit = /obj/item/circuitboard/comm_monitor
	var/screen = 0 // the screen number
	var/obj/machinery/telecomms/SelectedMachine
	var/list/machinelist = list()	// the machines located by the computer
	var/network = "NULL" // the network to probe
	var/list/temp // temporary feedback messages


/obj/machinery/computer/telecomms/monitor/Destroy()
	LAZYCLEARLIST(machinelist)
	SelectedMachine = null
	return ..()


/obj/machinery/computer/telecomms/monitor/attack_hand(mob/user)
	if (stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)


/obj/machinery/computer/telecomms/monitor/emag_act(remaining_charges, mob/user)
	if (emagged)
		return
	playsound(src, 'sound/effects/sparks4.ogg', 75, TRUE)
	emagged = TRUE
	to_chat(user, SPAN_NOTICE("You you disable the security protocols"))
	updateUsrDialog()
	return 1


/obj/machinery/computer/telecomms/monitor/tgui_act(action, params)
	if (..())
		return TRUE
	add_fingerprint(usr)
	switch (action)
		if ("view")
			for (var/obj/machinery/telecomms/machine in machinelist)
				if (machine.id == params["id"])
					SelectedMachine = machine
					break
			. = TRUE
		if ("mainmenu")
			SelectedMachine = null
			. = TRUE
		if ("release")
			machinelist = list()
			SelectedMachine = null
			. = TRUE
		if ("scan")
			if (length(machinelist))
				set_temp("FAILED: CANNOT PROBE WHEN BUFFER FULL", "bad")
				return TRUE
			for (var/obj/machinery/telecomms/machine in range(25, src))
				if (machine.network == network)
					machinelist += machine
			if(length(machinelist))
				set_temp("[machinelist.len] ENTITIES LOCATED & BUFFERED", "good")
			else
				set_temp("FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN \[[network]\]", "bad")
			. = TRUE
		if ("network")
			var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null | text
			if (newnet && (issilicon(usr) || (usr in range(1, src))))
				if (length(newnet) > 15)
					set_temp("FAILED: NETWORK TAG STRING TOO LENGTHY", "bad")
					return TRUE
				network = newnet
				machinelist = list()
				set_temp("NEW NETWORK TAG SET IN ADDRESS \[[network]\]", "good")
			. = TRUE
		if ("cleartemp")
			temp = null
			. = TRUE


/obj/machinery/computer/telecomms/monitor/tgui_data(mob/user)
	var/list/data = list()
	data["network"] = network
	data["temp"] = temp
	var/list/machinelist = list()
	for (var/obj/machinery/telecomms/machine in machinelist)
		machinelist += list(list(
			"id" = machine.id,
			"name" = machine.name,
		))
	data["machinelist"] = machinelist
	data["selectedMachine"] = null
	if (!SelectedMachine)
		return data
	data["selectedMachine"] = list(
		"id" = SelectedMachine.id,
		"name" = SelectedMachine.name,
	)
	var/list/links = list()
	for (var/obj/machinery/telecomms/machine in SelectedMachine.links)
		if (machine.hide)
			continue
		links += list(list(
			"id" = machine.id,
			"name" = machine.name
		))
	data["selectedMachine"]["links"] = links
	return data


/obj/machinery/computer/telecomms/monitor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "TelecommsMachineBrowser", name)
		ui.open()


/obj/machinery/computer/telecomms/monitor/proc/set_temp(text, color = "average")
	temp = list("color" = color, "text" = text)
