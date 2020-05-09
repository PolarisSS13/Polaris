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


/obj/effect/temp_visual/pulse/passwall_indicator
	name = "teleport indicator"
	desc = "Something looks like it will teleport there shortly."
	icon_state = "teleport_indicator"
	plane = ABOVE_PLANE
	randomdir = FALSE
	duration = 10 SECONDS
	pulses_remaining = 20
	pulse_delay = 1 SECOND

/obj/effect/temp_visual/pulse/passwall_indicator/Initialize(mapload, new_dir, movement_delay)
	dir = new_dir
	pulse_delay = movement_delay
	return ..()

/obj/effect/temp_visual/pulse/passwall_indicator/on_pulse()
	var/turf/T = get_step(loc, dir)
	if(T)
		forceMove(T)
