// Used for assigning a target for attacking.

/datum/ai_holder
	var/hostile = FALSE						// Do we try to hurt others? Setting to false disables most combat processing.
	var/retaliate = FALSE					// Attacks whatever struck it first.

	var/atom/movable/target = null			// The thing (mob or object) we're trying to kill.
	var/turf/target_last_seen_turf = null 	// Where the mob last observed the target being, used if the target disappears but the mob wants to keep fighting.

	var/vision_range = 7					// How far the targeting system will look for things to kill. Note that values higher than 7 are 'offscreen' and might be unsporting.

	var/lose_target_time = 0				// world.time when a target was lost.
	var/lose_target_timeout = 5 SECONDS		// How long until a mob 'times out' and stops trying to find the mob that disappeared.

// A lot of this is based off of /TG/'s AI code.

// Step 1, find out what we can see.
/datum/ai_holder/proc/list_targets()
	. = hearers(vision_range, holder) - src // Remove ourselves to prevent suicidal decisions.

	var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha))

	for(var/HM in typecache_filter_list(range(vision_range, holder), hostile_machines))
		if(can_see(holder, HM, vision_range))
			. += HM

// Step 2, filter down possible targets to things we actually care about.
/datum/ai_holder/proc/find_target(var/list/possible_targets, var/has_targets_list = FALSE)
	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	for(var/possible_target in possible_targets)
		var/atom/A = possible_target
		if(found(A)) // In case people want to override this.
			. = list(A)
			break
		if(can_attack(A)) // Can we attack it?
			. += A
			continue

	var/new_target = pick_target(.)
	give_target(new_target)
	return new_target

// Step 3, pick among the possible, attackable targets.
/datum/ai_holder/proc/pick_target(list/targets)
	if(target != null) // If we already have a target, but are told to pick again, calculate the lowest distance between all possible, and pick from the lowest distance targets.
		for(var/possible_target in targets)
			var/atom/A = possible_target
			var/target_dist = get_dist(holder, target)
			var/possible_target_distance = get_dist(holder, A)
			if(target_dist < possible_target_distance)
				targets -= A
	if(!targets.len) // We found nothing.
		return
	var/chosen_target = pick(targets)
	return chosen_target

// Step 4, give us our selected target.
/datum/ai_holder/proc/give_target(new_target)
	target = new_target
	if(target != null)
		if(should_threaten())
			set_stance(STANCE_ALERT)
		else
			set_stance(STANCE_APPROACH)
		return TRUE

/datum/ai_holder/proc/can_attack(atom/movable/the_target)
	if(!can_see_target(the_target))
		return FALSE

	if(isliving(the_target))
		var/mob/living/L = the_target
		if(L.stat)
			return FALSE
		if(holder.IIsAlly(L))
			return FALSE
		return TRUE

	if(istype(the_target, /obj/mecha))
		var/obj/mecha/M = the_target
		if(M.occupant)
			return can_attack(M.occupant)

	if(istype(the_target, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/P = the_target
		if(P.stat & BROKEN)
			return FALSE // Already dead.
		if(P.faction == holder.faction)
			return FALSE // Don't shoot allied turrets.
		if(!P.raised && !P.raising)
			return FALSE // Turrets won't get hurt if they're still in their cover.
		return TRUE

	return FALSE

// Override this for special targeting criteria.
// If it returns true, the mob will always select it as the target.
/datum/ai_holder/proc/found(atom/movable/the_target)
	return FALSE

//We can't see the target, go look or attack where they were last seen.
/datum/ai_holder/proc/lose_target()
	if(target)
		target = null
		lose_target_time = world.time

	give_up_movement()


//Target is no longer valid (?)
/datum/ai_holder/proc/lost_target()
	set_stance(STANCE_IDLE)
	lose_target_position()
	lose_target()

// Check if target is visible to us.
/datum/ai_holder/proc/can_see_target(atom/movable/the_target, view_range = vision_range)
	ai_log("can_see_target() : Entering.", AI_LOG_TRACE)

	if(!the_target) // Nothing to target.
		ai_log("can_see_target() : There is no target. Exiting.", AI_LOG_WARNING)
		return FALSE

	if(holder.see_invisible < the_target.invisibility) // Invisible, can't see it, oh well.
		ai_log("can_see_target() : Target ([the_target]) was invisible to holder. Exiting.", AI_LOG_TRACE)
		return FALSE

	if(get_dist(holder, the_target) > view_range) // Too far away.
		ai_log("can_see_target() : Target ([the_target]) was too far from holder. Exiting.", AI_LOG_TRACE)
		return FALSE

	if(!can_see(holder, the_target, view_range))
		ai_log("can_see_target() : Target ([the_target]) failed can_see(). Exiting.", AI_LOG_TRACE)
		return FALSE

	ai_log("can_see_target() : Target ([the_target]) can be seen. Exiting.", AI_LOG_TRACE)
	return TRUE

// Updates the last known position of the target.
/datum/ai_holder/proc/track_target_position()
	if(!target)
		lose_target_position()

	if(last_turf_display && target_last_seen_turf)
		target_last_seen_turf.overlays -= last_turf_overlay

	target_last_seen_turf = get_turf(target)

	if(last_turf_display)
		target_last_seen_turf.overlays += last_turf_overlay

// Resets the last known position to null.
/datum/ai_holder/proc/lose_target_position()
	if(last_turf_display && target_last_seen_turf)
		target_last_seen_turf.overlays -= last_turf_overlay
	ai_log("lose_target_position() : Last position is being reset.", AI_LOG_INFO)
	target_last_seen_turf = null