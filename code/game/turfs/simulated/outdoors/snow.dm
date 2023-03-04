/turf/simulated/floor/outdoors/ice
	name = "ice"
	icon_state = "ice"
	desc = "Looks slippery."
	edge_blending_priority = 0

/turf/simulated/floor/outdoors/ice/dark
	name = "black ice"
	icon_state = "ice_dark"
	desc = "An uneven surface of dark rocks glazed over by solid ice. Looks slippey, maybe even painful"

/turf/simulated/floor/outdoors/ice/dark_smooth
	name = "smooth black ice"
	icon_state = "ice_dark_smooth"
	desc = "Dark rock that has been smoothened to be perfectly even. It's coated in a layer of slippey ice"

/turf/simulated/floor/outdoors/ice/Entered(var/mob/living/M)
	..()
	if(istype(M))
		M.SetStunned(1)
		addtimer(CALLBACK(src, .proc/slip_mob, M), 1 * world.tick_lag)

/turf/simulated/floor/outdoors/ice/proc/slip_mob(var/mob/living/M)
	if(istype(M, /mob/living) && M.loc == src)
		if(M.stunned == 0)
			to_chat(M, "<span class='warning'>You slide across the ice!</span>")
		step(M,M.dir)

// Ice that is used for, say, areas floating on water or similar.
/turf/simulated/floor/outdoors/shelfice
	name = "ice"
	icon_state = "ice"
	desc = "Looks slippery."
	movement_cost = 4
