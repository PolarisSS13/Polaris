/obj/effect/newrune/hide_runes
	rune_name = "Hide Runes"
	rune_desc = "Veils all nearby runes from sight, turning them invisible until they are revealed."
	talisman_path = /obj/item/paper/newtalisman/hide_runes
	circle_words = list(CULT_WORD_HIDE, CULT_WORD_SEE, CULT_WORD_BLOOD)
	invocation = "Kla'atu barada nikt'o!"

/obj/effect/newrune/hide_runes/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	for (var/obj/effect/newrune/R in range(4, src))
		if (R.invisibility < SEE_INVISIBLE_CULT)
			R.invisibility = SEE_INVISIBLE_CULT
			R.alpha = 150 // Visual effect for ghosts so they know it's invisible
	to_chat(L, SPAN_WARNING("The scratchings turn to dust, veiling the surrounding runes."))
	qdel(src)

/obj/effect/newrune/reveal_runes
	rune_name = "Reveal Runes"
	rune_desc = "Reverses the effects of <i>Hide Runes</i>, causing all nearby invisible runes to become visible once more."
	talisman_path = /obj/item/paper/newtalisman/reveal_runes
	circle_words = list(CULT_WORD_BLOOD, CULT_WORD_SEE, CULT_WORD_HIDE)
	invocation = "Nikt'o barada kla'atu!"

/obj/effect/newrune/reveal_runes/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	for (var/obj/effect/newrune/R in range(4, src))
		if (R.invisibility == SEE_INVISIBLE_CULT)
			R.invisibility = 0
			R.alpha = 255
	to_chat(L, SPAN_WARNING("The scratchings turn to dust, revealing the surrounding runes."))
	qdel(src)
