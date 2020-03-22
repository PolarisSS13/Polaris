/datum/event2/meta/comms_blackout
	name = "communications blackout"
	departments = list(DEPARTMENT_EVERYONE) // It's not an engineering event because engineering can't do anything to help . . . for now.
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	reusable = TRUE
	event_type = /datum/event2/event/comms_blackout

/datum/event2/meta/comms_blackout/get_weight()
	return 50 + metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5



/datum/event2/event/comms_blackout/announce()
	if(prob(33))
		command_announcement.Announce("Ionospheric anomalies detected. \
		Temporary telecommunication failure imminent. Please contact you-BZZT", new_sound = 'sound/misc/interference.ogg')
	// AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
	for(var/mob/living/silicon/ai/A in player_list)
		to_chat(A, "<br>")
		to_chat(A, "<span class='warning'><b>Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT</b></span>")
		to_chat(A, "<br>")

/datum/event2/event/comms_blackout/start()
	if(prob(50))
		// One in two chance for the radios to turn i%t# t&_)#%, which can be more alarming than radio silence.
		log_debug("Doing partial outage of telecomms.")
		for(var/obj/machinery/telecomms/processor/P in telecomms_list)
			P.emp_act(1)
	else
		// Otherwise just shut everything down, madagascar style.
		log_debug("Doing complete outage of telecomms.")
		for(var/obj/machinery/telecomms/T in telecomms_list)
			T.emp_act(1)
