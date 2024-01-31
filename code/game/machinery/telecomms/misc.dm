#define TELECOMMS_RECEPTION_NONE 0
#define TELECOMMS_RECEPTION_SENDER 1
#define TELECOMMS_RECEPTION_RECEIVER 2
#define TELECOMMS_RECEPTION_BOTH 3

/// The list of all telecomms machines
var/global/list/obj/machinery/telecomms/telecomms_list = list()

/// global list of recent messages broadcasted : used to circumvent massive radio spam
var/global/list/recentmessages = list()

/// To make sure restarting the recentmessages list is kept in sync
var/global/message_delay = 0


/datum/comm_log_entry
	var/name = "data packet (#)"
	var/input_type = "Speech File"
	var/parameters = list()


/datum/reception
	var/obj/machinery/message_server/message_server
	var/telecomms_reception = TELECOMMS_RECEPTION_NONE
	var/message = ""


/datum/receptions
	var/obj/machinery/message_server/message_server
	var/sender_reception = TELECOMMS_RECEPTION_NONE
	var/list/receiver_reception = new


/atom/proc/telecomms_process(skip_sleep)
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_SUBSPACE
	var/pos_z = get_z(src)
	signal.data = list(
		"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
		"message" = "TEST",
		"compression" = rand(45, 50), // If the signal is compressed, compress our message too.
		"traffic" = 0, // dictates the total traffic sum that the signal went through
		"type" = SIGNAL_TEST, // determines what type of radio input it is: test broadcast
		"reject" = 0,
		"done" = 0,
		"level" = pos_z // The level it is being broadcasted at.
	)
	signal.frequency = PUB_FREQ
	for(var/obj/machinery/telecomms/receiver/receiver in telecomms_list)
		receiver.receive_signal(signal)
	if(!skip_sleep)
		sleep(rand(10, 25))
	return signal


/proc/register_radio(source, old_frequency, new_frequency, radio_filter)
	if(old_frequency)
		radio_controller.remove_object(source, old_frequency)
	if(new_frequency)
		return radio_controller.add_object(source, new_frequency, radio_filter)


/proc/unregister_radio(source, frequency)
	if(radio_controller)
		radio_controller.remove_object(source, frequency)


/proc/get_frequency_name(var/display_freq)
	var/freq_text
	if (display_freq in ANTAG_FREQS)
		freq_text = "#unkn"
	else
		for (var/channel in radiochannels)
			if (radiochannels[channel] == display_freq)
				freq_text = channel
				break
	if (!freq_text)
		freq_text = format_frequency(display_freq)
	return freq_text


/proc/get_message_server()
	if(message_servers)
		for (var/obj/machinery/message_server/MS in message_servers)
			if(MS.active)
				return MS
	return null


/proc/get_sender_reception(atom/sender, datum/signal/signal)
	if (signal?.data["done"])
		return TELECOMMS_RECEPTION_SENDER
	return TELECOMMS_RECEPTION_NONE


/proc/get_receiver_reception(receiver, datum/signal/signal)
	if (receiver && signal?.data["done"])
		var/turf/pos = get_turf(receiver)
		if (pos?.z in signal.data["level"])
			return TELECOMMS_RECEPTION_RECEIVER
	return TELECOMMS_RECEPTION_NONE


/proc/get_reception(atom/sender, receiver, message = "", skip_sleep)
	var/datum/reception/reception = new
	reception.message_server = get_message_server()
	var/datum/signal/signal = sender.telecomms_process(skip_sleep)
	reception.telecomms_reception |= get_sender_reception(sender, signal)
	reception.telecomms_reception |= get_receiver_reception(receiver, signal)
	reception.message = signal && signal.data["compression"] > 0 ? Gibberish(message, signal.data["compression"] + 50) : message
	return reception


/proc/get_receptions(atom/sender, list/atom/receivers, skip_sleep)
	var/datum/receptions/receptions = new
	receptions.message_server = get_message_server()
	var/datum/signal/signal
	if (sender)
		signal = sender.telecomms_process(skip_sleep)
		receptions.sender_reception = get_sender_reception(sender, signal)
	for (var/atom/receiver in receivers)
		if (!signal)
			signal = receiver.telecomms_process()
		receptions.receiver_reception[receiver] = get_receiver_reception(receiver, signal)
	return receptions


/**
	Here is the big, bad function that broadcasts a message given the appropriate
	parameters.

	@param connection:
		The datum generated in radio.dm, stored in signal.data["connection"].

	@param M:
		Reference to the mob/speaker, stored in signal.data["mob"]

	@param vmask:
		Boolean value if the mob is "hiding" its identity via voice mask, stored in
		signal.data["vmask"]

	@param vmessage:
		If specified, will display this as the message; such as "chimpering"
		for monkies if the mob is not understood. Stored in signal.data["vmessage"].

	@param radio:
		Reference to the radio broadcasting the message, stored in signal.data["radio"]

	@param message:
		The actual string message to display to mobs who understood mob M. Stored in
		signal.data["message"]

	@param name:
		The name to display when a mob receives the message. signal.data["name"]

	@param job:
		The name job to display for the AI when it receives the message. signal.data["job"]

	@param realname:
		The "real" name associated with the mob. signal.data["realname"]

	@param vname:
		If specified, will use this name when mob M is not understood. signal.data["vname"]

	@param data:
		If specified:
				1 -- Will only broadcast to intercoms
				2 -- Will only broadcast to intercoms and station-bounced radios
				3 -- Broadcast to syndicate frequency
				4 -- AI can't track down this person. Useful for imitation broadcasts where you can't find the actual mob

	@param compression:
		If 0, the signal is audible
		If nonzero, the signal may be partially inaudible or just complete gibberish.

	@param level:
		The list of Z levels that the sending radio is broadcasting to. Having 0 in the list broadcasts on all levels

	@param freq
		The frequency of the signal
*/

/proc/Broadcast_Message(var/datum/radio_frequency/connection, var/mob/M,
						var/vmask, var/list/vmessage_pieces, var/obj/item/radio/radio,
						var/list/message_pieces, var/name, var/job, var/realname, var/vname,
						var/data, var/compression, var/list/level, var/freq, var/verbage = "says",
						var/list/forced_radios)

  /* ###### Prepare the radio connection ###### */

	var/display_freq = freq

	var/list/obj/item/radio/radios = list()

	for(var/obj/item/radio/R in forced_radios)
		//Cursory check to ensure they are 'on' and stuff
		if(R.receive_range(display_freq, list(0)) > -1)
			radios |= R

	// --- Broadcast only to intercom devices ---

	if(data == DATA_INTERCOM)

		for (var/obj/item/radio/intercom/R in connection.devices["[RADIO_CHAT]"])
			if(R.receive_range(display_freq, level) > -1)
				radios |= R

	// --- Broadcast only to intercoms and station-bounced radios ---

	else if(data == DATA_LOCAL)

		for (var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"])

			if(istype(R, /obj/item/radio/headset) && !R.adhoc_fallback)
				continue

			if(R.receive_range(display_freq, level) > -1)
				radios |= R

	// --- Broadcast to antag radios! ---

	else if(data == DATA_ANTAG)
		for(var/antag_freq in ANTAG_FREQS)
			var/datum/radio_frequency/antag_connection = radio_controller.return_frequency(antag_freq)
			for (var/obj/item/radio/R in antag_connection.devices["[RADIO_CHAT]"])
				if(R.receive_range(antag_freq, level) > -1)
					radios |= R

	// --- Broadcast to ALL radio devices ---

	else

		for (var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"])
			if(R.receive_range(display_freq, level) > -1)
				radios |= R

	// Get a list of mobs who can hear from the radios we collected.
	var/list/receive = get_mobs_in_radio_ranges(radios)

  /* ###### Organize the receivers into categories for displaying the message ###### */

  	// Understood the message:
	var/list/heard_masked 	= list() // masked name or no real name
	var/list/heard_normal 	= list() // normal message

	// Did not understand the message:
	var/list/heard_voice 	= list() // voice message	(ie "chimpers")
	var/list/heard_garbled	= list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	for (var/mob/R in receive)

	  /* --- Loop through the receivers and categorize them --- */
		if(!R.is_preference_enabled(/datum/client_preference/holder/hear_radio))
			continue

		if(istype(R, /mob/new_player)) // we don't want new players to hear messages. rare but generates runtimes.
			continue

		// Ghosts hearing all radio chat don't want to hear syndicate intercepts, they're duplicates
		if(data == DATA_ANTAG && istype(R, /mob/observer/dead) && R.is_preference_enabled(/datum/client_preference/ghost_radio))
			continue

		// --- Check for compression ---
		if(compression > 0)
			heard_gibberish += R
			continue

		// --- Can understand the speech ---

		if(!M || R.say_understands(M))

			// - Not human or wearing a voice mask -
			if(!M || !ishuman(M) || vmask)
				heard_masked += R

			// - Human and not wearing voice mask -
			else
				heard_normal += R

		// --- Can't understand the speech ---

		else
			// - The speaker has a prespecified "voice message" to display if not understood -
			if(vmessage_pieces)
				heard_voice += R

			// - Just display a garbled message -
			else
				heard_garbled += R


  /* ###### Begin formatting and sending the message ###### */
	if(length(heard_masked) || length(heard_normal) || length(heard_voice) || length(heard_garbled) || length(heard_gibberish))

	  /* --- Some miscellaneous variables to format the string output --- */
		var/freq_text = get_frequency_name(display_freq)

		var/part_b_extra = ""
		if(data == DATA_ANTAG) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"
		var/part_a = "<span class='[frequency_span_class(display_freq)]'>"
		var/part_b = "[bicon(radio)]<b>\[[freq_text]\][part_b_extra]</b> <span class='name'>" // goes in the actual output

		// --- Some more pre-message formatting ---
		var/part_c = "</span> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_d = "</span>"
		var/part_e = "</span>"


		// --- Filter the message; place it in quotes apply a verb ---
		var/quotedmsg = null
		if(M)
			quotedmsg = "[M.say_quote(multilingual_to_message(message_pieces))], \"[multilingual_to_message(message_pieces)]\""
		else
			quotedmsg = "says, \"[multilingual_to_message(message_pieces)]\""

		// --- This following recording is intended for research and feedback in the use of department radio channels ---

		var/part_blackbox_c = "</span><b> \[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/blackbox_msg = "[part_a][part_b][name][part_blackbox_c][quotedmsg][part_d][part_e]"
		//var/blackbox_admin_msg = "[part_a][M.name] (Real name: [M.real_name])[part_blackbox_b][quotedmsg][part_c]"

		//BR.messages_admin += blackbox_admin_msg
		if(istype(blackbox))
			switch(display_freq)
				if(PUB_FREQ)
					blackbox.msg_common += blackbox_msg
				if(SCI_FREQ)
					blackbox.msg_science += blackbox_msg
				if(COMM_FREQ)
					blackbox.msg_command += blackbox_msg
				if(MED_FREQ)
					blackbox.msg_medical += blackbox_msg
				if(ENG_FREQ)
					blackbox.msg_engineering += blackbox_msg
				if(SEC_FREQ)
					blackbox.msg_security += blackbox_msg
				if(DTH_FREQ)
					blackbox.msg_deathsquad += blackbox_msg
				if(SYND_FREQ)
					blackbox.msg_syndicate += blackbox_msg
				if(RAID_FREQ)
					blackbox.msg_raider += blackbox_msg
				if(SUP_FREQ)
					blackbox.msg_cargo += blackbox_msg
				if(SRV_FREQ)
					blackbox.msg_service += blackbox_msg
				if(EXP_FREQ)
					blackbox.msg_explorer += blackbox_msg
				else
					blackbox.messages += blackbox_msg

		//End of research and feedback code.

	 /* ###### Send the message ###### */
	  	/* --- Process all the mobs that heard a masked voice (understood) --- */
		if(length(heard_masked))
			for (var/mob/R in heard_masked)
				R.hear_radio(message_pieces, verbage, part_a, part_b, part_c, part_d, part_e, M, 0, name)

		/* --- Process all the mobs that heard the voice normally (understood) --- */
		if(length(heard_normal))
			for (var/mob/R in heard_normal)
				R.hear_radio(message_pieces, verbage, part_a, part_b, part_c, part_d, part_e, M, 0, realname)

		/* --- Process all the mobs that heard the voice normally (did not understand) --- */
		if(length(heard_voice))
			for (var/mob/R in heard_voice)
				R.hear_radio(message_pieces, verbage, part_a, part_b, part_c, part_d, part_e, M,0, vname)

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")
		if(length(heard_garbled))
			for (var/mob/R in heard_garbled)
				R.hear_radio(message_pieces, verbage, part_a, part_b, part_c, part_d, part_e, M, 1, vname)

		/* --- Complete gibberish. Usually happens when there's a compressed message --- */
		if(length(heard_gibberish))
			for (var/mob/R in heard_gibberish)
				R.hear_radio(message_pieces, verbage, part_a, part_b, part_c, part_d, part_e, M, 1)

	return 1


/proc/Broadcast_SimpleMessage(var/source, var/frequency, list/message_pieces, var/data, var/mob/M, var/compression, var/level, var/list/forced_radios)
	var/text = multilingual_to_message(message_pieces)
  /* ###### Prepare the radio connection ###### */

	if(!M)
		var/mob/living/carbon/human/H = new
		M = H

	var/datum/radio_frequency/connection = radio_controller.return_frequency(frequency)

	var/display_freq = connection.frequency

	var/list/receive = list()

	for(var/obj/item/radio/R in forced_radios)
		receive |= R.send_hear(display_freq)

	// --- Broadcast only to intercom devices ---

	if(data == DATA_INTERCOM)
		for (var/obj/item/radio/intercom/R in connection.devices["[RADIO_CHAT]"])
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq, level)


	// --- Broadcast only to intercoms and station-bounced radios ---

	else if(data == DATA_LOCAL)
		for (var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"])

			if(istype(R, /obj/item/radio/headset))
				continue
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq)


	// --- Broadcast to antag radios! ---

	else if(data == DATA_ANTAG)
		for(var/freq in ANTAG_FREQS)
			var/datum/radio_frequency/antag_connection = radio_controller.return_frequency(freq)
			for (var/obj/item/radio/R in antag_connection.devices["[RADIO_CHAT]"])
				var/turf/position = get_turf(R)
				if(position && position.z == level)
					receive |= R.send_hear(freq)


	// --- Broadcast to ALL radio devices ---

	else
		for (var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"])
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq)


  /* ###### Organize the receivers into categories for displaying the message ###### */

	// Understood the message:
	var/list/heard_normal 	= list() // normal message

	// Did not understand the message:
	var/list/heard_garbled	= list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	for (var/mob/R in receive)

	  /* --- Loop through the receivers and categorize them --- */

		if(!R.is_preference_enabled(/datum/client_preference/holder/hear_radio)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
			continue


		// --- Check for compression ---
		if(compression > 0)

			heard_gibberish += R
			continue

		// --- Can understand the speech ---

		if(R.say_understands(M))

			heard_normal += R

		// --- Can't understand the speech ---

		else
			// - Just display a garbled message -

			heard_garbled += R


  /* ###### Begin formatting and sending the message ###### */
	if(length(heard_normal) || length(heard_garbled) || length(heard_gibberish))

	  /* --- Some miscellaneous variables to format the string output --- */
		var/part_a = "<span class='[frequency_span_class(display_freq)]'><span class='name'>" // goes in the actual output
		var/freq_text = get_frequency_name(display_freq)

		// --- Some more pre-message formatting ---

		var/part_b_extra = ""
		if(data == DATA_ANTAG) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"

		// Create a radio headset for the sole purpose of using its icon
		var/obj/item/radio/headset/radio = new

		var/part_b = "</span><b> [bicon(radio)]\[[freq_text]\][part_b_extra]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_blackbox_b = "</span><b> \[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "</span></span>"

		var/blackbox_msg = "[part_a][source][part_blackbox_b]\"[text]\"[part_c]"

		//BR.messages_admin += blackbox_admin_msg
		if(istype(blackbox))
			switch(display_freq)
				if(PUB_FREQ)
					blackbox.msg_common += blackbox_msg
				if(SCI_FREQ)
					blackbox.msg_science += blackbox_msg
				if(COMM_FREQ)
					blackbox.msg_command += blackbox_msg
				if(MED_FREQ)
					blackbox.msg_medical += blackbox_msg
				if(ENG_FREQ)
					blackbox.msg_engineering += blackbox_msg
				if(SEC_FREQ)
					blackbox.msg_security += blackbox_msg
				if(DTH_FREQ)
					blackbox.msg_deathsquad += blackbox_msg
				if(SYND_FREQ)
					blackbox.msg_syndicate += blackbox_msg
				if(RAID_FREQ)
					blackbox.msg_raider += blackbox_msg
				if(SUP_FREQ)
					blackbox.msg_cargo += blackbox_msg
				if(SRV_FREQ)
					blackbox.msg_service += blackbox_msg
				else
					blackbox.messages += blackbox_msg

		//End of research and feedback code.

	 /* ###### Send the message ###### */

		/* --- Process all the mobs that heard the voice normally (understood) --- */

		if(length(heard_normal))
			var/rendered = "[part_a][source][part_b]\"[text]\"[part_c]"

			for (var/mob/R in heard_normal)
				R.show_message(rendered, 2)

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")

		if(length(heard_garbled))
			var/quotedmsg = "\"[stars(text)]\""
			var/rendered = "[part_a][source][part_b][quotedmsg][part_c]"

			for (var/mob/R in heard_garbled)
				R.show_message(rendered, 2)


		/* --- Complete gibberish. Usually happens when there's a compressed message --- */

		if(length(heard_gibberish))
			var/quotedmsg = "\"[Gibberish(text, compression + 50)]\""
			var/rendered = "[part_a][Gibberish(source, compression + 50)][part_b][quotedmsg][part_c]"

			for (var/mob/R in heard_gibberish)
				R.show_message(rendered, 2)


#undef TELECOMMS_RECEPTION_NONE
#undef TELECOMMS_RECEPTION_SENDER
#undef TELECOMMS_RECEPTION_RECEIVER
#undef TELECOMMS_RECEPTION_BOTH
