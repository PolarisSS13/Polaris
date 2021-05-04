var/list/_default_mob_emotes = list(
	/datum/emote/visible,
	/datum/emote/visible/scratch,
	/datum/emote/visible/drool,
	/datum/emote/visible/nod,
	/datum/emote/visible/sway,
	/datum/emote/visible/sulk,
	/datum/emote/visible/twitch,
	/datum/emote/visible/twitch_v,
	/datum/emote/visible/dance,
	/datum/emote/visible/roll,
	/datum/emote/visible/shake,
	/datum/emote/visible/jump,
	/datum/emote/visible/shiver,
	/datum/emote/visible/collapse,
	/datum/emote/visible/spin,
	/datum/emote/visible/sidestep,
	/datum/emote/audible,
	/datum/emote/audible/hiss,
	/datum/emote/audible/whimper,
	/datum/emote/audible/gasp,
	/datum/emote/audible/scretch,
	/datum/emote/audible/choke,
	/datum/emote/audible/moan,
	/datum/emote/audible/gnarl,
)

/mob
	var/list/usable_emotes

/mob/proc/update_emotes(var/skip_sort)
	usable_emotes = list()
	for(var/emote in get_default_emotes())
		var/datum/emote/emote_datum = GLOB.emotes_by_type[emote]
		if(emote_datum.check_user(src))
			usable_emotes[emote_datum.key] = emote_datum
	if(!skip_sort)
		usable_emotes = sortAssoc(usable_emotes)

/mob/proc/get_default_emotes()
	return global._default_mob_emotes
