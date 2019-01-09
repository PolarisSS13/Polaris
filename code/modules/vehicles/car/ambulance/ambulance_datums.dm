// SUBTYPES

// I'm on a
/datum/riding/ambulance
	nonhuman_key_exemption = TRUE // Borgs can't hold oars.
	only_one_driver = TRUE // Would be pretty crazy if five people try to move at the same time.
	vehicle_move_delay = -5


/datum/riding/ambulance/handle_ride(mob/user, direction)

	var/turf/next = get_step(ridden, direction)
	var/turf/current = get_turf(ridden)

	if(istype(next, /turf/simulated/floor/road) || istype(current, /turf/simulated/floor/road)) //We can move from land to water, or water to land, but not from land to land
		..()
	else
		to_chat(user, "<span class='warning'>The ambulance safety controls keep you on the road!</span>")
		return FALSE

/datum/riding/ambulance // 'Small' boats can hold up to two people.

/datum/riding/ambulance/get_offsets(pass_index) // list(dir = x, y, layer)
	switch(pass_index)
		if(1) // Person in front.
			return list(
				"[NORTH]" = list( 0, 4, MOB_LAYER),
				"[SOUTH]" = list( 0, 7,   ABOVE_MOB_LAYER),
				"[EAST]"  = list( -13, 7,   MOB_LAYER),
				"[WEST]"  = list(	13, 7,   MOB_LAYER + 0.4)
				)
		else
			return null // This will runtime, but we want that since this is out of bounds.

