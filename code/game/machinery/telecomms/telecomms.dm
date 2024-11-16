/obj/machinery/telecomms
	icon = 'icons/obj/stationobjs.dmi'
	var/list/links = list() // list of machines this machine is linked to
	var/traffic = 0 // value increases as traffic increases
	var/netspeed = 5 // how much traffic to lose per tick (50 gigabytes/second * netspeed)
	var/list/autolinkers = list() // list of text/number values to link with
	var/id = "NULL" // identification string
	var/network = "NULL" // the network of the machinery
	var/list/freq_listening = list() // list of frequencies to tune into: if none, will listen to all
	var/machinetype = 0 // just a hacky way of preventing alike machines from pairing
	var/toggled = TRUE // Is it toggled on
	var/on = TRUE
	var/integrity = 100 // basically HP, loses integrity by heat
	var/produces_heat = TRUE //whether the machine will produce heat when on.
	var/delay = 10 // how many process() ticks to delay per heat
	var/long_range_link = 0 // Can you link it across Z levels or on the otherside of the map? (Relay & Hub)
	var/hide = FALSE // Is it a hidden machine?
	var/listening_level = 0 // 0 = auto set in New() - this is the z level that the machine is listening to.
	var/list/temp // output message for interactions


/obj/machinery/telecomms/Destroy()
	telecomms_list -= src
	for(var/obj/machinery/telecomms/comm in telecomms_list)
		comm.links -= src
	links = list()
	return ..()


/obj/machinery/telecomms/Initialize()
	telecomms_list += src
	..()
	default_apply_parts()
	return INITIALIZE_HINT_LATELOAD


/obj/machinery/telecomms/LateInitialize()
	if (!listening_level)
		var/turf/position = get_turf(src)
		listening_level = position.z
	if (!length(autolinkers))
		return
	var/list/linkables = telecomms_list
	if (!long_range_link)
		linkables = orange(20, src)
	for (var/obj/machinery/telecomms/machine in linkables)
		add_link(machine)


/obj/machinery/telecomms/attackby(obj/item/P, mob/user)
	if (istype(P, /obj/item/multitool))
		attack_hand(user)
	if (istype(P, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/T = P
		if (integrity < 100)
			if (T.use(1))
				integrity = clamp(integrity + rand(10, 20), 0, 100)
				to_chat(usr, "You apply the Nanopaste to [src], repairing some of the damage.")
		else
			to_chat(usr, "This machine is already in perfect condition.")
		return
	if (default_deconstruction_screwdriver(user, P))
		return
	if (default_deconstruction_crowbar(user, P))
		return


/obj/machinery/telecomms/attack_ai(mob/user)
	attack_hand(user)


/obj/machinery/telecomms/attack_hand(mob/user)
	tgui_interact(user)


/obj/machinery/telecomms/emp_act(severity)
	if (prob(100 / severity))
		if (!(stat & EMPED))
			stat |= EMPED
			var/duration = (300 * 10) / severity
			spawn(rand(duration - 20, duration + 20))
				stat &= ~EMPED
	..()


/obj/machinery/telecomms/process()
	update_power()
	checkheat()
	update_icon()
	if (traffic > 0)
		traffic -= netspeed


/obj/machinery/telecomms/tgui_act(action, params)
	if (..())
		return TRUE
	var/obj/item/multitool/P = get_multitool(usr)
	switch (action)
		if ("toggle")
			toggled = !toggled
			set_temp("-% [src] has been [toggled ? "activated" : "deactivated"].", "average")
			update_power()
			. = TRUE
		if ("id")
			var/response = input(usr, "Specify the new ID for this machine", src, id) as null | text
			var/newid = copytext(reject_bad_text(response), 1, MAX_MESSAGE_LEN)
			if(newid && canAccess(usr))
				id = newid
				set_temp("-% New ID assigned: \"[id]\" %-", "average")
				. = TRUE
		if ("network")
			var/newnet = input(usr, "Specify the new network for this machine. This will break all current links.", src, network) as null | text
			if (newnet && canAccess(usr))
				if (length(newnet) > 15)
					set_temp("-% Too many characters in new network tag %-", "average")
				else
					for (var/obj/machinery/telecomms/T in links)
						T.links -= src
					network = newnet
					links = list()
					set_temp("-% New network tag assigned: \"[network]\" %-", "average")
				. = TRUE
		if ("freq")
			var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.", src, network) as null | num
			if (newfreq && canAccess(usr))
				if (findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if (!(newfreq in freq_listening) && newfreq < 10000)
					freq_listening += newfreq
					set_temp("-% New frequency filter assigned: \"[newfreq] GHz\" %-", "average")
				. = TRUE
		if ("delete")
			var/x = text2num(params["delete"])
			set_temp("-% Removed frequency filter [x] %-", "average")
			freq_listening-= x
			. = TRUE
		if ("unlink")
			if (text2num(params["unlink"]) <= length(links))
				var/obj/machinery/telecomms/T = links[text2num(params["unlink"])]
				set_temp("-% Removed \ref[T] [T.name] from linked entities. %-", "average")
				if (src in T.links)
					T.links -= src
				links -= T
				. = TRUE
		if ("link")
			if (P)
				if (P.buffer && P.buffer != src)
					if (!(src in P.buffer.links))
						P.buffer.links += src
					if (!(P.buffer in links))
						links += P.buffer
					set_temp("-% Successfully linked with \ref[P.buffer] [P.buffer.name] %-", "average")
				else
					set_temp("-% Unable to acquire buffer %-", "average")
				. = TRUE
		if ("buffer")
			P.buffer = src
			set_temp("-% Successfully stored \ref[P.buffer] [P.buffer.name] in buffer %-", "average")
			. = TRUE
		if ("flush")
			set_temp("-% Buffer successfully flushed. %-", "average")
			P.buffer = null
			. = TRUE
		if ("cleartemp")
			temp = null
			. = TRUE
	if (OptionsHandler(action, params))
		. = TRUE
	add_fingerprint(usr)


/obj/machinery/telecomms/tgui_data(mob/user)
	var/list/data = list()
	data["temp"] = temp
	data["on"] = on
	data["id"] = null
	data["network"] = null
	data["autolinkers"] = FALSE
	data["shadowlink"] = FALSE
	data["options"] = list()
	data["linked"] = list()
	data["filter"] = list()
	data["multitool"] = FALSE
	data["multitool_buffer"] = null
	if (on || interact_offline)
		data["id"] = id
		data["network"] = network
		data["autolinkers"] = !!LAZYLEN(autolinkers)
		data["shadowlink"] = !!hide
		data["options"] = OptionsMenu()
		var/obj/item/multitool/P = get_multitool(user)
		data["multitool"] = !!P
		data["multitool_buffer"] = null
		if (P && P.buffer)
			P.update_icon()
			data["multitool_buffer"] = list("name" = "[P.buffer]", "id" = "[P.buffer.id]")
		var/i = 0
		var/list/linked = list()
		for (var/obj/machinery/telecomms/T in links)
			i++
			linked += list(list(
				"ref" = "\ref[T]",
				"name" = "[T]",
				"id" = T.id,
				"index" = i,
			))
		data["linked"] = linked
		var/list/filter = list()
		if (length(freq_listening))
			for (var/x in freq_listening)
				filter += list(list(
					"name" = "[format_frequency(x)]",
					"freq" = x,
				))
		data["filter"] = filter
	return data


/obj/machinery/telecomms/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "TelecommsMultitoolMenu", name)
		ui.open()


/obj/machinery/telecomms/tgui_status(mob/user)
	if (!issilicon(user))
		if (!istype(user.get_active_hand(), /obj/item/multitool))
			return STATUS_CLOSE
	return ..()


/obj/machinery/telecomms/update_icon()
	if (on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"


/obj/machinery/telecomms/proc/add_link(obj/machinery/telecomms/machine)
	if (machine == src)
		return
	if (machine in links)
		return
	var/src_z = get_z(src)
	var/machine_z = get_z(machine)
	if (src_z != machine_z && !(long_range_link && machine.long_range_link))
		return
	for (var/entry in autolinkers)
		if (entry in machine.autolinkers)
			links |= machine
			break


/obj/machinery/telecomms/proc/canAccess(mob/user)
	return issilicon(user) || in_range(user, src)


/obj/machinery/telecomms/proc/checkheat()
	var/turf/simulated/turf = get_turf(src)
	if (!istype(turf))
		return
	var/datum/gas_mixture/environment = turf.return_air()
	var/damage_chance = 0
	switch(environment.temperature)
		if ((T0C + 40) to (T0C + 70))
			damage_chance = 10
		if ((T0C + 70) to (T0C + 130))
			damage_chance = 25
		if ((T0C + 130) to (T0C + 200))
			damage_chance = 50
		if ((T0C + 200) to INFINITY)
			damage_chance = 100
	if (damage_chance && prob(damage_chance))
		integrity = clamp(integrity - 1, 0, 100)
	if (delay > 0)
		delay--
	else if (on)
		produce_heat()
		delay = initial(delay)


/obj/machinery/telecomms/proc/is_freq_listening(datum/signal/signal)
	if (!signal)
		return FALSE
	if (!length(freq_listening) || (signal.frequency in freq_listening))
		return TRUE
	return FALSE


/obj/machinery/telecomms/proc/produce_heat()
	if (!produces_heat)
		return
	if (!use_power)
		return
	if (stat & (NOPOWER|BROKEN))
		return
	var/turf/simulated/turf = get_turf(src)
	if (!istype(turf))
		return
	var/datum/gas_mixture/env = turf.return_air()
	var/transfer_moles = 0.25 * env.total_moles
	var/datum/gas_mixture/removed = env.remove(transfer_moles)
	if (removed)
		var/heat_produced = idle_power_usage
		if (traffic <= 0)
			heat_produced *= 0.30
		removed.add_thermal_energy(heat_produced)
	env.merge(removed)


/obj/machinery/telecomms/proc/receive_information(datum/signal/signal, obj/machinery/telecomms/sender)
	return


/obj/machinery/telecomms/proc/relay_direct_information(datum/signal/signal, obj/machinery/telecomms/receiver)
	receiver.receive_information(signal, src)


/obj/machinery/telecomms/proc/relay_information(datum/signal/signal, filter, copysig, amount = 20)
	if (!on)
		return
	var/send_count = 0
	signal.data["slow"] += rand(0, round(100 - integrity))
	for (var/obj/machinery/telecomms/machine in links)
		if (filter && !istype(machine, filter))
			continue
		if (!machine.on)
			continue
		if (amount && send_count >= amount)
			break
		if (machine.loc.z != listening_level)
			if (!long_range_link && !machine.long_range_link)
				continue
		var/datum/signal/copy
		if (copysig)
			copy = new
			copy.transmission_method = TRANSMISSION_SUBSPACE
			copy.frequency = signal.frequency
			copy.data = signal.data.Copy()
			if (!signal.data["original"])
				copy.data["original"] = signal
			else
				copy.data["original"] = signal.data["original"]
		send_count++
		if (machine.is_freq_listening(signal))
			machine.traffic++
		if (copysig && copy)
			machine.receive_information(copy, src)
		else
			machine.receive_information(signal, src)
	if (send_count > 0 && is_freq_listening(signal))
		traffic++
	return send_count


/obj/machinery/telecomms/proc/set_temp(text, color = "average")
	temp = list("color" = color, "text" = text)


/obj/machinery/telecomms/proc/update_power()
	if (integrity < 1)
		on = FALSE
	else if (stat & (BROKEN|NOPOWER|EMPED))
		on = FALSE
	else
		on = toggled


/* Additional interface options for certain machines. Eg:
* /obj/machinery/telecomms/processor/OptionsMenu()
*   return "<br>Processing Mode: <A href='?src=\ref[src];process=1'>[uncompress ? "UNCOMPRESS" : "COMPRESS"]</a>"
*/
/obj/machinery/telecomms/proc/OptionsMenu()
	return list()


/// Topic handler for OptionsMenu href links.
/obj/machinery/telecomms/proc/OptionsHandler(action, params)
	return
