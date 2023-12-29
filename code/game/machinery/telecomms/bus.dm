/* Telecomms Bus
* The bus mainframe idles and waits for hubs to relay them signals. They act
* as junctions for the network. They transfer uncompressed subspace packets
* to processor units, and then take the processed packet to a server for
* logging. Link to a subspace hub if it can't send to a server.
*/

/obj/machinery/telecomms/bus
	name = "Bus Mainframe"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bus"
	desc = "A mighty piece of hardware used to send massive amounts of data quickly."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 1000
	machinetype = 2
	circuit = /obj/item/circuitboard/telecomms/bus
	netspeed = 40
	var/change_frequency = 0


/obj/machinery/telecomms/bus/receive_information(datum/signal/signal, obj/machinery/telecomms/sender)
	if (!is_freq_listening(signal))
		return
	if (change_frequency)
		signal.frequency = change_frequency
	if (sender != src && !istype(sender, /obj/machinery/telecomms/processor))
		var/send_success = relay_information(signal, /obj/machinery/telecomms/processor)
		if (send_success)
			return
		signal.data["slow"] += rand(1, 5)
		receive_information(signal, src)
	var/list/attempt_types = list(
		/obj/machinery/telecomms/server,
		/obj/machinery/telecomms/hub,
		/obj/machinery/telecomms/broadcaster,
		/obj/machinery/telecomms/bus
	)
	for (var/i = 1 to length(attempt_types))
		var/send_success = relay_information(signal, attempt_types[i])
		if (send_success)
			return
		signal.data["slow"] += rand(0, 1)


/obj/machinery/telecomms/bus/OptionsMenu()
	var/list/data = ..()
	data["use_change_freq"] = TRUE
	data["change_freq"] = change_frequency
	return data


/obj/machinery/telecomms/bus/OptionsHandler(action, params)
	if (..())
		return TRUE
	switch (action)
		if ("change_freq")
			. = TRUE
			var/newfreq = input(usr, "Specify a new frequency for new signals to change to. Enter null to turn off frequency changing. Decimals assigned automatically.", src, network) as null | num
			if (!canAccess(usr))
				return
			if (newfreq)
				if (findtext(num2text(newfreq), "."))
					newfreq *= 10
				if (newfreq < 10000)
					change_frequency = newfreq
					set_temp("-% New frequency to change to assigned: \"[newfreq] GHz\" %-", "average")
			else
				change_frequency = 0
				set_temp("-% Frequency changing deactivated %-", "average")
