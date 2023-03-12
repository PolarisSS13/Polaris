/obj/effect/rune/teleport
	rune_name = "Teleport"
	rune_desc = "When invoked, teleports anything on top of itself to another Teleport rune sharing the same keyword."
	talisman_path = /obj/item/paper/talisman/teleport
	circle_words = list(CULT_WORD_TRAVEL, CULT_WORD_SELF, CULT_WORD_OTHER)
	invocation = "Sas'so c'arta forbici!"
	var/key_word = CULT_WORD_OTHER

/obj/effect/rune/teleport/examine(mob/user, infix, suffix)
	. = ..()
	if (iscultist(user) || isobserver(user))
		. += SPAN_DANGER("This rune has a key word of \"[key_word]\".")

/obj/effect/rune/teleport/after_scribe(mob/living/author)
	var/word = input(author, "Choose a key word for this rune.", rune_name) as null|anything in cult.english_words
	if (QDELETED(src) || QDELETED(author))
		return
	if (!word)
		to_chat(author, SPAN_WARNING("No key word specified. Using \"[key_word]\" instead."))
	else
		key_word = word
		circle_words[3] = word
	update_icon()

/obj/effect/rune/teleport/can_invoke(mob/living/invoker)
	var/valid_runes = 0
	for (var/obj/effect/rune/teleport/T in cult.all_runes - src)
		if (T.key_word == key_word)
			valid_runes++
	if (!valid_runes)
		to_chat(invoker, SPAN_WARNING("There are no other Teleport runes with a keyword of \"[key_word]\"."))
		return
	return TRUE

/obj/effect/rune/teleport/invoke(list/invokers)
	var/list/runes
	for (var/obj/effect/rune/teleport/T in cult.all_runes - src)
		if (T.key_word == key_word)
			LAZYADD(runes, T)
	if (!LAZYLEN(runes))
		return fizzle()
	var/obj/effect/rune/teleport/T = pick(runes)
	var/turf/new_loc = get_turf(T)
	for (var/mob/living/L in get_turf(src))
		to_chat(L, SPAN_WARNING("You are dragged through space!"))
		L.forceMove(new_loc)
	for (var/obj/O in get_turf(src))
		if (!O.anchored)
			O.forceMove(new_loc)
	visible_message(SPAN_DANGER("\The [src] emit\s a burst of red light!"))
	T.visible_message(SPAN_DANGER("\The [src] emit\s a burst of red light!"))

/obj/effect/rune/teleport/apply_to_talisman(obj/item/paper/talisman/T)
	var/obj/item/paper/talisman/teleport/TP = T
	TP.key_word = key_word
