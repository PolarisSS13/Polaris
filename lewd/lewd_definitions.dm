/datum/interaction/lewd/kiss
	command = "deepkiss"
	description = "Kiss them deeply."
	require_user_mouth = 1
	write_log_user = "kissed"
	write_log_target = "was kissed by"
	interaction_sound = null
	max_distance = 1

/datum/interaction/lewd/kiss/post_interaction(var/mob/user, var/mob/target)
	. = ..()
	if(user.lust < 5)   user.lust = 5
	if(target.lust < 5) target.lust = 5

/datum/interaction/lewd/kiss/evaluate_user(var/mob/user, var/silent=1)
	if(..())
		//if(!user.has_lips())
		//	if(!silent) user << "<span class='warning'>You don't have any lips.</span>")
		//	return 0
		return 1
	return 0

/datum/interaction/lewd/kiss/display_interaction(var/mob/user, var/mob/target)
	if (user.lust >= 3)
		user.visible_message("<span class='warning'>\The [user] gives an intense, lingering kiss to \the [target].</span>")
	else
		user.visible_message("<span class='warning'>\The [user] kisses \the [target] deeply.</span>")

/datum/interaction/lewd/oral
	command = "suckvag"
	description = "Go down on them."
	require_user_mouth = 1
	require_target_vagina = 1
	write_log_user = "gave head to"
	write_log_target = "was given head by"
	interaction_sound = null
	user_not_tired = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "sucked"
	write_log_target = "was sucked by"

/datum/interaction/lewd/oral/display_interaction(var/mob/user, var/mob/target)
	user.do_oral(target)

/datum/interaction/lewd/oral/blowjob
	command = "suckcock"
	description = "Suck them off."
	require_target_vagina = 0
	require_target_penis = 1
	target_not_tired = 1
	write_log_user = "sucked"
	write_log_target = "was sucked by"

/datum/interaction/lewd/fuck
	command = "fuckvag"
	description = "Fuck their pussy."
	require_user_penis = 1
	require_target_vagina = 1
	write_log_user = "fucked"
	write_log_target = "was fucked by"
	interaction_sound = null
	user_not_tired = 1
	require_user_naked = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "fucked"
	write_log_target = "was fucked by"

/datum/interaction/lewd/fuck/display_interaction(var/mob/user, var/mob/target)
	user.do_vaginal(target)

/datum/interaction/lewd/fuck/anal
	command = "fuckass"
	description = "Fuck their ass."
	require_target_vagina = 0
	require_target_anus = 1
	user_not_tired = 1
	write_log_user = "ass-fucked"
	write_log_target = "was ass-fucked by"

/datum/interaction/lewd/fuck/anal/display_interaction(var/mob/user, var/mob/target)
	user.do_anal(target)

/datum/interaction/lewd/finger
	command = "finger"
	description = "Finger their pussy."
	require_user_hands = 1
	require_target_vagina = 1
	interaction_sound = null
	user_not_tired = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "fingered"
	write_log_target = "was fingered by"

/datum/interaction/lewd/finger/display_interaction(var/mob/user, var/mob/target)
	user.do_fingering(target)

/datum/interaction/lewd/fingerass
	command = "fingerm"
	description = "Finger their ass."
	interaction_sound = null
	require_user_hands = 1
	require_target_anus = 1
	user_not_tired = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "fingered"
	write_log_target = "was fingered by"

/datum/interaction/lewd/fingerass/display_interaction(var/mob/user, var/mob/target)
	user.do_fingerass(target)


/datum/interaction/lewd/facefuck
	command = "facefuck"
	description = "Fuck their mouth."
	interaction_sound = null
	require_target_mouth = 1
	user_not_tired = 1
	require_user_naked = 1
	max_distance = 0
	write_log_user = "face-fucked"
	write_log_target = "was face-fucked by"

/datum/interaction/lewd/facefuck/display_interaction(var/mob/user, var/mob/target)
	user.do_facefuck(target)

/datum/interaction/lewd/throatfuck
	command = "throatfuck"
	description = "Fuck their throat|Does oxy damage."
	interaction_sound = null
	require_user_penis = 1
	require_target_mouth = 1
	user_not_tired = 1
	require_user_naked = 1
	max_distance = 0
	write_log_user = "throat-fucked"
	write_log_target = "was throat-fucked by"

/datum/interaction/lewd/throatfuck/display_interaction(var/mob/user, var/mob/target)
	user.do_throatfuck(target)

/datum/interaction/lewd/handjob
	command = "handjob"
	description = "Jerk them off."
	interaction_sound = null
	require_user_hands = 1
	require_target_penis = 1
	target_not_tired = 1
	require_target_naked = 1
	max_distance = 1
	write_log_user = "jerked-off"
	write_log_target = "was jerked-off by"

/datum/interaction/lewd/handjob/display_interaction(var/mob/user, var/mob/target)
	user.do_handjob(target)

/datum/interaction/lewd/breastfuck
	command = "breastfuck"
	description = "Fuck their breasts."
	interaction_sound = null
	require_user_penis = 1
	user_not_tired = 1
	require_user_naked = 1
	require_target_naked = 1
	require_target_vagina = 1
	max_distance = 0
	write_log_user = "breast-fucked"
	write_log_target = "was breast-fucked by"

/datum/interaction/lewd/breastfuck/display_interaction(var/mob/user, var/mob/target)
	user.do_breastfuck(target)

/datum/interaction/lewd/mount
	command = "mount"
	description = "Mount with your pussy."
	interaction_sound = null
	require_user_vagina = 1
	require_target_penis = 1
	user_not_tired = 1
	target_not_tired = 1
	require_user_naked = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "rode"
	write_log_target = "was rode by"

/datum/interaction/lewd/mount/display_interaction(var/mob/user, var/mob/target)
	user.do_mount(target)

/datum/interaction/lewd/mountass
	command = "mountm"
	description = "Mount with your ass."
	interaction_sound = null
	require_user_vagina = 0
	require_user_anus = 1
	require_target_penis = 1
	user_not_tired = 1
	target_not_tired = 1
	require_user_naked = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "rode"
	write_log_target = "was rode by"

/datum/interaction/lewd/mountass/display_interaction(var/mob/user, var/mob/target)
	user.do_mountass(target)

/datum/interaction/lewd/rimjob
	command = "rimjob"
	description = "Lick their ass."
	interaction_sound = null
	require_user_mouth = 1
	require_target_anus = 1
	user_not_tired = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "rimmed"
	write_log_target = "was rimmed by"

/datum/interaction/lewd/rimjob/display_interaction(var/mob/user, var/mob/target)
	user.do_rimjob(target)

/datum/interaction/lewd/mountface
	command = "mountface"
	description = "Ass to face."
	interaction_sound = null
	require_target_mouth = 1
	require_user_anus = 1
	user_not_tired = 1
	require_user_naked = 1
	max_distance = 0
	write_log_user = "made-them-rim"
	write_log_target = "was made-to-rim by"

/datum/interaction/lewd/mountface/display_interaction(var/mob/user, var/mob/target)
	user.do_mountface(target)

/datum/interaction/lewd/lickfeet
	command = "lickfeet"
	description = "Lick their feet."
	interaction_sound = null
	require_user_mouth = 1
	max_distance = 1
	write_log_user = "licked-feet"
	write_log_target = "had their feet licked by"

/datum/interaction/lewd/lickfeet/display_interaction(var/mob/user, var/mob/target)
	user.do_lickfeet(target)

/datum/interaction/lewd/grindface
	command = "grindface"
	description = "Feet grind their face."
	interaction_sound = null
	require_target_mouth = 1
	max_distance = 0
	write_log_user = "feet-faced"
	write_log_target = "had feet grinded against their face by"

/datum/interaction/lewd/grindface/display_interaction(var/mob/user, var/mob/target)
	user.do_grindface(target)

/datum/interaction/lewd/grindmouth
	command = "grindmouth"
	description = "Feet grind their mouth."
	interaction_sound = null
	require_target_mouth = 1
	max_distance = 0
	write_log_user = "feet-mouthed"
	write_log_target = "had feet grinding against their tongue by"

/datum/interaction/lewd/grindmouth/display_interaction(var/mob/user, var/mob/target)
	user.do_grindmouth(target)

/datum/interaction/lewd/nuts
	command = "nuts"
	description = "Nuts to face."
	interaction_sound = null
	require_user_naked = 1
	require_user_penis = 1
	require_target_mouth = 1
	max_distance = 0
	write_log_user = "make-them-suck-their-nuts"
	write_log_target = "was made to suck nuts by"

/datum/interaction/lewd/nuts/display_interaction(var/mob/user, var/mob/target)
	user.do_nuts(target)

/datum/interaction/lewd/thighs
	command = "thighs"
	description = "Smother them."
	interaction_sound = null
	max_distance = 0
	require_user_naked = 1
	require_target_mouth = 1
	write_log_user = "thigh-trapped"
	write_log_target = "was smothered by"

/datum/interaction/lewd/thighs/display_interaction(var/mob/user, var/mob/target)
	user.do_thighs(target)