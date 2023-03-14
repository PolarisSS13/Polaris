/obj/effect/rune/deafen
	rune_name = "Deafen"
	rune_desc = "Deafens all non-cultists near the rune."
	talisman_path = /obj/item/paper/talisman/deafen
	circle_words = list(CULT_WORD_HIDE, CULT_WORD_OTHER, CULT_WORD_SEE)
	invocation = "Dedo ol'btoh!"

/obj/effect/rune/deafen/invoke(list/invokers)
	visible_message(SPAN_DANGER("The runes dissipate into fine dust."))
	var/list/affected = list()
	for (var/mob/living/L in hearers(7, src))
		if (iscultist(L) || findNullRod(L))
			continue
		affected += L
		L.ear_deaf = max(50, L.ear_deaf)
		to_chat(L, SPAN_DANGER("Your ears pop and the world goes quiet."))
	add_attack_logs(invokers[1], affected, "deafness rune")
	qdel(src)
