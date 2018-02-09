#define TYPING_INDICATOR_LIFETIME 5 * 10	//grace period after which typing indicator disappears regardless of text in chatbar. 5 seconds.

/mob/proc/set_typing_indicator(var/state) //Leaving this here for mobs.

	if(!typing_indicator)
		typing_indicator = new
		typing_indicator.icon = 'icons/mob/talk.dmi'
		typing_indicator.icon_state = "[speech_bubble_appearance()]_typing"

	if(client && !stat)
		typing_indicator.invisibility = invisibility
		if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
			overlays -= typing_indicator
		else
			if(state)
				if(!typing)
					overlays += typing_indicator
					typing = 1
			else
				if(typing)
					overlays -= typing_indicator
					typing = 0
			return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(1)
	hud_typing = 1
	update_icons_huds()
	var/message = input("","say (text)") as text
	hud_typing = 0
	update_icons_huds()
	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(0)
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(1)
	hud_typing = 1
	update_icons_huds()
	var/message = input("","me (text)") as text
	hud_typing = 0
	update_icons_huds()
	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(0)
	if(message)
		me_verb(message)

//This segment is unused. Being updated to actually be usable. WIP!!!
/mob/proc/handle_typing_indicator() //This was disabled three years ago. I'm going to get the typing indicator fixed and THEN work on fixing this, too. ~Jas
	if(!client || stat) //No client or dead/KO'd? No typing indicator.
		return

	if(!hud_typing && is_preference_enabled(/datum/client_preference/show_typing_indicator)) //Are they using the popout window? If so, don't time it out.
		var/temp = winget(client, "input", "text")

		if (temp != last_typed)
			last_typed = temp
			last_typed_time = world.time

		if (world.time > last_typed_time + TYPING_INDICATOR_LIFETIME)
			if(!ishuman(src))
				set_typing_indicator(0)
			chatbar_typing = 0
			return

		if(length(temp) > 5 && findtext(temp, "Say \"", 1, 7))
			if(!ishuman(src))
				set_typing_indicator(1)
			chatbar_typing = 1

		else if(length(temp) > 3 && findtext(temp, "Me ", 1, 5))
			if(!ishuman(src))
				set_typing_indicator(1)
			chatbar_typing = 1

		else
			if(!ishuman(src))
				set_typing_indicator(0)
			chatbar_typing = 0