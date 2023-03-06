/obj/effect/newrune/deafen
	rune_name = "Deafen"
	rune_desc = "Deafens all non-cultists near the rune."
	rune_shorthand = "Deafens all non-cultists near the rune. Functions similarly in talisman form."
	circle_words = list(CULT_WORD_HIDE, CULT_WORD_OTHER, CULT_WORD_SEE)
	invocation = "Sti'kaliedir!"

/obj/effect/newrune/deafen/invoke(list/invokers)
	visible_message(SPAN_DANGER("The runes dissipate into fine dust."))
	for (var/mob/living/L in hearers(7, src))
		if (iscultist(L) || findNullRod(L))
			continue
		L.ear_deaf = max(50, ear_deaf)
		to_chat(L, SPAN_DANGER("Your ears pop and the world goes quiet."))
