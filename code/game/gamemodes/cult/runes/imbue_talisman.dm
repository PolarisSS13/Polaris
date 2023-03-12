/obj/effect/newrune/imbue_talisman
	rune_name = "Imbue Talisman"
	rune_desc = "Etches the markings of a nearby rune onto a piece of paper on top of this one. Only some runes can be made into talismans."
	circle_words = list(CULT_WORD_HELL, CULT_WORD_TECHNOLOGY, CULT_WORD_JOIN)
	invocation = "H'drak v'loso, mir'kanas verbot!"

/obj/effect/newrune/imbue_talisman/can_invoke(mob/living/invoker)
	var/valid_runes
	for (var/obj/effect/newrune/N in orange(1, src))
		if (N.talisman_path)
			valid_runes++
	if (!valid_runes)
		to_chat(invoker, SPAN_WARNING("There are no nearby runes that can be made into a talisman."))
		return
	var/obj/item/paper/P = locate() in get_turf(src)
	if (!P)
		to_chat(invoker, SPAN_WARNING("A blank piece of paper must be placed on top of the rune to serve as a foundation."))
		return
	else if (P.info)
		to_chat(invoker, SPAN_WARNING("The blank is tainted with words and cannot be used."))
		return
	return TRUE

/obj/effect/newrune/imbue_talisman/invoke(list/invokers)
	var/list/valid_runes
	for (var/obj/effect/newrune/N in orange(1, src))
		if (N.talisman_path)
			LAZYADD(valid_runes, N)
	if (!LAZYLEN(valid_runes))
		return fizzle()
	var/obj/item/paper/P = locate() in get_turf(src)
	var/obj/effect/newrune/chosen = pick(valid_runes)
	var/obj/item/paper/newtalisman/T = new chosen.talisman_path (get_turf(src))
	chosen.apply_to_talisman(T)
	visible_message(SPAN_WARNING("The words from the runes slither onto \the [P], forming wet red symbols on its surface."))
	qdel(P)
	qdel(chosen)
	qdel(src)
