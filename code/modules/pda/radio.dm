/obj/item/radio/integrated
	name = "\improper PDA radio module"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/pda/hostpda = null

	var/control_freq = BOT_FREQ

	on = FALSE //Are we currently active??
	var/menu_message = ""

/obj/item/radio/integrated/Initialize()
	. = ..()
	if(istype(loc.loc, /obj/item/pda))
		hostpda = loc.loc

/obj/item/radio/integrated/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, control_freq)
	hostpda = null
	return ..()

/obj/item/radio/integrated/proc/post_signal(var/freq, var/key, var/value, var/key2, var/value2, var/key3, var/value3, s_filter)

	//to_world("Post: [freq]: [key]=[value], [key2]=[value2]")
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

	if(!frequency)
		return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	signal.data[key] = value
	if(key2)
		signal.data[key2] = value2
	if(key3)
		signal.data[key3] = value3

	frequency.post_signal(src, signal, radio_filter = s_filter)

/*
 *	Radio Cartridge, essentially a signaler.
 */
/obj/item/radio/integrated/signal
	frequency = 1457
	var/code = 30.0

/obj/item/radio/integrated/signal/Initialize()
	. = ..()
	if(radio_controller)
		if(src.frequency < PUBLIC_LOW_FREQ || src.frequency > PUBLIC_HIGH_FREQ)
			src.frequency = sanitize_frequency(src.frequency)
		set_frequency(frequency)

/obj/item/radio/integrated/signal/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	radio_connection = null
	return ..()

/obj/item/radio/integrated/signal/proc/send_signal(message="ACTIVATE")
	if(last_transmission && world.time < (last_transmission + 5))
		return
	last_transmission = world.time

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = get_turf(src)
	lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = message

	spawn(0)
		radio_connection.post_signal(src, signal)
