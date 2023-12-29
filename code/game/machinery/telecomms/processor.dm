/obj/machinery/telecomms/processor
	name = "Processor Unit"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "processor"
	desc = "This machine is used to process large quantities of information."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	machinetype = 3
	delay = 5
	circuit = /obj/item/circuitboard/telecomms/processor
	var/uncompress = TRUE // When FALSE, compress signals instead


/obj/machinery/telecomms/processor/receive_information(datum/signal/signal, obj/machinery/telecomms/sender)
	if (!is_freq_listening(signal))
		return
	if (uncompress)
		signal.data["compression"] = 0
	else
		signal.data["compression"] = 100
	if (istype(sender, /obj/machinery/telecomms/bus))
		relay_direct_information(signal, sender)
	else
		signal.data["slow"] += rand(5, 10)
		relay_information(signal, /obj/machinery/telecomms/server)
