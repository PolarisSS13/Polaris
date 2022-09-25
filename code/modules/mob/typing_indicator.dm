/proc/generate_speech_bubble(var/bubble_loc, var/speech_state, var/set_layer = FLOAT_LAYER)
	var/image/I = image('icons/mob/talk.dmi', bubble_loc, speech_state, set_layer)
	I.appearance_flags |= (KEEP_APART|RESET_COLOR|PIXEL_SCALE)
	if(istype(bubble_loc, /atom/movable))
		var/atom/movable/AM = bubble_loc
		var/x_scale = AM.get_icon_scale_x()
		if(abs(x_scale) < 2) // reset transform on bubbles, except for the Very Large
			I.pixel_z = (AM.icon_expected_height * (x_scale-1))
			I.appearance_flags |= RESET_TRANSFORM
	return I

/mob/proc/init_typing_indicator(var/set_state = "typing")
	typing_indicator = new
	typing_indicator.appearance = generate_speech_bubble(null, set_state)
	typing_indicator.appearance_flags |= (KEEP_APART|RESET_COLOR|RESET_TRANSFORM|PIXEL_SCALE)

/mob/proc/set_typing_indicator(var/state) //Leaving this here for mobs.

	if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
		if(typing_indicator)
			cut_overlay(typing_indicator, TRUE)
		return

	if(!typing_indicator)
		init_typing_indicator("[speech_bubble_appearance()]_typing")

	if(state && !typing)
		add_overlay(typing_indicator, TRUE)
		typing = TRUE
	else if(!state && typing)
		cut_overlay(typing_indicator, TRUE)
		typing = FALSE

	if(shadow) //Multi-Z above-me shadows
		shadow.set_typing_indicator(state)

	return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	set_typing_indicator(TRUE)
	textbox_typing = TRUE
	var/message = input("","say (text)") as text
	set_typing_indicator(FALSE)
	textbox_typing = FALSE

	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	set_typing_indicator(TRUE)
	textbox_typing = TRUE
	var/message = input("","me (text)") as text
	set_typing_indicator(FALSE)
	textbox_typing = FALSE

	if(message)
		me_verb(message)

/mob/proc/handle_input_typing_indicator()
	set waitfor=FALSE
	if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
		return

	// winget() has to contact the client, so could block the rest of life() for poorer connections
	// If a textbox has already latched this up, don't bother checking.
	if(!textbox_typing)
		var/t = winget(src, "mainwindow.input", "text")
		if(cmptext(copytext(t, 1, 6), "say \"") && length(copytext(t, 6)))
			set_typing_indicator(TRUE)
		// Could have changed during the winget()
		else if(!textbox_typing)
			set_typing_indicator(FALSE)
