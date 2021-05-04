var/list/_brain_default_emotes = list(
	/datum/emote/audible/alarm,
	/datum/emote/audible/alert,
	/datum/emote/audible/notice,
	/datum/emote/audible/whistle,
	/datum/emote/audible/synth,
	/datum/emote/audible/beep,
	/datum/emote/audible/boop,
	/datum/emote/visible/blink,
	/datum/emote/visible/flash
)

/mob/living/carbon/brain/can_emote()
	return (istype(container, /obj/item/device/mmi) && ..())

/mob/living/carbon/brain/get_default_emotes()
	return global._brain_default_emotes
