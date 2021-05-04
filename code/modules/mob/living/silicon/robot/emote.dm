var/list/_robot_default_emotes = list(
	/datum/emote/audible/clap,
	/datum/emote/visible/bow,
	/datum/emote/visible/salute,
	/datum/emote/visible/flap,
	/datum/emote/visible/aflap,
	/datum/emote/visible/twitch,
	/datum/emote/visible/twitch_v,
	/datum/emote/visible/dance,
	/datum/emote/visible/nod,
	/datum/emote/visible/shake,
	/datum/emote/visible/glare,
	/datum/emote/visible/look,
	/datum/emote/visible/stare,
	/datum/emote/visible/deathgasp_robot,
	/datum/emote/visible/spin,
	/datum/emote/visible/sidestep,
	/datum/emote/audible/synth,
	/datum/emote/audible/synth/ping,
	/datum/emote/audible/synth/buzz,
	/datum/emote/audible/synth/confirm,
	/datum/emote/audible/synth/deny,
	/datum/emote/audible/synth/dwoop,
	/datum/emote/audible/synth/security,
	/datum/emote/audible/synth/security/halt
)

/mob/living/silicon/robot/get_default_emotes()
	return global._robot_default_emotes
