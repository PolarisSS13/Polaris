/datum/emote/visible
	key ="tail"
	emote_message_3p = "waves USER_THEIR tail."
	message_type = VISIBLE_MESSAGE

/datum/emote/visible/scratch
	key = "scratch"
	check_restraints = TRUE
	emote_message_3p = "scratches."

/datum/emote/visible/drool
	key ="drool"
	emote_message_3p = "drools."
	conscious = FALSE

/datum/emote/visible/nod
	key ="nod"
	emote_message_3p_target = "nods USER_THEIR head at TARGET."
	emote_message_3p = "nods USER_THEIR head."

/datum/emote/visible/sway
	key ="sway"
	emote_message_3p = "sways around dizzily."

/datum/emote/visible/sulk
	key ="sulk"
	emote_message_3p = "sulks down sadly."

/datum/emote/visible/dance
	key ="dance"
	check_restraints = TRUE
	emote_message_3p = "dances around happily."

/datum/emote/visible/roll
	key ="roll"
	check_restraints = TRUE
	emote_message_3p = "rolls."

/datum/emote/visible/shake
	key ="shake"
	emote_message_3p = "shakes USER_THEIR head."

/datum/emote/visible/jump
	key ="jump"
	emote_message_3p = "jumps!"

/datum/emote/visible/shiver
	key ="shiver"
	emote_message_3p = "shivers."
	conscious = FALSE

/datum/emote/visible/collapse
	key ="collapse"
	emote_message_3p = "collapses!"

/datum/emote/visible/collapse/do_extra(var/mob/user)
	..()
	if(istype(user))
		user.Paralyse(2)

/datum/emote/visible/flash
	key = "flash"
	emote_message_3p = "flash USER_THEIR lights quickly."

/datum/emote/visible/blink
	key = "blink"
	emote_message_3p = "blinks."

/datum/emote/visible/airguitar
	key = "airguitar"
	check_restraints = TRUE
	emote_message_3p = "is strumming the air and headbanging like a safari chimp."

/datum/emote/visible/blink_r
	key = "blink_r"
	emote_message_3p = "blinks rapidly."

/datum/emote/visible/bow
	key = "bow"
	emote_message_3p_target = "bows to TARGET."
	emote_message_3p = "bows."

/datum/emote/visible/salute
	key = "salute"
	emote_message_3p_target = "salutes TARGET."
	emote_message_3p = "salutes."
	check_restraints = TRUE

/datum/emote/visible/flap
	key = "flap"
	check_restraints = TRUE
	emote_message_3p = "flaps USER_THEIR wings."

/datum/emote/visible/aflap
	key = "aflap"
	check_restraints = TRUE
	emote_message_3p = "flaps USER_THEIR wings ANGRILY!"

/datum/emote/visible/eyebrow
	key = "eyebrow"
	emote_message_3p = "raises an eyebrow."

/datum/emote/visible/twitch
	key = "twitch"
	emote_message_3p = "twitches."
	conscious = FALSE

/datum/emote/visible/twitch_v
	key = "twitch_v"
	emote_message_3p = "twitches violently."
	conscious = FALSE

/datum/emote/visible/faint
	key = "faint"
	emote_message_3p = "faints."

/datum/emote/visible/faint/do_extra(var/mob/user)
	. = ..()
	if(istype(user) && !user.sleeping)
		user.Sleeping(10)

/datum/emote/visible/frown
	key = "frown"
	emote_message_3p = "frowns."

/datum/emote/visible/blush
	key = "blush"
	emote_message_3p = "blushes."

/datum/emote/visible/wave
	key = "wave"
	emote_message_3p_target = "waves at TARGET."
	emote_message_3p = "waves."
	check_restraints = TRUE

/datum/emote/visible/glare
	key = "glare"
	emote_message_3p_target = "glares at TARGET."
	emote_message_3p = "glares."

/datum/emote/visible/stare
	key = "stare"
	emote_message_3p_target = "stares at TARGET."
	emote_message_3p = "stares."

/datum/emote/visible/look
	key = "look"
	emote_message_3p_target = "looks at TARGET."
	emote_message_3p = "looks."

/datum/emote/visible/point
	key = "point"
	check_restraints = TRUE
	emote_message_3p_target = "points to TARGET."
	emote_message_3p = "points."

/datum/emote/visible/raise
	key = "raise"
	check_restraints = TRUE
	emote_message_3p = "raises a hand."

/datum/emote/visible/grin
	key = "grin"
	emote_message_3p_target = "grins at TARGET."
	emote_message_3p = "grins."

/datum/emote/visible/shrug
	key = "shrug"
	emote_message_3p = "shrugs."

/datum/emote/visible/smile
	key = "smile"
	emote_message_3p_target = "smiles at TARGET."
	emote_message_3p = "smiles."

/datum/emote/visible/pale
	key = "pale"
	emote_message_3p = "goes pale for a second."

/datum/emote/visible/tremble
	key = "tremble"
	emote_message_3p = "trembles in fear!"

/datum/emote/visible/wink
	key = "wink"
	emote_message_3p_target = "winks at TARGET."
	emote_message_3p = "winks."

/datum/emote/visible/hug
	key = "hug"
	check_restraints = TRUE
	emote_message_3p_target = "hugs TARGET."
	emote_message_3p = "hugs USER_SELF."
	check_range = 1

/datum/emote/visible/dap
	key = "dap"
	check_restraints = TRUE
	emote_message_3p_target = "gives daps to TARGET."
	emote_message_3p = "sadly can't find anybody to give daps to, and daps USER_SELF."

/datum/emote/visible/bounce
	key = "bounce"
	emote_message_3p = "bounces in place."

/datum/emote/visible/jiggle
	key = "jiggle"
	emote_message_3p = "jiggles!"

/datum/emote/visible/lightup
	key = "light"
	emote_message_3p = "lights up for a bit, then stops."

/datum/emote/visible/vibrate
	key = "vibrate"
	emote_message_3p = "vibrates!"

/datum/emote/visible/deathgasp_robot
	key = "deathgasp"
	emote_message_3p = "shudders violently for a moment, then becomes motionless, USER_THEIR eyes slowly darkening."

/datum/emote/visible/handshake
	key = "handshake"
	check_restraints = TRUE
	emote_message_3p_target = "shakes hands with TARGET."
	emote_message_3p = "shakes hands with USER_SELF."
	check_range = 1

/datum/emote/visible/handshake/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(target && !user.Adjacent(target))
		return "holds out USER_THEIR hand out to TARGET."
	return ..()

/datum/emote/visible/signal
	key = "signal"
	emote_message_3p_target = "signals at TARGET."
	emote_message_3p = "signals."
	check_restraints = TRUE

/datum/emote/visible/signal/check_user(atom/user)
	return ismob(user)

/datum/emote/visible/signal/get_emote_message_3p(var/mob/living/user, var/atom/target, var/extra_params)
	if(istype(user) && (!user.get_active_hand() || !user.get_inactive_hand()))
		var/t1 = round(text2num(extra_params))
		if(isnum(t1) && t1 <= 5)
			return "raises [t1] finger\s."
	return .. ()

/datum/emote/visible/afold
	key = "afold"
	check_restraints = TRUE
	emote_message_3p = "folds USER_THEIR arms."

/datum/emote/visible/alook
	key = "alook"
	emote_message_3p = "looks away."

/datum/emote/visible/hbow
	key = "hbow"
	emote_message_3p = "bows USER_THEIR head."

/datum/emote/visible/hip
	key = "hip"
	check_restraints = TRUE
	emote_message_3p = "puts USER_THEIR hands on USER_THEIR hips."

/datum/emote/visible/holdup
	key = "holdup"
	check_restraints = TRUE
	emote_message_3p = "holds up USER_THEIR palms."

/datum/emote/visible/hshrug
	key = "hshrug"
	emote_message_3p = "gives a half shrug."

/datum/emote/visible/crub
	key = "crub"
	check_restraints = TRUE
	emote_message_3p = "rubs USER_THEIR chin."

/datum/emote/visible/eroll
	key = "eroll"
	emote_message_3p = "rolls USER_THEIR eyes."
	emote_message_3p_target = "rolls USER_THEIR eyes at TARGET."

/datum/emote/visible/erub
	key = "erub"
	check_restraints = TRUE
	emote_message_3p = "rubs USER_THEIR eyes."

/datum/emote/visible/fslap
	key = "fslap"
	check_restraints = TRUE
	emote_message_3p = "slaps USER_THEIR forehead."

/datum/emote/visible/ftap
	key = "ftap"
	emote_message_3p = "taps USER_THEIR foot."

/datum/emote/visible/hrub
	key = "hrub"
	check_restraints = TRUE
	emote_message_3p = "rubs USER_THEIR hands together."

/datum/emote/visible/hspread
	key = "hspread"
	check_restraints = TRUE
	emote_message_3p = "spreads USER_THEIR hands."

/datum/emote/visible/pocket
	key = "pocket"
	check_restraints = TRUE
	emote_message_3p = "shoves USER_THEIR hands in USER_THEIR pockets."

/datum/emote/visible/rsalute
	key = "rsalute"
	check_restraints = TRUE
	emote_message_3p = "returns the salute."

/datum/emote/visible/rshoulder
	key = "rshoulder"
	emote_message_3p = "rolls USER_THEIR shoulders."

/datum/emote/visible/squint
	key = "squint"
	emote_message_3p = "squints."
	emote_message_3p_target = "squints at TARGET."

/datum/emote/visible/tfist
	key = "tfist"
	emote_message_3p = "tightens USER_THEIR hands into fists."

/datum/emote/visible/tilt
	key = "tilt"
	emote_message_3p = "tilts USER_THEIR head."
