/obj/effect/newrune/communicate
	rune_name = "Communicate"
	rune_desc = "Allows you to communicate with other cultists."
	rune_shorthand = "Allows undetectable communication with other followers."
	talisman_path = /obj/item/paper/newtalisman/communicate
	circle_words = list(CULT_WORD_SELF, CULT_WORD_OTHER, CULT_WORD_TECHNOLOGY)
	invocation = "O bidai nabora se'sma!"

/obj/effect/newrune/communicate/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	var/input = input(L, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "") as null|text
	if (!input || !CanInteract(L, physical_state))
		return
	input = sanitize(input)
	log_and_message_admins("used a communicate rune to say '[input]'", usr)
	for (var/mob/M in player_list)
		if (iscultist(M) || isobserver(M))
			to_chat(M, SPAN_OCCULT(input))
