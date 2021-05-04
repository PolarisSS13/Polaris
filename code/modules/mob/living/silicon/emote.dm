var/list/_silicon_default_emotes = list(
	/datum/emote/audible/synth,
	/datum/emote/audible/synth/ping,
	/datum/emote/audible/synth/buzz,
	/datum/emote/audible/synth/confirm,
	/datum/emote/audible/synth/deny,
	/datum/emote/audible/synth/dwoop,
	/datum/emote/audible/synth/security,
	/datum/emote/audible/synth/security/halt
)

/mob/living/silicon/get_default_emotes()
	return global._silicon_default_emotes
