/obj/effect/rune/tear_reality
	rune_name = "Tear Reality"
	rune_desc = "Sunders the space between this place and the Geometer's, allowing Nar-Sie to grace the world with its influence. Requires nine invokers, and can only be executed if It actually wills it so."
	rune_shorthand = "Sunder the space between this place and the Geometer's. Can only be executed if Nar-Sie actually wills it."
	required_invokers = 9
	circle_words = list(CULT_WORD_HELL, CULT_WORD_JOIN, CULT_WORD_SELF)
	invocation = "TOK-LYR RQA'NAP G'LT-UTOLF!"

/obj/effect/rune/tear_reality/can_invoke(mob/living/invoker)
	if (narsie_cometh)
		to_chat(invoker, SPAN_WARNING("The Geometer has already been called forth."))
		return
	else if (!cult.allow_narsie)
		to_chat(invoker, SPAN_WARNING("The Geometer does not wish the veil destroyed here this day."))
		return
	return TRUE

/obj/effect/rune/tear_reality/invoke(list/invokers)
	to_world("<font size='15' color='red'><b>IT COMES</b></font>")
	for (var/mob/M in player_list)
		M.playsound_local(M.loc, 'sound/effects/weather/wind/wind_5_1.ogg', 50)
	SetUniversalState(/datum/universal_state/hell)
	narsie_cometh = TRUE
	log_and_message_admins_many(invokers, "summoned the end of days.")
	addtimer(CALLBACK(src, .proc/call_shuttle), 10 SECONDS)

/obj/effect/rune/tear_reality/proc/call_shuttle()
	if (emergency_shuttle)
		emergency_shuttle.call_evac()
		emergency_shuttle.launch_time = 0
