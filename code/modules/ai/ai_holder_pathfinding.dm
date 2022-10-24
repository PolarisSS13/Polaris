// This handles obtaining a (usually A*) path towards something, such as a target, destination, or leader.
// This interacts heavily with code inside ai_holder_movement.dm

/datum/ai_holder
	// Pathfinding.
	var/use_astar = FALSE				// Do we use the more expensive A* implementation or stick with BYOND's default step_to()?
	var/list/path = list()				// A list of tiles that A* gave us as a solution to reach the target.
	var/list/obstacles = list()			// Things A* will try to avoid.
	var/astar_adjacent_proc = /turf/proc/CardinalTurfsWithAccess // Proc to use when A* pathfinding.  Default makes them bound to cardinals.
	var/failed_steps = 0				// If move_once() fails to move the mob onto the correct tile, this increases. When it reaches 3, the path is recalc'd since they're probably stuck.

// This clears the stored A* path.
/datum/ai_holder/proc/forget_path()
	ai_log("forget_path() : Entering.", AI_LOG_DEBUG)
	if(path_display)
		for(var/turf/T in path)
			T.cut_overlay(path_overlay)
	path.Cut()
	ai_log("forget_path() : Exiting.", AI_LOG_DEBUG)

/datum/ai_holder/proc/give_up_movement()
	ai_log("give_up_movement() : Entering.", AI_LOG_DEBUG)
	forget_path()
	destination = null
	ai_log("give_up_movement() : Exiting.", AI_LOG_DEBUG)

/datum/ai_holder/proc/calculate_path(atom/A, get_to = 1)
	ai_log("calculate_path([A],[get_to]) : Entering.", AI_LOG_DEBUG)
	if(!A)
		ai_log("calculate_path() : Called without an atom. Exiting.",AI_LOG_WARNING)
		return

	if(!use_astar) // If we don't use A* then this is pointless.
		ai_log("calculate_path() : Not using A*, Exiting.", AI_LOG_DEBUG)
		return

	get_path(get_turf(A), get_to)

	ai_log("calculate_path() : Exiting.", AI_LOG_DEBUG)

//A* now, try to a path to a target
/datum/ai_holder/proc/get_path(var/turf/target,var/get_to = 1, var/max_distance = world.view*6)
	ai_log("get_path() : Entering.",AI_LOG_DEBUG)
	forget_path()
	var/list/new_path = AStar(get_turf(holder.loc), target, astar_adjacent_proc, /turf/proc/Distance, min_target_dist = get_to, max_node_depth = max_distance, id = holder.IGetID(), exclude = obstacles)

	if(new_path && new_path.len)
		path = new_path
		ai_log("get_path() : Made new path.",AI_LOG_DEBUG)
		if(path_display)
			for(var/turf/T in path)
				T.add_overlay(path_overlay)
	else
		ai_log("get_path() : Failed to make new path. Exiting.",AI_LOG_DEBUG)
		return 0

	ai_log("get_path() : Exiting.", AI_LOG_DEBUG)
	return path.len




/******************************************************************/
// Navigation procs
// Used for A-star pathfinding


// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(var/obj/item/card/id/ID)
	var/L[] = new()

	//	for(var/turf/simulated/t in oview(src,1))

	for(var/d in cardinal)
		var/turf/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L


// Similar to above but not restricted to just cardinal directions.
/turf/proc/TurfsWithAccess(var/obj/item/card/id/ID)
	var/L[] = new()

	for(var/d in alldirs)
		var/turf/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L


// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/card/id/ID)

	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlockedWithAccess(A,iStep, ID) && !LinkBlockedWithAccess(iStep,B,ID))
			return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlockedWithAccess(A,pStep,ID) && !LinkBlockedWithAccess(pStep,B,ID))
			return 0
		return 1

	if(DirBlockedWithAccess(A,adir, ID))
		return 1

	if(DirBlockedWithAccess(B,rdir, ID))
		return 1

	for(var/obj/O in B)
		if(O.density && !istype(O, /obj/machinery/door) && !(O.atom_flags & ATOM_HAS_TRANSITION_PRIORITY))
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc,var/dir,var/obj/item/card/id/ID)
	for(var/obj/structure/window/D in loc)
		if(!D.density)			continue
		if(D.dir == SOUTHWEST)	return 1
		if(D.dir == dir)		return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue

		if(istype(D, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/A = D
			if(!A.can_open())	return 1

		if(istype(D, /obj/machinery/door/window))
			if( dir & D.dir )	return !D.check_access(ID)

			//if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return !D.check_access(ID)
			//if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return !D.check_access(ID)
		else return !D.check_access(ID)	// it's a real, air blocking door
	return 0
