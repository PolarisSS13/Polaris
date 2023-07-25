/obj/effect/rune/communicate
	rune_name = "Communicate"
	rune_desc = "Allows you to communicate with other cultists by speaking or whispering aloud next to the rune. The rune can be muted or unmuted by invoking it."
	talisman_path = /obj/item/paper/talisman/communicate
	circle_words = list(CULT_WORD_SELF, CULT_WORD_OTHER, CULT_WORD_TECHNOLOGY)
	invocation = "O bidai nabora se'sma!"
	whispered = TRUE
	var/muted = FALSE

/obj/effect/rune/communicate/examine(mob/user, infix, suffix)
	. = ..()
	if (iscultist(user) || isobserver(user))
		. += SPAN_DANGER("This rune [muted ? "is muted, and must be invoked before it will function" : "can be muted by invoking it"].")

/obj/effect/rune/communicate/hear_talk(mob/M, list/message_pieces, verb)
	var/msg = multilingual_to_message(message_pieces, with_capitalization = TRUE)
	if (iscultist(M) && get_dist(M, src) <= 1 && !muted)
		cult.cult_speak(M, msg)

/obj/effect/rune/communicate/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	muted = !muted
	to_chat(L, SPAN_NOTICE("This rune will [muted ? "no longer" : "now"] relay your words to the rest of the flock."))
