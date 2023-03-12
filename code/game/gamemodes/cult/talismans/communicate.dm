/obj/item/paper/newtalisman/communicate
	talisman_name = "Communicate"
	talisman_desc = "Allows you to communicate with other cultists."
	invocation = "O bidai nabora se'sma!"
	whispered = TRUE
	delete_self = FALSE

/obj/item/paper/newtalisman/communicate/invoke(mob/living/user)
	// This is more or less a verbatim copy of the communicate rune
	var/input = input(user, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "") as null|text
	if (!input || !CanInteract(user, physical_state))
		return
	input = sanitize(input)
	log_and_message_admins("used a communicate talisman to say '[input]'", usr)
	for (var/mob/M in player_list)
		if (iscultist(M) || isobserver(M))
			to_chat(M, SPAN_OCCULT(input))
	qdel(src)
