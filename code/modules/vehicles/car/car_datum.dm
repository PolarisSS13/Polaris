// SUBTYPES

// I'm on a
/datum/riding/car
	nonhuman_key_exemption = TRUE // Borgs can't hold oars.
	only_one_driver = TRUE // Would be pretty crazy if five people try to move at the same time.
	vehicle_move_delay = 0.55

/datum/riding/car/police
	vehicle_move_delay = 0.65

/datum/riding/car/handle_ride(mob/user, direction)

	var/turf/next = get_step(ridden, direction)
	var/turf/current = get_turf(ridden)

	var/obj/vehicle/car/E = ridden
	if(!E.emagged)
		if(!(istype(next, /turf/simulated/floor/road) || istype(current, /turf/simulated/floor/road))) //We can move from land to water, or water to land, but not from land to land
			return FALSE

	var/mob/living/carbon/human/H = user
	var/obj/item/organ/external/hand/r_hand = H.get_organ(BP_R_HAND)
	var/obj/item/organ/external/hand/l_hand = H.get_organ(BP_L_HAND)

	if((!l_hand) && (!r_hand))
		user << "<span class='warning'>You can't drive like this!</span>"
		return FALSE

	if(user.stat || user.stunned || user.lying)
		return FALSE

// If all checks are passed. Move along!
	..()

/datum/riding/car // 'Small' boats can hold up to two people.

/datum/riding/car/get_offsets(pass_index) // list(dir = x, y, layer)
	switch(pass_index)
		if(1) // Person in front.
			return list(
				"[NORTH]" = list( 5, 25, MOB_LAYER),
				"[SOUTH]" = list( 21, 31,   ABOVE_MOB_LAYER),
				"[EAST]"  = list( 7, 21,   MOB_LAYER),
				"[WEST]"  = list(	15, 10,   MOB_LAYER + 0.4)
				)
		if(2) // Person in back.
			return list(
				"[NORTH]" = list( 24, 25,   ABOVE_MOB_LAYER),
				"[SOUTH]" = list( 5, 31, MOB_LAYER),
				"[EAST]"  = list( 7, 10,   MOB_LAYER + 0.4),
				"[WEST]"  = list( 15, 21,   MOB_LAYER)
				)
		else
			return null // This will runtime, but we want that since this is out of bounds.

/datum/riding/car/truck/get_offsets(pass_index) // list(dir = x, y, layer)
	switch(pass_index)
		if(1) // Person in front.
			return list(
				"[NORTH]" = list( 15, 25, MOB_LAYER),
				"[SOUTH]" = list( 21, 31,   ABOVE_MOB_LAYER),
				"[EAST]"  = list( 35, 21,   MOB_LAYER),
				"[WEST]"  = list(	15, 10,   MOB_LAYER + 0.4)
				)
		if(2) // Person in back.
			return list(
				"[NORTH]" = list( 24, 25,   ABOVE_MOB_LAYER),
				"[SOUTH]" = list( 21, 31, MOB_LAYER),
				"[EAST]"  = list(35, 10,   MOB_LAYER + 0.4),
				"[WEST]"  = list( 15, 21,   MOB_LAYER)
				)
		else
			return null // This will runtime, but we want that since this is out of bounds.
