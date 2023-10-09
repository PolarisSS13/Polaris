/obj/item/paper/talisman/communicate
	talisman_name = "Communicate"
	talisman_desc = "Allows you to communicate with other cultists."
	tome_desc = "Disposable; activate to whisper a single message to the rest of the cult."
	invocation = "O bidai nabora se'sma!"
	whispered = TRUE
	delete_self = FALSE

/obj/item/paper/talisman/communicate/invoke(mob/living/user)
	// This is more or less a verbatim copy of the communicate rune
	var/input = input(user, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "") as null|text
	if (!input || !CanInteract(user, physical_state))
		return
	input = sanitize(input)
	log_and_message_admins("used a communicate talisman to say '[input]'", usr)
	cult.cult_speak(user, input)
	qdel(src)
