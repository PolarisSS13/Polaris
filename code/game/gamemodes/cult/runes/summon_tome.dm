/obj/effect/newrune/summon_tome
	rune_name = "Summon Tome"
	rune_desc = "Manifests another copy of the Geometer's scripture."
	rune_shorthand = "Creates a new arcane tome."
	circle_words = list(CULT_WORD_SEE, CULT_WORD_BLOOD, CULT_WORD_HELL)
	invocation = "N'ath reth sh'yro eth d'raggathnor!"

/obj/effect/newrune/summon_tome/invoke(list/invokers)
	visible_message(SPAN_WARNING("Space is congealed into a blank book. The runes slither into the pages and drag the cover shut with a hollow thud."))
	new /obj/item/arcane_tome(get_turf(src))
	qdel(src)
