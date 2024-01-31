/* Telecomms Relay
* The relay idles until it receives information. It then passes on that information
* depending on where it came from. The relay is needed in order to send information
* pass Z levels. It must be linked with a HUB, the only other machine that can
* send/receive pass Z levels.
*/

/obj/machinery/telecomms/relay
	name = "Telecommunication Relay"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	machinetype = 8
	produces_heat = TRUE
	circuit = /obj/item/circuitboard/telecomms/relay
	netspeed = 5
	long_range_link = TRUE
	var/broadcasting = TRUE
	var/receiving = TRUE


/obj/machinery/telecomms/relay/forceMove(newloc)
	. = ..(newloc)
	listening_level = z


/obj/machinery/telecomms/relay/receive_information(datum/signal/signal, obj/machinery/telecomms/sender)
	if (can_send(signal))
		signal.data["level"] |= using_map.get_map_levels(listening_level)


/obj/machinery/telecomms/relay/OptionsMenu()
	var/list/data = ..()
	data["use_broadcasting"] = TRUE
	data["use_receiving"] = TRUE
	data["broadcasting"] = broadcasting
	data["receiving"] = receiving
	return data


/obj/machinery/telecomms/relay/OptionsHandler(action, params)
	if (..())
		return TRUE
	switch (action)
		if ("receive")
			. = TRUE
			receiving = !receiving
			set_temp("-% Receiving mode changed. %-", "average")
		if ("broadcast")
			. = TRUE
			broadcasting = !broadcasting
			set_temp("-% Broadcasting mode changed. %-", "average")



/obj/machinery/telecomms/relay/proc/can(datum/signal/signal)
	if (!on)
		return FALSE
	if (!listening_level)
		return FALSE
	if (!is_freq_listening(signal))
		return FALSE
	return TRUE


/obj/machinery/telecomms/relay/proc/can_send(datum/signal/signal)
	if (!can(signal))
		return FALSE
	return broadcasting


/obj/machinery/telecomms/relay/proc/can_receive(datum/signal/signal)
	if (!can(signal))
		return FALSE
	return receiving
