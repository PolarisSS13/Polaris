/obj/item/paper/talisman/teleport
	talisman_name = "Teleport"
	talisman_desc = "Teleports its invoker to the location of a random Teleport rune with the same keyword."
	tome_desc = "On activation, teleports its user to a random rune of the same keyword."
	invocation = "Sas'so c'arta forbici!"
	delete_self = FALSE
	var/key_word = CULT_WORD_OTHER

/obj/item/paper/talisman/teleport/examine(mob/user)
	. = ..()
	if (iscultist(user) || isobserver(user))
		. += SPAN_DANGER("This talisman's key word is \"[key_word]\".")

/obj/item/paper/talisman/teleport/invoke(mob/living/user)
	var/list/runes
	for (var/obj/effect/rune/teleport/T in cult.all_runes)
		if (T.key_word == key_word)
			LAZYADD(runes, T)
	if (!LAZYLEN(runes))
		to_chat(user, SPAN_WARNING("There are no existing Teleport runes with a key word of \"[key_word]\"."))
		return
	var/obj/effect/rune/teleport/T = pick(runes)
	user.visible_message(
		SPAN_WARNING("\The [user] dissolves into a cloud of black smoke!"),
		SPAN_DANGER("You invoke the talisman...")
	)
	user.forceMove(get_turf(T))
	user.visible_message(
		SPAN_WARNING("\The [user] appears in a cloud of black smoke!"),
		SPAN_DANGER("...and appear elsewhere.")
	)
	qdel(src)
