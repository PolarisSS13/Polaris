/obj/effect/newrune/summon_cultist
	rune_name = "Summon Cultist"
	rune_desc = "Reaches out through space and drags a fellow cultist to the location of the rune. They must not be restrained in any way. The rune requires three invokers, and causes heavy strain on all involved."
	required_invokers = 3
	circle_words = list(CULT_WORD_JOIN, CULT_WORD_OTHER, CULT_WORD_SELF)
	invocation = "N'ath reth sh'yro eth d'rekkathnor!"
	var/timeout
	var/mob/living/current_invoker

/obj/effect/newrune/summon_cultist/can_invoke(mob/living/invoker)
	if (timeout > world.time && invoker != current_invoker)
		to_chat(invoker, SPAN_WARNING("Allow the current invoker a moment to choose before overriding their will."))
		return
	if (current_invoker && invoker != current_invoker)
		to_chat(invoker, SPAN_DANGER("You have taken too long to choose a follower to free. [invoker] has overridden your will in the choice."))
	return TRUE

/obj/effect/newrune/summon_cultist/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	var/list/candidates = list()
	for (var/mob/living/C in player_list - L)
		if (iscultist(C) && !invokers.Find(C))
			candidates.Add(C)
	if (!candidates.len)
		to_chat(L, SPAN_WARNING("No cultists can be summoned in this way."))
		return fizzle()
	timeout = world.time + 5 SECONDS
	current_invoker = L
	var/mob/living/carbon/human/choice = input(L, "Choose a follower to summon.", rune_name) as null|anything in candidates
	if (L != current_invoker)
		return
	if (choice && !can_summon(choice))
		var/datum/gender/G = gender_datums[choice.get_gender()]
		for (var/mob/living/L2 in invokers)
			to_chat(L2, SPAN_WARNING("You cannot summon [choice], for [G.he] [G.is] bound in place. You must free [G.him] first."))
	for (var/mob/living/C in invokers)
		to_chat(C, SPAN_DANGER("You reach out together through space, dragging [choice] to your location."))
		C.take_overall_damage(round(25 / invokers.len), 0)
		if (invokers.len <= get_required_invokers(C)) // Minimum invokers causes stuns
			C.Weaken(1)
			C.Stun(rand(3, 6))
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(1, 0, choice.loc, 0)
	smoke.start()
	choice.visible_message(
		SPAN_DANGER("\The [choice] is engulfed by black smoke!"),
		SPAN_DANGER("You feel your peers calling you forward, and are pulled through space...")
	)
	choice.forceMove(get_turf(src))
	choice.lying = TRUE
	choice.regenerate_icons()
	choice.visible_message(
		SPAN_WARNING("The runes bubble, and [choice] is thrust through them onto the ground!"),
		SPAN_DANGER("...and you emerge on top of the runes they used to bring you forth.")
	)
	qdel(src)

/obj/effect/newrune/summon_cultist/proc/can_summon(mob/living/L)
	if (!L)
		return
	else if (L.restrained())
		return
	else if (istype(L.loc, /obj/structure/closet))
		var/obj/structure/closet/C = L.loc
		return !C.req_breakout()
	else if (istype(L.loc, /obj/machinery/dna_scannernew))
		var/obj/machinery/dna_scannernew/D = L.loc
		return !D.locked
	return TRUE
