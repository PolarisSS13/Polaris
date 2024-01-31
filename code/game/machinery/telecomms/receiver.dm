/* Telecomms Receiver
* The receiver idles and receives messages from subspace-compatible radio equipment;
* primarily headsets. They then just relay this information to all linked devices,
* which can would probably be network hubs. Link to Processor Units in case receiver
* can't send to bus units.
*/

/obj/machinery/telecomms/receiver
	name = "Subspace Receiver"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	machinetype = 1
	produces_heat = 0
	circuit = /obj/item/circuitboard/telecomms/receiver
	interact_offline = TRUE
	var/list/linked_radios_weakrefs = list()
	var/overmap_range = 0
	var/overmap_range_min = 0
	var/overmap_range_max = 5


/obj/machinery/telecomms/receiver/proc/link_radio(obj/item/radio/radio)
	if (!istype(radio))
		return
	linked_radios_weakrefs |= weakref(radio)


/obj/machinery/telecomms/receiver/receive_signal(datum/signal/signal)
	if (!on)
		return
	if (!signal)
		return
	if (!check_receive_level(signal))
		return
	if (signal.transmission_method != TRANSMISSION_SUBSPACE)
		return
	if (!is_freq_listening(signal))
		return
	signal.data["level"] = list()
	var/send_succeeded = relay_information(signal, /obj/machinery/telecomms/hub)
	if (send_succeeded)
		return
	relay_information(signal, /obj/machinery/telecomms/bus)


/obj/machinery/telecomms/receiver/proc/check_receive_level(datum/signal/signal)
	if (signal.transmission_method == TRANSMISSION_BLUESPACE)
		var/obj/item/radio/radio = signal.data["radio"]
		if (!(weakref(radio) in linked_radios_weakrefs))
			signal.data["reject"] = TRUE
			return FALSE
		signal.data["level"] = z
		signal.transmission_method = TRANSMISSION_SUBSPACE
		return TRUE
	var/list/listening_levels = using_map.get_map_levels(listening_level, TRUE, overmap_range)
	if (signal.data["level"] in listening_levels)
		return TRUE
	for (var/obj/machinery/telecomms/hub/hub in links)
		var/list/relayed_levels = list()
		for (var/obj/machinery/telecomms/relay/relay in hub.links)
			if (relay.can_receive(signal))
				relayed_levels |= relay.listening_level
		if (signal.data["level"] in relayed_levels)
			return TRUE
	return FALSE


/obj/machinery/telecomms/receiver/OptionsMenu()
	var/list/data = ..()
	data["use_receive_range"] = TRUE
	data["range"] = overmap_range
	data["minRange"] = overmap_range_min
	data["maxRange"] = overmap_range_max
	return data


/obj/machinery/telecomms/receiver/OptionsHandler(action, params)
	if (..())
		return TRUE
	switch (action)
		if ("range")
			var/new_range = params["range"]
			overmap_range = clamp(new_range, overmap_range_min, overmap_range_max)
			update_idle_power_usage(initial(idle_power_usage) ** (overmap_range + 1))
