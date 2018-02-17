// This is a datum-based artificial intelligence for simple mobs (and possibly others) to use.
// The neat thing with having this here instead of on the mob is that it is independant of Life(), and that different mobs
// can use a more or less complex AI by giving it a different datum.

/mob/living
	var/datum/ai_holder/ai_holder = null
	var/ai_holder_type = null // Which ai_holder datum to give to the mob when initialized. If null, nothing happens.

/mob/living/initialize()
	if(ai_holder_type)
		ai_holder = new ai_holder_type(src)
	return ..()

/mob/living/Destroy()
	qdel_null(ai_holder)
	return ..()

/datum/ai_holder
	var/mob/living/holder = null		// The mob this datum is going to control.
	var/stance = STANCE_IDLE			// Determines if the mob should be doing a specific thing, e.g. attacking, following, standing around, etc.
	var/intelligence_level = AI_NORMAL



/datum/ai_holder/hostile
	hostile = TRUE

/datum/ai_holder/retaliate
	hostile = TRUE
	retaliate = TRUE

/datum/ai_holder/test
	hostile = TRUE
	use_astar = TRUE

/datum/ai_holder/New(var/new_holder)
	ASSERT(new_holder)
	holder = new_holder
	SSai.processing += src
	home_turf = get_turf(holder)
	..()

/datum/ai_holder/Destroy()
	holder = null
	SSai.processing -= src // We might've already been asleep and removed, but byond won't care if we do this again and it saves a conditional.
	home_turf = null
	return ..()


// Now for the actual AI stuff.

/datum/ai_holder/proc/go_sleep()
	if(stance == STANCE_SLEEP)
		return
	stance = STANCE_SLEEP
	SSai.processing -= src

/datum/ai_holder/proc/go_wake()
	if(stance != STANCE_SLEEP)
		return
	stance = STANCE_IDLE
	SSai.processing += src


// 'Tactical' processes such as moving a step, meleeing an enemy, firing a projectile, and other fairly cheap actions that need to happen quickly.
/datum/ai_holder/proc/handle_tactics()
	handle_stance_tactical()

// 'Strategical' processes that are more expensive on the CPU and so don't get run as often as the above proc, such as A* pathfinding or robust targeting.
/datum/ai_holder/proc/handle_strategicals()
	world << "[holder.name] Strategicals!"
	handle_stance_strategical()

/*
	//AI Actions
	if(!ai_inactive)
		//Stanceyness
		handle_stance()

		//Movement
		if(!stop_automated_movement && wander && !anchored) //Allowed to move?
			handle_wander_movement()

		//Speaking
		if(speak_chance && stance == STANCE_IDLE) // Allowed to chatter?
			handle_idle_speaking()

		//Resisting out buckles
		if(stance != STANCE_IDLE && incapacitated(INCAPACITATION_BUCKLED_PARTIALLY))
			handle_resist()

		//Resisting out of closets
		if(istype(loc,/obj/structure/closet))
			var/obj/structure/closet/C = loc
			if(C.welded)
				resist()
			else
				C.open()
*/

// For setting the stance WITHOUT processing it
/datum/ai_holder/proc/set_stance(var/new_stance)
	stance = new_stance

/datum/ai_holder/proc/handle_stance_tactical(var/new_stance)
	if(new_stance)
		set_stance(new_stance)

	if(attack_cooldown_left > 0)
		attack_cooldown_left--

	switch(stance)
		if(STANCE_SLEEP)
			go_sleep()
			return
		if(STANCE_IDLE)
			holder.a_intent = I_HELP

		//	if(hostile)
		//		find_target()
		if(STANCE_ALERT)
			threaten_target()

		if(STANCE_ATTACK)
			if(target)
				walk_to_target()

		if(STANCE_ATTACKING)
			engage_target()

/datum/ai_holder/proc/handle_stance_strategical()
	switch(stance)
		if(STANCE_IDLE)
			if(hostile)
				find_target()
		if(STANCE_ATTACK)
			if(target)
				calculate_path(target)

/*
// For proccessing the current stance, or setting and processing a new one
/mob/living/simple_animal/proc/handle_stance(var/new_stance)
	if(ai_inactive)
		stance = STANCE_IDLE
		return

	if(new_stance)
		set_stance(new_stance)

	switch(stance)
		if(STANCE_IDLE)
			target_mob = null
			a_intent = I_HELP
			annoyed = max(0,annoyed--)

			//Yes I'm breaking this into two if()'s for ease of reading
			//If we ARE ALLOWED TO
			if(returns_home && home_turf && !astarpathing && (world.time - stance_changed) > 10 SECONDS)
				if(get_dist(src,home_turf) > wander_distance)
					move_to_delay = initial(move_to_delay)*2 //Walk back.
					GoHome()
				else
					stop_automated_movement = 0

			//Search for targets while idle
			if(hostile)
				FindTarget()
		if(STANCE_FOLLOW)
			annoyed = 15
			FollowTarget()
			if(follow_until_time && world.time > follow_until_time)
				LoseFollow()
				return
			if(hostile)
				FindTarget()
		if(STANCE_ATTACK)
			annoyed = 50
			a_intent = I_HURT
			RequestHelp()
			MoveToTarget()
		if(STANCE_ATTACKING)
			annoyed = 50
			AttackTarget()
*/


