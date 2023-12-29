/* Telecomms Broadcaster
* The broadcaster sends processed messages to all radio devices in the game. They
* do not have to be headsets; intercoms and station-bounced radios suffice. They
* receive their message from a server after the message has been logged.
*/

/obj/machinery/telecomms/broadcaster
	name = "Subspace Broadcaster"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "broadcaster"
	desc = "A dish-shaped machine used to broadcast processed subspace signals."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 25
	machinetype = 5
	produces_heat = FALSE
	delay = 7
	circuit = /obj/item/circuitboard/telecomms/broadcaster
	interact_offline = TRUE
	var/list/linked_radios_weakrefs = list()
	var/overmap_range = 0
	var/overmap_range_min = 0
	var/overmap_range_max = 5


/obj/machinery/telecomms/broadcaster/Destroy()
	if (message_delay)
		message_delay = 0
	return ..()


/obj/machinery/telecomms/broadcaster/proc/link_radio(obj/item/radio/radio)
	if (!istype(radio))
		return
	linked_radios_weakrefs |= weakref(radio)


/obj/machinery/telecomms/broadcaster/receive_information(datum/signal/signal, obj/machinery/telecomms/sender)
	if (signal.data["reject"])
		return
	if (!signal.data["message"])
		return
	signal.data["done"] = TRUE
	var/datum/signal/original = signal.data["original"]
	if (original)
		original.data["done"] = TRUE
		original.data["compression"] = signal.data["compression"]
		original.data["level"] = signal.data["level"]
	var/signal_message = "[signal.frequency]:[signal.data["message"]]:[signal.data["realname"]]"
	if (signal_message in recentmessages)
		return
	recentmessages += signal_message
	if (signal.data["slow"] > 0)
		sleep(signal.data["slow"])
	signal.data["level"] |= using_map.get_map_levels(listening_level, TRUE, overmap_range)
	var/list/forced_radios
	for (var/weakref/wr in linked_radios_weakrefs)
		var/obj/item/radio/R = wr.resolve()
		if (istype(R))
			LAZYDISTINCTADD(forced_radios, R)
	if (signal.data["type"] == SIGNAL_NORMAL)
		Broadcast_Message(
			signal.data["connection"], signal.data["mob"],
			signal.data["vmask"], signal.data["vmessage"],
			signal.data["radio"], signal.data["message"],
			signal.data["name"], signal.data["job"],
			signal.data["realname"], signal.data["vname"], DATA_NORMAL,
			signal.data["compression"], signal.data["level"], signal.frequency,
			signal.data["verb"], forced_radios
		)
	if (signal.data["type"] == SIGNAL_SIMPLE)
		Broadcast_SimpleMessage(
			signal.data["name"], signal.frequency,
			signal.data["message"], DATA_NORMAL, null,
			signal.data["compression"], listening_level, forced_radios
		)
	if (signal.data["type"] == SIGNAL_FAKE)
		Broadcast_Message( // Uses DATA_FAKE to prevent AI from tracking the source
			signal.data["connection"], signal.data["mob"],
			signal.data["vmask"], signal.data["vmessage"],
			signal.data["radio"], signal.data["message"],
			signal.data["name"], signal.data["job"],
			signal.data["realname"], signal.data["vname"], DATA_FAKE,
			signal.data["compression"], signal.data["level"], signal.frequency,
			signal.data["verb"], forced_radios
		)
	if (!message_delay)
		message_delay = TRUE
		spawn(10)
			message_delay = FALSE
			recentmessages = list()
	flick("broadcaster_send", src)


/obj/machinery/telecomms/broadcaster/OptionsMenu()
	var/list/data = ..()
	data["use_broadcast_range"] = TRUE
	data["range"] = overmap_range
	data["minRange"] = overmap_range_min
	data["maxRange"] = overmap_range_max
	return data


/obj/machinery/telecomms/broadcaster/OptionsHandler(action, params)
	if (..())
		return TRUE
	switch (action)
		if ("range")
			var/new_range = params["range"]
			overmap_range = clamp(new_range, overmap_range_min, overmap_range_max)
			update_idle_power_usage(initial(idle_power_usage)**(overmap_range+1))
