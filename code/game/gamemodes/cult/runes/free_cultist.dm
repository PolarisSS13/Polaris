/obj/effect/newrune/free_cultist
	rune_name = "Free Cultist"
	required_invokers = 3
	circle_words = list(CULT_WORD_TRAVEL, CULT_WORD_TECHNOLOGY, CULT_WORD_OTHER)
	invocation = "Khari'd! Gual'te nikka!"
	var/timeout
	var/mob/living/current_invoker

/obj/effect/newrune/free_cultist/can_invoke(mob/living/invoker)
	if (timeout > world.time && invoker != current_invoker)
		to_chat(invoker, SPAN_WARNING("Allow the current invoker a moment to choose before overriding their will."))
		return
	if (current_invoker && invoker != current_invoker)
		to_chat(invoker, SPAN_DANGER("You have taken too long to choose a follower to free. [invoker] has overridden your will in the choice."))
	return TRUE

/obj/effect/newrune/free_cultist/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	var/list/candidates = list()
	for (var/mob/living/C in player_list - L)
		if (iscultist(C) && can_free(L) && !invokers.Find(C))
			candidates.Add(C)
	if (!candidates.len)
		to_chat(L, SPAN_WARNING("None of your peers need to be freed in this way."))
		return fizzle()
	timeout = world.time + 5 SECONDS
	current_invoker = L
	var/mob/living/carbon/human/choice = input(L, "Choose a follower to free.", rune_name) as null|anything in candidates
	if (!can_free(choice))
		return fizzle()
	for (var/mob/living/C in invokers)
		var/datum/gender/G = gender_datums[C.get_gender()]
		to_chat(C, SPAN_DANGER("You reach out through space, freeing [choice] of [G.his] bonds."))
		C.take_overall_damage(round(15 / invokers), 0)
	if (choice.handcuffed)
		choice.drop_from_inventory(choice.handcuffed)
	if (choice.legcuffed)
		choice.drop_from_inventory(choice.legcuffed)
	if (istype(choice.wear_suit, /obj/item/clothing/suit/straight_jacket))
		choice.drop_from_inventory(choice.wear_suit)
	if (istype(choice.loc, /obj/structure/closet))
		var/obj/structure/closet/amontillado = choice.loc
		if (amontillado.sealed)
			amontillado.visible_message(SPAN_WARNING("\The [src] flies open!"))
			amontillado.break_open()
	else if (istype(choice.loc, /obj/machinery/dna_scannernew))
		var/obj/machinery/dna_scannernew/D = choice.loc
		if (D.locked)
			D.visible_message(SPAN_WARNING("\The [D] grinds open!"))
			D.locked = FALSE
			D.eject_occupant()
	to_chat(choice, SPAN_DANGER("You feel a small surge of vitality as your peers channel their life force to free you of your bonds."))
	qdel(src)

/obj/effect/newrune/free_cultist/proc/can_free(mob/living/L)
	if (!L)
		return
	else if (L.restrained())
		return TRUE
	else if (istype(L.loc, /obj/structure/closet))
		var/obj/structure/closet/C = L.loc
		return C.req_breakout()
	else if (istype(L.loc, /obj/machinery/dna_scannernew))
		var/obj/machinery/dna_scannernew/D = L.loc
		return D.locked
	return
