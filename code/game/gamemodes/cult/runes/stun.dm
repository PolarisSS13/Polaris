/obj/effect/rune/stun
	rune_name = "Stun"
	rune_desc = "This rune is specialized for use in talismans; invoked on its own, its only effect is to slightly disorient nearby beings."
	talisman_path = /obj/item/paper/talisman/stun
	circle_words = list(CULT_WORD_JOIN, CULT_WORD_HIDE, CULT_WORD_TECHNOLOGY)
	invocation = "Fuu ma'jin!"

/obj/effect/rune/stun/invoke(list/invokers)
	visible_message(SPAN_DANGER("The runes explode in a bright flash of light!"))
	for (var/mob/living/L in viewers(src))
		if (issilicon(L))
			L.Weaken(5)
		else
			L.flash_eyes()
			L.stuttering = min(1, L.stuttering)
			L.Weaken(1)
			L.Stun(1)
	add_attack_logs(invokers[1], viewers(src), "stun rune")
	qdel(src)
