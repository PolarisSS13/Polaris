/mob/proc/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	return

/mob/verb/whisper(message as text)
	set name = "Whisper"
	set category = "IC"

	usr.say(message,whispering=1)

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	set_typing_indicator(FALSE)
	usr.say(message)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<font color='red'>Speech is currently admin-disabled.</font>")
		return

	message = sanitize(message)

	set_typing_indicator(FALSE)
	if(use_me)
		custom_emote(usr.emote_type, message)
	else
		usr.emote(message)

/mob/proc/say_dead(var/message)
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(!client)
		return // Clientless mobs shouldn't be trying to talk in deadchat.

	if(!client.holder)
		if(!config.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return

	if(!is_preference_enabled(/datum/client_preference/show_dsay))
		to_chat(usr, "<span class='danger'>You have deadchat muted.</span>")
		return

	message = encode_html_emphasis(message)

	say_dead_direct("[pick("complains","moans","whines","laments","blubbers")], <span class='message'>\"[message]\"</span>", src)

/mob/proc/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(stat == DEAD)
		return TRUE

	//Universal speak makes everything understandable, for obvious reasons.
	else if(universal_speak || universal_understand)
		return TRUE

	//Languages are handled after.
	if(!speaking)
		if(!other)
			return TRUE
		if(other.universal_speak)
			return TRUE
		if(isAI(src) && ispAI(other))
			return TRUE
		if(istype(other, type) || istype(src, other.type))
			return TRUE
		return FALSE

	if(speaking.flags & INNATE)
		return TRUE

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if(speaking.flags & NONVERBAL)
		if(sdisabilities & BLIND || blinded)
			return FALSE
		if(!other || !(other in view(src)))
			return FALSE

	//Language check.
	for(var/datum/language/L in languages)
		if(speaking.name == L.name)
			return TRUE

	return FALSE

/mob/proc/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "says"
	var/ending = copytext(message, length(message))

	if(speaking)
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending == "!")
			verb = pick("exclaims", "shouts", "yells")
		else if(ending == "?")
			verb = "asks"
	return verb


/mob/proc/emote(var/act, var/type, var/message)
	if(act == "me")
		return custom_emote(type, message)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(var/text)
	var/ending = copytext(text, length(text))
	if(ending == "?")
		return "1"
	else if(ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(var/message, var/standard_mode = "headset")
	if(length(message) >= 1 && copytext(message, 1, 2) == ";")
		return standard_mode

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1, 3)
		return department_radio_keys[channel_prefix]

	return null

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(var/message)
	var/prefix = copytext(message,1,2)
	// This is for audible emotes
	if(length(message) >= 1 && prefix == "!")
		return GLOB.all_languages["Noise"]

	if(length(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = copytext(message, 2 ,3)
		var/datum/language/L = GLOB.language_keys[language_prefix]
		if(can_speak(L))
			return L
		else
			return GLOB.all_languages[LANGUAGE_GIBBERISH]
	return null
