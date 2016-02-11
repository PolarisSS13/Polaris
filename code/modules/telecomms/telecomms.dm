var/list/obj/machinery/telecomms_machine/world_telecommunications = list()

/obj/machinery/telecomms_machine
	name = "Telecommunications Hub"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "hub"
	desc = "A mighty piece of hardware used to send/receive massive amounts of data."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 1600

	var/on = 1
	var/integrity = 100
	var/delay = 10

	var/list/channels = list()

/obj/machinery/telecomms_machine/New()
	..()
	world_telecommunications += src

/obj/machinery/telecomms_machine/Destroy()
	world_telecommunications -= src
	..()

/obj/machinery/telecomms_machine/update_icon()
	if(!src.on || (stat & (EMPED|NOPOWER|BROKEN)))
		icon_state = "hub_off"
	else
		icon_state = "hub"
	// Needs open panel icons

/obj/machinery/telecomms_machine/process()
	if(src.on)
		if(stat & (EMPED|NOPOWER|BROKEN))
			return
		var/datum/gas_mixture/environment = src.loc.return_air()
		var/damage_chance = 0 // Percent based chance of applying 1 integrity damage this tick
		switch(environment.temperature)
			if((T0C + 40) to (T0C + 70)) // 40C-70C, minor overheat, 10% chance of taking damage
				damage_chance = 10
			if((T0C + 70) to (T0C + 130)) // 70C-130C, major overheat, 25% chance of taking damage
				damage_chance = 25
			if((T0C + 130) to (T0C + 200)) // 130C-200C, dangerous overheat, 50% chance of taking damage
				damage_chance = 50
			if((T0C + 200) to INFINITY) // More than 200C, INFERNO. Takes damage every tick.
				damage_chance = 100

		if(damage_chance && prob(damage_chance))
			src.integrity = between(0, src.integrity - 1, 100)

		if(src.delay > 0)
			src.delay--
		else
			var/turf/simulated/L = src.loc
			if(istype(L))
				var/datum/gas_mixture/env = L.return_air()
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)
				if(removed)
					var/heat_produced = src.idle_power_usage	//obviously can't produce more heat than the machine draws from it's power source
					removed.add_thermal_energy(heat_produced)
				env.merge(removed)
			src.delay = initial(src.delay)

		if(!integrity)
			stat |= BROKEN

/obj/machinery/telecomms_machine/emp_act(var/severity)
	if(prob(100 / severity))
		if(!(stat & EMPED))
			stat |= EMPED
			var/duration = (300 * 10) / severity
			spawn(rand(duration - 20, duration + 20)) // Takes a long time for the machines to reboot.
				stat &= ~EMPED
	..()

/obj/machinery/telecomms_machine/attack_ai(var/mob/user)
	src.attack_hand(user)

/obj/machinery/telecomms_machine/attack_hand(var/mob/user)
	if(src.stat & (EMPED|NOPOWER|BROKEN))
		return
	var/dat = "<font face = \"Courier\"><HEAD><TITLE>[src.name]</TITLE></HEAD><center><H3>[src.name] Access</H3></center>"
	dat += "<br>Power Status: <a href='?src=\ref[src];toggle=1'>[src.on ? "On" : "Off"]</a>"
	dat += "<br>Operating frequencies: "
	if(src.channels.len)
		for(var/T in src.channels)
			dat += "[format_frequency(T)] GHz<a href='?src=\ref[src];delete=[T]'>\[X\]</a>; "
	else
		dat += "none; "
	dat += "<a href='?src=\ref[src];addfreq=1'>add new</a>."
	dat += "</font>"
	user << browse(dat, "window=tcommachine;size=520x500;can_resize=0")

/obj/machinery/telecomms_machine/Topic(href, href_list)
	if(src.stat & (EMPED|NOPOWER|BROKEN))
		return
	if(href_list["toggle"])
		src.on = !src.on
	else if(href_list["addfreq"])
		var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.") as null|num
		if(newfreq)
			if(findtext(num2text(newfreq), "."))
				newfreq *= 10 // shift the decimal one place
			if(!(newfreq in src.channels) && newfreq < 10000)
				src.channels.Add(newfreq)
	else if(href_list["delete"])
		var/x = text2num(href_list["delete"])
		src.channels.Remove(x)
	src.attack_hand(usr)

/obj/machinery/telecomms_machine/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

	if(istype(I, /obj/item/stack/nanopaste))
		if(integrity < 100)
			var/obj/item/stack/nanopaste/N = I
			if(N.use(1))
				stat &= ~BROKEN
				integrity = between(0, integrity + 35, 100)
				user.visible_message("<span class='notice'>\The [user] applies \the [N] to \the [src].</span>", "You apply \the [N] to \the [src], repairing [integrity == 100 ? "all" : "some"] of the damage.")
			return
		else
			user << "<span class='notice'>This machine is already in perfect condition.</span>"

/obj/machinery/telecomms_machine/common
	channels = list(PUB_FREQ)

/obj/machinery/telecomms_machine/allinone
	channels = list(PUB_FREQ, SCI_FREQ, COMM_FREQ, MED_FREQ, ENG_FREQ, SEC_FREQ, ERT_FREQ, DTH_FREQ, SYND_FREQ, SUP_FREQ, SRV_FREQ, AI_FREQ)

/obj/machinery/telecomms_machine/proc/processSignal(var/mob/living/source, var/mobName, var/sayVerb, var/message, var/freq, var/datum/language/speaking)
	if(!(freq in src.channels))
		return 0

	if(!src.isUsable())
		return 0

	broadcastMessage(source, mobName, sayVerb, message, freq, speaking, 0)
	return 1

/obj/machinery/telecomms_machine/proc/isUsable()
	if(!src.on)
		return 0
	if(stat & (EMPED|NOPOWER|BROKEN))
		return 0
	return 1

/proc/broadcastMessage(var/mob/living/source, var/mobName, var/sayVerb, var/message, var/freq, var/datum/language/speaking, var/messageFlags)
	var/list/radios = list()

	for(var/obj/item/device/radio/R in world) // AAAAAAAAAAAAAA
		if(R.receive_range(freq) != -1)
			radios += R

	var/list/receive = get_mobs_in_radio_ranges(radios)

	var/list/heard_normal 	= list() // normal message
	var/list/heard_voice 	= list() // voice message	(ie "chimpers")
	var/list/heard_garbled	= list() // garbled message (ie "f*c* **u, **i*er!")

	for(var/mob/R in receive)
		if(R.client)
			if(R.client.prefs)
				if(!(R.client.prefs.toggles & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
					continue
			else
				log_debug("Client prefs found to be null in /proc/broadcastMessage() for mob [R] and client [R.ckey], this should be investigated.")

		if(istype(R, /mob/new_player)) // we don't want new players to hear messages. rare but generates runtimes.
			continue

		if (!source || R.say_understands(source))
			heard_normal += R
		else
			if(source && source.speak_emote.len)
				heard_voice += R

			else
				heard_garbled += R

	if(length(heard_normal) || length(heard_voice) || length(heard_garbled))
		var/freq_text = get_frequency_name(freq)

		var/part_b_extra = ""
		if(IS_INTERCEPTED & messageFlags) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"
		var/part_a = "<span class='[frequency_span_class(freq)]'><b>\[[freq_text]\][part_b_extra]</b> <span class='name'>" // goes in the actual output//\icon[radio]

		var/part_b = "</span> <span class='message'>" // Tweaked for security headsets -- TLE

		if(length(heard_normal))
			for(var/mob/R in heard_normal)
				R.hear_radio(message, sayVerb, speaking, part_a, part_b, source, 0, mobName)

		if(length(heard_voice))
			for(var/mob/R in heard_voice)
				R.hear_radio(message, sayVerb, speaking, part_a, part_b, source, 0, mobName)

		if(length(heard_garbled))
			for(var/mob/R in heard_garbled)
				R.hear_radio(message, sayVerb, speaking, part_a, part_b, source, 1, mobName)

	if(!(IS_INTERCEPTED & messageFlags))
		for(var/antFreq in ANTAG_FREQS)
			broadcastMessage(source, mobName, sayVerb, message, antFreq, speaking, messageFlags | IS_INTERCEPTED)

	return 1


// Round up // REMIND ME TO MOVE THIS TO A BETTER PLACE
proc/n_ceil(var/num)
	if(isnum(num))
		return round(num)+1
