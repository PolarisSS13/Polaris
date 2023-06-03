/mob
	var/next_emote
	var/next_emote_refresh
	var/last_emote_summary

/mob/proc/get_available_emotes()
	return global._default_mob_emotes

/mob/proc/can_emote(var/emote_type)
	return (stat == CONSCIOUS)

/mob/living/can_emote(var/emote_type)
	return (..() && !(silent && emote_type == AUDIBLE_MESSAGE))

#define EMOTE_REFRESH_SPAM_COOLDOWN (5 SECONDS)
/mob/proc/emote(var/act, var/m_type, var/message)
	set waitfor = FALSE
	// s-s-snowflake
	if(src.stat == DEAD && act != "deathgasp")
		return

	if(usr == src) //client-called emote
		if (client && (client.prefs.muted & MUTE_IC))
			to_chat(src, "<span class='warning'>You cannot send IC messages (muted).</span>")
			return

		if(world.time < next_emote)
			to_chat(src, SPAN_WARNING("You cannot use another emote yet."))
			return

		if(act == "help")
			if(world.time >= next_emote_refresh)
				var/list/usable_emotes = list()
				next_emote_refresh = world.time + EMOTE_REFRESH_SPAM_COOLDOWN
				for(var/emote in get_available_emotes())
					var/decl/emote/emote_datum = decls_repository.get_decl(emote)
					if(emote_datum.mob_can_use(src))
						usable_emotes[emote_datum.key] = emote_datum
				last_emote_summary = english_list(sortAssoc(usable_emotes))
			to_chat(src,"<b>Usable emotes:</b> [last_emote_summary].")
			return

		if(!can_emote(m_type))
			to_chat(src, SPAN_WARNING("You cannot currently [m_type == AUDIBLE_MESSAGE ? "audibly" : "visually"] emote!"))
			return

		if(act == "me")
			return custom_emote(m_type, message)

		if(act == "custom")
			if (!m_type)
				if(alert(src, "Is this an audible emote?", "Emote", "Yes", "No") == "No")
					m_type = VISIBLE_MESSAGE
				else
					m_type = AUDIBLE_MESSAGE
			return custom_emote(m_type, message)

	var/splitpoint = findtext(act, " ")
	if(splitpoint > 0)
		var/tempstr = act
		act = copytext(tempstr,1,splitpoint)
		message = copytext(tempstr,splitpoint+1,0)

	var/decl/emote/use_emote = get_emote_by_key(act)
	if(!istype(use_emote))
		to_chat(src, SPAN_WARNING("Unknown emote '[act]'. Type <b>say *help</b> for a list of usable emotes."))
		return

	if(!use_emote.mob_can_use(src))
		to_chat(src, SPAN_WARNING("You cannot use the emote '[act]'. Type <b>say *help</b> for a list of usable emotes."))
		return

	if(m_type != use_emote.message_type && use_emote.conscious && stat != CONSCIOUS)
		return

	if(use_emote.message_type == AUDIBLE_MESSAGE && is_muzzled())
		var/muffle_message = use_emote.emote_message_muffled || "makes a muffled sound."
		audible_message("<b>\The [src]</b> [muffle_message]", runemessage = "[muffle_message]")
		return

	next_emote = world.time + use_emote.emote_delay
	use_emote.do_emote(src, message)

#undef EMOTE_REFRESH_SPAM_COOLDOWN

/mob/proc/format_emote(var/emoter = null, var/message = null)
	var/pretext
	var/subtext
	var/nametext
	var/end_char
	var/start_char
	var/name_anchor

	if(!message || !emoter)
		return

	message = html_decode(message)

	name_anchor = findtext(message, "*")
	if(name_anchor > 0) // User supplied emote with visible_emote token
		pretext = copytext(message, 1, name_anchor)
		subtext = copytext(message, name_anchor + 1, length(message) + 1)
	else
		// No token. Just the emote as usual.
		subtext = message

	// Oh shit, we got this far! Let's see... did the user attempt to use more than one token?
	if(findtext(subtext, "*"))
		// abort abort!
		to_chat(emoter, SPAN_WARNING("You may use only one \"["*"]\" symbol in your emote."))
		return

	if(pretext)
		// Add a space at the end if we didn't already supply one.
		end_char = copytext(pretext, length(pretext), length(pretext) + 1)
		if(end_char != " ")
			pretext += " "

	// Grab the last character of the emote message.
	end_char = copytext(subtext, length(subtext), length(subtext) + 1)
	if(!(end_char in list(".", "?", "!", "\"", "-", "~"))) // gotta include ~ for all you fucking weebs
		// No punctuation supplied. Tack a period on the end.
		subtext += "."

	// Add a space to the subtext, unless it begins with an apostrophe or comma.
	if(subtext != ".")
		// First, let's get rid of any existing space, to account for sloppy emoters ("X, ^ , Y")
		subtext = trim_left(subtext)
		start_char = copytext(subtext, 1, 2)
		if(start_char != "," && start_char != "'")
			subtext = " " + subtext

	pretext = capitalize(html_encode(pretext))
	nametext = html_encode(nametext)
	subtext = html_encode(subtext)
	// Store the player's name in a nice bold, naturalement
	nametext = "<B>[emoter]</B>"
	return list("pretext" = pretext, "nametext" = nametext, "subtext" = subtext)

/mob/proc/custom_emote(var/m_type = VISIBLE_MESSAGE, var/message, var/range = world.view)

	set waitfor = FALSE // Due to input() below and this being used in Life() procs.

	if(stat != CONSCIOUS || (!use_me && usr == src))
		to_chat(src, "You are unable to emote.")
		return

	if(!message)
		message = input(usr, "Please enter an emote to display. You can use \"*\" to reposition your character name within the emote.") as text|null
		// Recheck due to input()
		if(stat != CONSCIOUS || (!use_me && usr == src))
			to_chat(src, "You are unable to emote.")
			return

	message = html_decode(sanitize(message))
	if(!message)
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	var/list/formatted
	var/runemessage

	formatted = format_emote(src, message)
	var/pretext =  formatted["pretext"]
	var/nametext = formatted["nametext"]
	var/subtext =  formatted["subtext"]
	if(pretext) // If we have a split emote we need to show the pretext and name.
		runemessage = "[pretext][nametext][subtext]"
	else
		runemessage = subtext
	// This is just personal preference (but I'm objectively right) that custom emotes shouldn't have periods at the end in runechat
	runemessage = replacetext(runemessage,".","",length(runemessage),length(runemessage)+1)

	log_emote("[pretext][nametext][subtext]", src) //Log before we add junk
	message = encode_html_emphasis("<span class='emote'>[pretext]<b>[nametext]</b>[subtext]</span>")

	var/list/in_range = get_mobs_and_objs_in_view_fast(T,range,2,remote_ghosts = client ? TRUE : FALSE)
	var/list/m_viewers = in_range["mobs"]
	var/list/o_viewers = in_range["objs"]

	for(var/mob/M as anything in m_viewers)
		if(isobserver(M))
			M.show_message("<span class='emote'>[pretext]<b>[ghost_follow_link(src, M, nametext)]</b>[subtext]</span>", m_type)
		else
			M.show_message(message, m_type)
		M.create_chat_message(src, "[runemessage]", FALSE, list("emote"), (m_type == AUDIBLE_MESSAGE))

	for(var/obj/O as anything in o_viewers)
		O.see_emote(src, message, m_type)

// Specific mob type exceptions below.
/mob/living/carbon/human/emote(act, m_type, message)
	. = ..()
	for (var/obj/item/organ/external/organ in src.organs)
		for (var/obj/item/implant/I in organ.implants)
			if (I.implanted)
				I.trigger(act, src)

/mob/living/silicon/ai/emote(var/act, var/type, var/message)
	var/obj/machinery/hologram/holopad/T = src.holo
	if(T && T.masters[src]) //Is the AI using a holopad?
		src.holopad_emote(message)
	else //Emote normally, then.
		..()
