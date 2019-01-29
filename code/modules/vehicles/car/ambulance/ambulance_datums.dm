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


