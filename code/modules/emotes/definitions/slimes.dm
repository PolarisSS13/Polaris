/datum/emote/slime
	key = "nomood"
	var/mood

/datum/emote/slime/do_extra(var/mob/living/simple_mob/slime/user)
	. = ..()
	if(istype(user))
		user.mood = mood
		user.update_icon()

/datum/emote/slime/check_user(var/atom/user)
	return isslime(user)

/datum/emote/slime/pout
	key = "pout"
	mood = "pout"

/datum/emote/slime/sad
	key = "sad"
	mood = "sad"

/datum/emote/slime/angry
	key = "angry"
	mood = "angry"

/datum/emote/slime/frown
	key = "frown"
	mood = "mischevous"

/datum/emote/slime/smile
	key = "smile"
	mood = ":3"
