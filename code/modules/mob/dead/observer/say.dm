/mob/observer/dead/say(var/message, var/datum/language/speaking = null, var/alt_name = "", var/whispering = 0)
	message = sanitize(message)

	if(!message)
		return

	log_ghostsay(message, src)

	if (client)
		if(message)
			client.handle_spam_prevention(MUTE_DEADCHAT)
			if(client.prefs.muted & MUTE_DEADCHAT)
				to_chat(src, "<font color='red'>You cannot talk in deadchat (muted).</font>")
				return

	. = say_dead(message)


/mob/observer/dead/me_verb(message as text)
	if(!message)
		return

	log_ghostemote(message, src)

	if(client)
		if(message)
			client.handle_spam_prevention(MUTE_DEADCHAT)
			if(client.prefs.muted & MUTE_DEADCHAT)
				to_chat(src, "<font color='red'>You cannot emote in deadchat (muted).</font>")
				return

	. = emote_dead(message)
