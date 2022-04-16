/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = FALSE // Handles a type of MMI damage
	var/alert = null
	use_me = FALSE // Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"

/mob/living/carbon/brain/Initialize()
	. = ..()
	default_language = GLOB.all_languages[LANGUAGE_GALCOM]

/mob/living/carbon/brain/Destroy()
	if(key)              //If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat != DEAD) //If not dead.
			death(1)     //Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()       //Ghostize checks for key so nothing else is necessary.
	return ..()

/mob/living/carbon/brain/say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
	return ishuman(other) || isslime(other) || (istype(container, /obj/item/device/mmi) && issilicon(other)) || ..()

/mob/living/carbon/brain/update_canmove()
	if(in_contents_of(/obj/mecha) || istype(container, /obj/item/device/mmi))
		canmove = TRUE
		use_me = TRUE
	else
		canmove = FALSE
	return canmove

/mob/living/carbon/brain/isSynthetic()
	return istype(container, /obj/item/device/mmi)

/mob/living/carbon/brain/set_typing_indicator(var/state)
	if(isturf(loc))
		return ..()

	if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
		loc.cut_overlay(typing_indicator, TRUE)
		return

	if(!typing_indicator)
		init_typing_indicator("[speech_bubble_appearance()]_typing")

	if(state && !typing)
		loc.add_overlay(typing_indicator, TRUE)
		typing = TRUE
	else if(typing)
		loc.cut_overlay(typing_indicator, TRUE)
		typing = FALSE

	return state
