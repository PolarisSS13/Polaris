/obj/effect/rune/imbue_talisman
	rune_name = "Imbue Talisman"
	rune_desc = "Used to create talismans. To use, place a sheet of paper onto this rune, then scribe a different type of rune adjacent to this one. Invoke this one afterwards, and the other rune will be etched onto the paper, creating a talisman out of it. Only some runes can be made into talismans."
	rune_shorthand = "Used to create talismans out of sheets of paper and other runes."
	circle_words = list(CULT_WORD_HELL, CULT_WORD_TECHNOLOGY, CULT_WORD_JOIN)
	invocation = "H'drak v'loso, mir'kanas verbot!"

/obj/effect/rune/imbue_talisman/can_invoke(mob/living/invoker)
	var/valid_runes
	for (var/obj/effect/rune/N in orange(1, src))
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

/obj/effect/rune/imbue_talisman/invoke(list/invokers)
	var/list/valid_runes
	for (var/obj/effect/rune/N in orange(1, src))
		if (N.talisman_path)
			LAZYADD(valid_runes, N)
	if (!LAZYLEN(valid_runes))
		return fizzle()
	var/obj/item/paper/P = locate() in get_turf(src)
	var/obj/effect/rune/chosen = pick(valid_runes)
	var/obj/item/paper/talisman/T = new chosen.talisman_path (get_turf(src))
	chosen.apply_to_talisman(T)
	visible_message(SPAN_NOTICE("The words from the runes slither onto \the [P], forming wet red symbols on its surface."))
	qdel(P)
	qdel(chosen)
	qdel(src)
