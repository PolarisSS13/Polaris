/obj/effect/rune/see_invisible
	rune_name = "See Invisible"
	rune_desc = "Grants vision into the world beyond as long as one remains on top of the rune, revealing spirits and invisible runes."
	circle_words = list(CULT_WORD_SEE, CULT_WORD_HELL, CULT_WORD_JOIN)
	invocation = "Rash'tla sektath mal'zua. Zasan therium vivira. Itonis al'ra matum!"
	var/mob/living/oracle

/obj/effect/rune/see_invisible/Destroy()
	if (oracle)
		oracle.seer = FALSE
		oracle.see_invisible = oracle.see_invisible_default
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/rune/see_invisible/can_invoke(mob/living/invoker)
	if (oracle)
		to_chat(invoker, SPAN_WARNING("[invoker == oracle ? "You are" : "Another is"] already using this rune."))
		return
	else if (get_turf(invoker) != get_turf(src))
		to_chat(invoker, SPAN_WARNING("You must stand on top of this rune to use it."))
		return
	return TRUE

/obj/effect/rune/see_invisible/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	to_chat(L, SPAN_NOTICE("The world beyond opens to your eyes."))
	oracle = L
	oracle.seer = TRUE
	oracle.see_invisible = SEE_INVISIBLE_OBSERVER
	START_PROCESSING(SSfastprocess, src)

/obj/effect/rune/see_invisible/process()
	if (!oracle || !iscultist(oracle) || get_turf(oracle) != get_turf(src))
		if (oracle)
			to_chat(oracle, SPAN_WARNING("The world beyond fades from your sight."))
			oracle.seer = FALSE
			oracle.see_invisible = oracle.see_invisible_default
		oracle = null
		STOP_PROCESSING(SSfastprocess, src)
