/datum/emote/visible/spin
	key = "spin"
	check_restraints = TRUE
	emote_message_3p = "spins!"

/datum/emote/visible/spin/do_extra(mob/user)
	if(istype(user))
		user.spin(20, 1)

/datum/emote/visible/sidestep
	key = "sidestep"
	check_restraints = TRUE
	emote_message_3p = "steps rhythmically and moves side to side."

/datum/emote/visible/sidestep/do_extra(mob/user)
	if(istype(user))
		animate(user, pixel_x = 5, time = 5)
		sleep(3)
		animate(user, pixel_x = -5, time = 5)
		animate(pixel_x = user.default_pixel_x, pixel_y = user.default_pixel_x, time = 2)

/datum/emote/visible/flip
	key = "flip"
	emote_message_1p = "You do a flip!"
	emote_message_3p = "does a flip!"
	emote_sound = 'sound/effects/bodyfall4.ogg'

/datum/emote/visible/flip/do_extra(mob/user)
	. = ..()
	if(istype(user))
		user.SpinAnimation(7,1)

/datum/emote/visible/floorspin
	key = "floorspin"
	emote_message_1p = "You spin around on the floor!"
	emote_message_3p = "spins around on the floor!"
	var/static/list/spin_dirs = list(
		NORTH,
		SOUTH,
		EAST,
		WEST,
		EAST,
		SOUTH,
		NORTH,
		SOUTH,
		EAST,
		WEST,
		EAST,
		SOUTH,
		NORTH,
		SOUTH,
		EAST,
		WEST,
		EAST,
		SOUTH
	)

/datum/emote/visible/floorspin/proc/spin_dir(var/mob/user)
	set waitfor = FALSE
	for(var/i in spin_dirs)
		user.set_dir(i)
		sleep(1)
		if(QDELETED(user))
			return

/datum/emote/visible/floorspin/proc/spin_anim(var/mob/user)
	set waitfor = FALSE
	sleep(1)
	if(!QDELETED(user))
		user.SpinAnimation(10,1)

/datum/emote/visible/floorspin/do_extra(mob/user)
	. = ..()
	if(istype(user))
		spin_dir(user)
		spin_anim(user)
