/obj/machinery/telecomms/server
	name = "Telecommunication Server"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comm_server"
	desc = "A machine used to store data and network statistics."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	machinetype = 4
	circuit = /obj/item/circuitboard/telecomms/server
	var/list/stored_names = list()
	var/list/TrafficActions = list()
	var/list/log_entries = list()
	var/logs = 0 // number of logs
	var/max_logs = 400 // maximum number of logs
	var/log_cull_count = 10 // number of logs to cull at a time
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)
	var/encryption = "null" // encryption key: ie "password"
	var/salt = "null" // encryption salt: ie "123comsat"
	var/obj/item/radio/headset/server_radio


/obj/machinery/telecomms/server/Destroy()
	QDEL_NULL_LIST(log_entries)
	QDEL_NULL(server_radio)
	return ..()


/obj/machinery/telecomms/server/Initialize()
	server_radio = new
	return ..()


/obj/machinery/telecomms/server/receive_information(datum/signal/signal, obj/machinery/telecomms/sender)
	if (!signal.data["message"])
		return
	if (is_freq_listening(signal))
		if (traffic > 0)
			totaltraffic += traffic
		if (signal.data["type"] != SIGNAL_TEST)
			update_logs()
			var/datum/comm_log_entry/log = new
			var/mob/M = signal.data["mob"]
			log.parameters["mobtype"] = signal.data["mobtype"]
			log.parameters["job"] = signal.data["job"]
			log.parameters["key"] = signal.data["key"]
			log.parameters["vmessage"] = multilingual_to_message(signal.data["message"])
			log.parameters["vname"] = signal.data["vname"]
			log.parameters["message"] = multilingual_to_message(signal.data["message"])
			log.parameters["name"] = signal.data["name"]
			log.parameters["realname"] = signal.data["realname"]
			log.parameters["timecode"] = worldtime2stationtime(world.time)
			var/race = "unknown"
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				race = "[H.species.name]"
				log.parameters["intelligible"] = TRUE
			else if (isbrain(M))
				race = "Brain"
				log.parameters["intelligible"] = TRUE
			else if (M.isMonkey())
				race = "Monkey"
			else if (issilicon(M))
				race = "Artificial Life"
				log.parameters["intelligible"] = TRUE
			else if (isslime(M))
				race = "Slime"
			else if (isanimal(M))
				race = "Domestic Animal"
			log.parameters["race"] = race
			if (M && !istype(M, /mob/new_player))
				log.parameters["uspeech"] = M.universal_speak
			else
				log.parameters["uspeech"] = FALSE
			if (signal.data["compression"] > 0) // If the signal is still compressed, make the log entry gibberish
				log.parameters["message"] = Gibberish(multilingual_to_message(signal.data["message"]), signal.data["compression"] + 50)
				log.parameters["job"] = Gibberish(signal.data["job"], signal.data["compression"] + 50)
				log.parameters["name"] = Gibberish(signal.data["name"], signal.data["compression"] + 50)
				log.parameters["realname"] = Gibberish(signal.data["realname"], signal.data["compression"] + 50)
				log.parameters["vname"] = Gibberish(signal.data["vname"], signal.data["compression"] + 50)
				log.input_type = "Corrupt File"
			log_entries += log
			if (!(signal.data["name"] in stored_names))
				stored_names += signal.data["name"]
			logs++
			signal.data["server"] = src
			var/identifier = num2text(rand(-1000, 1000) + world.time)
			log.name = "data packet ([sha1(identifier)])"
	var/send_success = relay_information(signal, /obj/machinery/telecomms/hub)
	if (!send_success)
		relay_information(signal, /obj/machinery/telecomms/broadcaster)


/obj/machinery/telecomms/server/proc/add_entry(content, input)
	var/datum/comm_log_entry/log = new
	var/identifier = num2text(rand(-1000, 1000) + world.time)
	log.name = "[input] ([sha1(identifier)])"
	log.input_type = input
	log.parameters["message"] = content
	log.parameters["timecode"] = stationtime2text()
	log_entries += log
	update_logs()


/obj/machinery/telecomms/server/proc/update_logs()
	if (logs >= max_logs)
		log_entries.Cut(0, log_cull_count)
		logs -= log_cull_count
