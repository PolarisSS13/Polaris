/* All In One Telecomms Machine
* Basically just an empty shell for receiving and broadcasting radio messages. Not
* very flexible, but it gets the job done. Listens on *every* zlevel unless subtyped.
*/

/obj/machinery/telecomms/allinone
	name = "Telecommunications Mainframe"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "allinone"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	anchored = TRUE
	machinetype = 6
	produces_heat = FALSE
	var/list/linked_radios_weakrefs = list()
	var/intercept = FALSE // if nonzero, broadcasts all messages to syndicate channel
	var/overmap_range = 0


/obj/machinery/telecomms/allinone/proc/link_radio(obj/item/radio/radio)
	if (!istype(radio))
		return
	linked_radios_weakrefs |= weakref(radio)


/obj/machinery/telecomms/allinone/receive_signal(datum/signal/signal)
	if (!on)
		return
	if (!using_map.use_overmap)
		return
	if (signal.data["done"])
		return
	var/map_levels = using_map.get_map_levels(z, TRUE, overmap_range)
	if (signal.transmission_method != TRANSMISSION_BLUESPACE)
		var/list/signal_levels = list()
		signal_levels += signal.data["level"]
		var/list/overlap = map_levels & signal_levels
		if (!length(overlap))
			return
	if(!is_freq_listening(signal))
		return
	signal.data["done"] = TRUE
	signal.data["compression"] = 0
	var/datum/signal/original = signal.data["original"]
	if (original)
		original.data["done"] = TRUE
	signal.data["level"] = map_levels
	if (signal.data["slow"] > 0)
		sleep(signal.data["slow"])
	var/datum/radio_frequency/connection = signal.data["connection"]
	var/list/forced_radios
	for (var/weakref/wr in linked_radios_weakrefs)
		var/obj/item/radio/radio = wr.resolve()
		if (istype(radio))
			LAZYDISTINCTADD(forced_radios, radio)
	Broadcast_Message(
		signal.data["connection"],
		signal.data["mob"],
		signal.data["vmask"],
		signal.data["vmessage"],
		signal.data["radio"],
		signal.data["message"],
		signal.data["name"],
		signal.data["job"],
		signal.data["realname"],
		signal.data["vname"],
		DATA_NORMAL,
		signal.data["compression"],
		signal.data["level"],
		connection.frequency,
		signal.data["verb"],
		signal.data["language"],
		forced_radios
	)


/obj/machinery/telecomms/allinone/antag
	use_power = USE_POWER_OFF
	idle_power_usage = 0


/obj/machinery/telecomms/allinone/antag/receive_signal(datum/signal/signal)
	if (!on)
		return
	if (!is_freq_listening(signal))
		return
	signal.data["done"] = TRUE
	signal.data["compression"] = 0
	var/datum/signal/original = signal.data["original"]
	if (original)
		original.data["done"] = TRUE
	signal.data["level"] = using_map.contact_levels.Copy()
	if (signal.data["slow"] > 0)
		sleep(signal.data["slow"])
	var/datum/radio_frequency/connection = signal.data["connection"]
	var/list/forced_radios
	for (var/weakref/wr in linked_radios_weakrefs)
		var/obj/item/radio/radio = wr.resolve()
		if (istype(radio))
			LAZYDISTINCTADD(forced_radios, radio)
	if (connection.frequency in ANTAG_FREQS)
		Broadcast_Message(
			signal.data["connection"], signal.data["mob"],
			signal.data["vmask"], signal.data["vmessage"],
			signal.data["radio"], signal.data["message"],
			signal.data["name"], signal.data["job"],
			signal.data["realname"], signal.data["vname"], DATA_NORMAL,
			signal.data["compression"], list(0), connection.frequency,
			signal.data["verb"], forced_radios
		)
	else if(intercept)
		Broadcast_Message(
			signal.data["connection"], signal.data["mob"],
			signal.data["vmask"], signal.data["vmessage"],
			signal.data["radio"], signal.data["message"],
			signal.data["name"], signal.data["job"],
			signal.data["realname"], signal.data["vname"], DATA_ANTAG,
			signal.data["compression"], list(0), connection.frequency,
			signal.data["verb"], forced_radios
		)
