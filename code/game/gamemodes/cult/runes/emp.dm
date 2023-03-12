/obj/effect/newrune/emp
	rune_name = "Disable Technology"
	rune_desc = "Emits a strong electromagnetic pulse in a medium-sized radius, disabling or harming nearby electronics."
	rune_shorthand = "Emits a strong, short-ranged EMP."
	talisman_path = /obj/item/paper/newtalisman/emp
	circle_words = list(CULT_WORD_DESTROY, CULT_WORD_SEE, CULT_WORD_TECHNOLOGY)
	invocation = "Ta'gh fara'qha fel d'amar det!"

/obj/effect/newrune/emp/invoke(list/invokers)
	var/turf/T = get_turf(src)
	if (T)
		T.hotspot_expose(700, 125)
	visible_message(SPAN_DANGER("A wave of heat emanates outwards from the runes as they shimmer and vanish."))
	playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
	empulse(T, 2, 3, 4, 5)
	qdel(src)
