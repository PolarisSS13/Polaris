var/list/_human_default_emotes = list(
	/datum/emote/visible/blink,
	/datum/emote/audible/synth,
	/datum/emote/audible/synth/ping,
	/datum/emote/audible/synth/buzz,
	/datum/emote/audible/synth/confirm,
	/datum/emote/audible/synth/deny,
	/datum/emote/visible/nod,
	/datum/emote/visible/shake,
	/datum/emote/visible/shiver,
	/datum/emote/visible/collapse,
	/datum/emote/audible/gasp,
	/datum/emote/audible/choke,
	/datum/emote/audible/sneeze,
	/datum/emote/audible/sniff,
	/datum/emote/audible/snore,
	/datum/emote/audible/whimper,
	/datum/emote/audible/whistle,
	/datum/emote/audible/whistle/quiet,
	/datum/emote/audible/whistle/wolf,
	/datum/emote/audible/whistle/summon,
	/datum/emote/audible/yawn,
	/datum/emote/audible/clap,
	/datum/emote/audible/chuckle,
	/datum/emote/audible/cough,
	/datum/emote/audible/cry,
	/datum/emote/audible/sigh,
	/datum/emote/audible/laugh,
	/datum/emote/audible/mumble,
	/datum/emote/audible/grumble,
	/datum/emote/audible/groan,
	/datum/emote/audible/moan,
	/datum/emote/audible/grunt,
	/datum/emote/audible/slap,
	/datum/emote/audible/crack,
	/datum/emote/human,
	/datum/emote/human/deathgasp,
	/datum/emote/audible/giggle,
	/datum/emote/audible/scream,
	/datum/emote/visible/airguitar,
	/datum/emote/visible/blink_r,
	/datum/emote/visible/bow,
	/datum/emote/visible/salute,
	/datum/emote/visible/flap,
	/datum/emote/visible/aflap,
	/datum/emote/visible/drool,
	/datum/emote/visible/eyebrow,
	/datum/emote/visible/twitch,
	/datum/emote/visible/dance,
	/datum/emote/visible/twitch_v,
	/datum/emote/visible/faint,
	/datum/emote/visible/frown,
	/datum/emote/visible/blush,
	/datum/emote/visible/wave,
	/datum/emote/visible/glare,
	/datum/emote/visible/stare,
	/datum/emote/visible/look,
	/datum/emote/visible/point,
	/datum/emote/visible/raise,
	/datum/emote/visible/grin,
	/datum/emote/visible/shrug,
	/datum/emote/visible/smile,
	/datum/emote/visible/pale,
	/datum/emote/visible/tremble,
	/datum/emote/visible/wink,
	/datum/emote/visible/hug,
	/datum/emote/visible/dap,
	/datum/emote/visible/signal,
	/datum/emote/visible/handshake,
	/datum/emote/visible/afold,
	/datum/emote/visible/alook,
	/datum/emote/visible/eroll,
	/datum/emote/visible/hbow,
	/datum/emote/visible/hip,
	/datum/emote/visible/holdup,
	/datum/emote/visible/hshrug,
	/datum/emote/visible/crub,
	/datum/emote/visible/erub,
	/datum/emote/visible/fslap,
	/datum/emote/visible/ftap,
	/datum/emote/visible/hrub,
	/datum/emote/visible/hspread,
	/datum/emote/visible/pocket,
	/datum/emote/visible/rsalute,
	/datum/emote/visible/rshoulder,
	/datum/emote/visible/squint,
	/datum/emote/visible/tfist,
	/datum/emote/visible/tilt,
	/datum/emote/visible/spin,
	/datum/emote/visible/sidestep,
	/datum/emote/audible/snap,
	/datum/emote/visible/vomit,
	/datum/emote/visible/floorspin,
	/datum/emote/visible/flip
)

/mob/living/carbon/human/get_default_emotes()
	return global._human_default_emotes

/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	var/datum/gender/T = gender_datums[get_visible_gender()]

	pose =  sanitize(input(usr, "This is [src]. [T.he]...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	src << browse(HTML, "window=flavor_changes;size=430x300")

/mob/living/carbon/human/proc/toggle_tail(var/setting,var/message = 0)
	if(!tail_style || !tail_style.ani_state)
		if(message)
			to_chat(src, "<span class='warning'>You don't have a tail that supports this.</span>")
		return 0

	var/new_wagging = isnull(setting) ? !wagging : setting
	if(new_wagging != wagging)
		wagging = new_wagging
		update_tail_showing()
	return 1

/mob/living/carbon/human/proc/toggle_wing(var/setting,var/message = 0)
	if(!wing_style || !wing_style.ani_state)
		if(message)
			to_chat(src, "<span class='warning'>You don't have a wingtype that supports this.</span>")
		return 0

	var/new_flapping = isnull(setting) ? !flapping : setting
	if(new_flapping != flapping)
		flapping = setting
		update_wing_showing()
	return 1
