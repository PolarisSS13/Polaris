var/list/_alien_default_emotes = list(
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
	/datum/emote/audible/hiss,
	/datum/emote/audible,
	/datum/emote/audible/deathgasp_alien,
	/datum/emote/audible/whimper,
	/datum/emote/audible/gasp,
	/datum/emote/audible/scretch,
	/datum/emote/audible/choke,
	/datum/emote/audible/moan,
	/datum/emote/audible/gnarl,
	/datum/emote/audible/chirp
)

/mob/living/carbon/alien/get_default_emotes()
	. = global._alien_default_emotes
