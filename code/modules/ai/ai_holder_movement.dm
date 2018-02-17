/datum/ai_holder
	var/use_astar = FALSE				// Do we use the more expensive A* implementation or stick with BYOND's default step_to()?
	var/using_astar = FALSE				// Are we currently using an A* path?
	var/list/path = list()				// A list of tiles that A* gave us as a solution to reach the target.
	var/list/obstacles = list()			// Things A* will try to avoid.
	var/astar_adjacent_proc = /turf/proc/CardinalTurfsWithAccess // Proc to use when A* pathfinding.  Default makes them bound to cardinals.
	var/failed_steps = 0				// If move_once() fails to move the mob onto the correct tile, this increases. When it reaches 3, the path is recalc'd since they're probably stuck.

	var/turf/home_turf = null			// The mob's 'home' turf. It will try to stay near it if told to do so.
	var/return_home = FALSE				// If true, makes the mob go to its 'home' if it strays too far.

/**************
* Strategical *
**************/

//Giving up on moving
/datum/ai_holder/proc/give_up_movement()
//	ai_log("GiveUpMoving()",1)
	forget_path()
//	stop_automated_movement = 0

//Forget the path entirely
/datum/ai_holder/proc/forget_path()
//	ai_log("ForgetPath()",2)
	if(path_display)
		for(var/turf/T in path)
			T.overlays -= path_overlay
	using_astar = FALSE
//	walk_list.Cut()
	path.Cut()

/datum/ai_holder/proc/calculate_path(atom/A, get_to = 1)
	if(!A)
		return

	if(!use_astar) // If we don't use A* then this is pointless.
		return

	get_path(get_turf(A), get_to)

//A* now, try to a path to a target
/datum/ai_holder/proc/get_path(var/turf/target,var/get_to = 1, var/max_distance = world.view*6)
//	ai_log("GetPath([target],[get_to],[max_distance])",2)
	forget_path()
	var/list/new_path = AStar(get_turf(holder.loc), target, astar_adjacent_proc, /turf/proc/Distance, min_target_dist = get_to, max_node_depth = max_distance, id = holder.IGetID(), exclude = obstacles)

	if(new_path && new_path.len)
		path = new_path
		if(path_display)
			for(var/turf/T in path)
				T.overlays |= path_overlay
	else
		return 0

	return path.len

/*
/datum/ai_holder/proc/walk_to_target()
	//If we were chasing someone and we can't anymore, give up.
	if(!target_mob)
	//	ai_log("MoveToTarget() Losing target at top",2)
		lose_target()
		return

	//We recompute our path every time we're called if we can still see them
	if(target in list_targets(vision_range))

		if(using_astar)
			forget_path()

		// Find out where we're going.
		var/get_to = 1 // TODO
		var/distance = get_dist(holder, target)

		//We're here!
		if(distance <= get_to)
		//	ai_log("MoveToTarget() [src] attack range",2)
			set_stance(STANCE_ATTACKING)
			return

		//We're just setting out, making a new path, or we can't path with A*
		if(!path.len)
		//	ai_log("SA: MoveToTarget() pathing to [target_mob]",2)

			//GetPath failed for whatever reason, just smash into things towards them
			if(run_at_them || !GetPath(get_turf(target_mob),get_to))

				//We try the built-in way to stay close
				walk_to(src, target_mob, get_to, move_to_delay)
		//		ai_log("MoveToTarget() walk_to([src],[target_mob],[get_to],[move_to_delay])",3)

				//Break shit in their direction! LEME SMAHSH
				var/dir_to_mob = get_dir(src,target_mob)
				face_atom(target_mob)
		//		DestroySurroundings(dir_to_mob)
		//		ai_log("MoveToTarget() DestroySurroundings([get_dir(src,target_mob)])",3)
*/

/***********
* Tactical *
***********/

// Goes to the target, to attack them.
// Called when in STANCE_ATTACK.
/datum/ai_holder/proc/walk_to_target()
	// Make sure we can still chase/attack them.
	if(!target || !can_attack(target))
		lose_target()
		return

	// Find out where we're going.
	var/get_to = closest_distance()
	var/distance = get_dist(holder, target)

	// We're here!
	if(distance <= get_to)
	//	ai_log("MoveToTarget() [src] attack range",2)
		forget_path()
		set_stance(STANCE_ATTACKING)
		return

	// Otherwise keep walking.
	walk_path(target, get_to)

// Walk towards whatever.
/datum/ai_holder/proc/walk_path(atom/A, get_to = 1)
	if(use_astar)
		if(!path.len) // If we're missing a path, make a new one.
			calculate_path(A, get_to)

		if(!path.len) // If we still don't have one, then the target's probably somewhere inaccessible to us.
			return

		if(!move_once()) // Start walking the path.
			++failed_steps
			if(failed_steps > 3) // We're probably stuck.
				forget_path() // So lets try again with a new path.
				failed_steps = 0

	else
		step_to(holder, A)

//Take one step along a path
/datum/ai_holder/proc/move_once()
	if(!path.len)
		return

	if(path_display)
		var/turf/T = src.path[1]
		T.overlays -= path_overlay

	step_towards(holder, src.path[1])
	if(holder.loc != src.path[1])
//		ai_log("MoveOnce() step_towards returning 0",3)
		return FALSE
	else
		path -= src.path[1]
//		ai_log("MoveOnce() step_towards returning 1",3)
		return TRUE