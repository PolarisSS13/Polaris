//temporary visual effects
/obj/effect/temp_visual
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = 0
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE
	var/timerid

/obj/effect/temp_visual/Initialize()
	. = ..()
	if(randomdir)
		dir = pick(list(NORTH, SOUTH, EAST, WEST))
	if(duration)
		timerid = QDEL_IN(src, duration)

/obj/effect/temp_visual/Destroy()
	. = ..()
	deltimer(timerid)

/obj/effect/temp_visual/singularity_act()
	return

/obj/effect/temp_visual/singularity_pull()
	return

/obj/effect/temp_visual/ex_act()
	return

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(loc, set_dir)
	if(set_dir)
		dir = set_dir
	. = ..()

// Does something every so often. Deletes itself when `pulses_remaining` hits zero.
/obj/effect/temp_visual/pulse
	duration = 0
	var/pulses_remaining = 3
	var/pulse_delay = 2 SECONDS

/obj/effect/temp_visual/pulse/Initialize()
	// Deliberately not using TIMER_LOOP due to it tending to result in immortal timer loops in regards to `deltimer()`.
	timerid = addtimer(CALLBACK(src, .proc/pulse), pulse_delay, TIMER_STOPPABLE)
	return ..()

/obj/effect/temp_visual/pulse/Destroy()
	if(timerid)
		deltimer(timerid)
	return ..()

/obj/effect/temp_visual/pulse/proc/pulse()
	if(timerid)
		deltimer(timerid)
		timerid = null
	if(pulses_remaining <= 0)
		qdel(src)
	else
		pulses_remaining--
		on_pulse()
		timerid = addtimer(CALLBACK(src, .proc/pulse), pulse_delay, TIMER_STOPPABLE)


// Override for specific effects.
/obj/effect/temp_visual/pulse/proc/on_pulse()