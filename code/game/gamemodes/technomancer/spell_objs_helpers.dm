//Returns 1 if the turf is dense, or if there's dense objects/mobs on it, unless told to ignore them.
/turf/proc/check_density(var/ignore_objs = FALSE, var/ignore_mobs = FALSE)
	if(density)
		return TRUE
	if(!ignore_objs || !ignore_mobs)
		for(var/atom/movable/stuff in contents)
			if(stuff.density)
				if(ignore_objs && isobj(stuff))
					continue
				else if(ignore_mobs && isliving(stuff)) // Ghosts aren't dense but keeping this limited to living type will probably save headaches in the future.
					continue
				else
					return TRUE
	return FALSE

// Used to distinguish friend from foe.
/obj/item/weapon/spell/technomancer/proc/is_ally(var/mob/living/L)
	if(L == owner) // The best ally is ourselves.
		return TRUE
	if(L.mind && technomancers.is_antagonist(L.mind)) // This should be done better since we might want opposing technomancers later.
		return TRUE
	if(istype(L, /mob/living/simple_mob)) // Mind controlled simple mobs count as allies too.
		var/mob/living/simple_mob/SM = L
		if(SM.IIsAlly(owner))
			return TRUE
	return FALSE

/proc/is_technomancer_ally(mob/living/L)
	if(L.mind && technomancers.is_antagonist(L.mind)) // This should be done better someday since we might want opposing technomancers in the future.
		return TRUE
	if(istype(L, /mob/living/simple_mob)) // Mind controlled simple mobs count as allies too.
		var/mob/living/simple_mob/SM = L
		for(var/datum/mind/technomancer_mind in technomancers.current_antagonists)
			if(SM.IIsAlly(technomancer_mind.current))
				return TRUE
	return FALSE

/obj/item/weapon/spell/proc/allowed_to_teleport()
	if(owner)
		if(owner.z in using_map.admin_levels)
			return FALSE

		var/turf/T = get_turf(owner)
		if(T.block_tele)
			return FALSE
	return TRUE

/obj/item/weapon/spell/proc/within_range(var/atom/target, var/max_range = 7) // Beyond 7 is off the screen.
	if(target in view(max_range, owner))
		return TRUE
	return FALSE

/obj/item/weapon/spell/technomancer/proc/potential_targets(turf/T, radius = 5, allow_ally_target = FALSE)
	. = list()
	var/list/things = view(T, radius)
	for(var/mob/living/L in things)
		if(L == owner) // Don't target ourselves.
			continue
		if(!allow_ally_target && is_technomancer_ally(L)) // Don't shoot our friends.
			continue
		if(L.invisibility > owner.see_invisible) // Don't target ourselves or people we can't see.
			continue
		if(!L in viewers(owner)) // So we don't shoot at walls if someone is hiding behind one.
			continue
		if(!L.stat) // Don't want to target dead people or SSDs.
			. += L

// Returns a 'target' mob from a radius around T.
/obj/item/weapon/spell/technomancer/proc/targeting_assist(turf/T, radius = 5, allow_ally_target = FALSE)
	var/list/valid_targets = potential_targets(T, radius, allow_ally_target)
	var/closest_distance = INFINITY

	// Prioritize the closest valid target to where the user presumably clicked.
	for(var/thing in valid_targets)
		var/mob/living/L = thing
		var/dist = get_dist(T, L)
		if(dist < closest_distance)
			closest_distance = dist
			. = L