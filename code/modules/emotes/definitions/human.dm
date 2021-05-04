/datum/emote/human
	key = "vomit"

/datum/emote/human/check_user(var/mob/living/carbon/human/user)
	return (istype(user) && user.check_has_mouth() && !user.isSynthetic())

/datum/emote/human/do_emote(var/mob/living/carbon/human/user)
	user.vomit()

/datum/emote/human/deathgasp
	key = "deathgasp"

/datum/emote/human/deathgasp/do_emote(mob/living/carbon/human/user)
	if(istype(user) && user.species.get_death_message(user) == DEATHGASP_NO_MESSAGE)
		to_chat(user, SPAN_WARNING("Your species has no deathgasp."))
		return
	. = ..() 
	
/datum/emote/human/deathgasp/get_emote_message_3p(var/mob/living/carbon/human/user)
	return "USER [user.species.get_death_message(user)]"

/datum/emote/human/swish
	key = "swish"

/datum/emote/human/swish/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_once()

/datum/emote/human/wag
	key = "wag"

/datum/emote/human/wag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/datum/emote/human/sway
	key = "sway"

/datum/emote/human/sway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/datum/emote/human/qwag
	key = "qwag"

/datum/emote/human/qwag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/datum/emote/human/fastsway
	key = "fastsway"

/datum/emote/human/fastsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/datum/emote/human/swag
	key = "swag"

/datum/emote/human/swag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()

/datum/emote/human/stopsway
	key = "stopsway"

/datum/emote/human/stopsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()
