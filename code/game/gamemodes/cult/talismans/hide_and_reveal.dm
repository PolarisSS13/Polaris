/obj/item/paper/talisman/hide_runes
	talisman_name = "Hide Runes"
	talisman_desc = "Veils all nearby runes from sight, turning them invisible until they are revealed."
	invocation = "Kla'atu barada nikt'o!"

/obj/item/paper/talisman/hide_runes/invoke(mob/living/user)
	for (var/obj/effect/rune/R in range(2, user))
		if (R.invisibility < SEE_INVISIBLE_CULT)
			R.invisibility = SEE_INVISIBLE_CULT
			R.alpha = 150
	to_chat(user, SPAN_WARNING("Your talisman turns to gray dust, veiling the surrounding runes."))

/obj/item/paper/talisman/reveal_runes
	talisman_name = "Reveal Runes"
	talisman_desc = "Reveal all nearby hidden runes."
	invocation = "Nikt'o barada kla'atu!"

/obj/item/paper/talisman/reveal_runes/invoke(mob/living/user)
	for (var/obj/effect/rune/R in range(2, user))
		if (R.invisibility == SEE_INVISIBLE_CULT)
			R.invisibility = 0
			R.alpha = 255
	to_chat(user, SPAN_WARNING("Your talisman turns to red dust, revealing the surrounding runes."))
