/obj/effect/newrune/blind
	rune_name = "Blind"
	rune_desc = "Blinds all non-cultists near the rune."
	rune_shorthand = "Blinds all non-cultists near the rune. Functions similarly in talisman form."
	circle_words = list(CULT_WORD_DESTROY, CULT_WORD_SEE, CULT_WORD_OTHER)
	invocation = "Sti'kaliesin!"

/obj/effect/newrune/blind/invoke(list/invokers)
	visible_message(SPAN_DANGER("The runes burst in a red flash."))
	for (var/mob/living/L in viewers(7, src))
		if (iscultist(L) || findNullRod(L))
			continue
		L.eye_blurry = max(50, L.eye_blurry)
		L.Blind(20)
		to_chat(L, SPAN_DANGER("Your vision floods with burning red light!"))
	qdel(src)
