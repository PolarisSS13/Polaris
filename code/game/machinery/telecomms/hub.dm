/* Telecomms Hub
* The hub idles until it receives information. It then passes on that information
* depending on where it came from. This is the heart of the Telecommunications
* Network, sending information where it is needed. It mainly receives information
* from long-distance Relays and then sends that information to be processed.
* Afterwards it gets the uncompressed information from Servers/Buses and sends
* that back to the relay, to then be broadcasted.
*/

/obj/machinery/telecomms/hub
	name = "Telecommunication Hub"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "hub"
	desc = "A mighty piece of hardware used to send/receive massive amounts of data."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 1600
	machinetype = 7
	circuit = /obj/item/circuitboard/telecomms/hub
	long_range_link = TRUE
	netspeed = 40


/obj/machinery/telecomms/hub/receive_information(datum/signal/signal, obj/machinery/telecomms/sender)
	if (!is_freq_listening(signal))
		return
	if (istype(sender, /obj/machinery/telecomms/receiver))
		relay_information(signal, /obj/machinery/telecomms/bus, TRUE)
		return
	relay_information(signal, /obj/machinery/telecomms/relay, TRUE)
	relay_information(signal, /obj/machinery/telecomms/broadcaster, TRUE)
