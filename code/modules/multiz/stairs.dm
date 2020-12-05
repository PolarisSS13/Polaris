#define STAIR_MOVE_DELAY 10 // Animation delay for non-living objects moving up/down stairs

/obj/structure/stairs
	name = "Stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon = 'icons/obj/structures/multiz.dmi'
	icon_state = "stair"
	opacity = 0
	density = 0
	anchored = 1
	layer = STAIRS_LAYER

/obj/structure/stairs/Initialize()
	if(check_integrity())
		update_icon()
	return INITIALIZE_HINT_NORMAL

// Returns TRUE if the stairs are a complete and connected unit, FALSE if a piece is missing or obstructed
// Will attempt to reconnect broken pieces
// Parameters: 
//  - B1: Loc of bottom stair
//  - B2: Loc of middle stair
//  - T1: Openspace over bottom stair
//  - T2: Loc of top stair, over middle stair
/obj/structure/stairs/proc/check_integrity(var/obj/structure/stairs/bottom/B = null, 
										   var/obj/structure/stairs/middle/M = null, 
										   var/obj/structure/stairs/top/T = null,
										   var/turf/simulated/open/O = null)

	// Base cases: Something is missing!
	// The parent type doesn't know enough about the positional relations to find neighbors, only evaluate if they're connected
	if(!istype(B) || !istype(M) || !istype(T) || !istype(O))
		return FALSE

	// Case 1: In working order
	if(B.top == T && M.bottom == B && T.bottom == B && \
			get_turf(M) == get_step(B, B.dir) && O == GetAbove(B) && get_turf(T) == GetAbove(M))
		return TRUE

	// Case 2: The top is linked to someone else
	if(istype(T.bottom) && T.bottom != B)
		return FALSE

	// Case 3: The bottom is linked to someone else
	if(istype(B.top) && B.top != T)
		return FALSE

	// Case 4: They're unlinked
	B.dir = get_dir(get_turf(B), get_turf(M))
	B.top = T
	B.middle = M
	T.dir	 = B.dir
	T.middle = M
	T.bottom = B
	M.dir	 = B.dir
	M.top	 = T
	M.bottom = B
	return TRUE



//////////////////////////////////////////////////////////////////////
// Bottom piece that you step ontor //////////////////////////////////
//////////////////////////////////////////////////////////////////////
/obj/structure/stairs/bottom
	icon_state = "0,0"
	var/obj/structure/stairs/top/top = null
	var/obj/structure/stairs/middle/middle = null

/obj/structure/stairs/bottom/Initialize()
	if(!GetAbove(src))
		warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL
	. = ..()

/obj/structure/stairs/bottom/Destroy()
	if(top)
		top.bottom = null
	if(middle)
		middle.bottom = null
	..()

// These are necessarily fairly similar, but because the positional relations are different, we have to copy-pasta a fair bit
/obj/structure/stairs/bottom/check_integrity(var/obj/structure/stairs/bottom/B = null,
											 var/obj/structure/stairs/middle/M = null,
											 var/obj/structure/stairs/top/T = null,
											 var/turf/simulated/open/O = null)
	
	// In the case where we're provided all the pieces, just try connecting them.
	// In order: all exist, they are appropriately adjacent, and they can connect
	if(istype(B) && istype(M) && istype(T) && istype(O) && \
			B.Adjacent(M) && (GetBelow(O) == get_turf(B)) && T.Adjacent(O) && \
			..())
		return TRUE
	
	// If we're already configured, just check those
	else if(istype(top) && istype(middle))
		O = locate(/turf/simulated/open) in GetAbove(src)
		if(..(src, middle, top, O))
			return TRUE

	var/turf/B2 = get_step(src, src.dir)
	O = GetAbove(src)
	var/turf/T2 = GetAbove(B2)

	// T1 is the same regardless of B1's dir, so we can enforce it here
	if(!istype(O))
		return FALSE

	T = locate(/obj/structure/stairs/top)    in T2
	M = locate(/obj/structure/stairs/middle) in B2

	// If you set the dir, that's the dir it *wants* to connect in. It only chooses the others if that doesn't work
	// Everything is simply linked in our original direction
	if(istype(M) && istype(T) && ..(src, M, T, O))	
		return TRUE

	// Else, we have to look in other directions
	for(var/dir in cardinal - src.dir)
		to_world("scanning [dir]")
		B2 = get_step(src, dir)
		T2 = GetAbove(B2)
		if(!istype(B2) || !istype(T2))
			continue
		
		T = locate(/obj/structure/stairs/top)    in T2
		M = locate(/obj/structure/stairs/middle) in B2
		to_world("found [T] and [M]")
		if(..(src, M, T, O))
			return TRUE
	
	// Out of the dir check, we have no valid neighbors, and thus are not complete.
	return FALSE

/obj/structure/stairs/bottom/Crossed(var/atom/movable/AM, var/atom/oldloc)
	
	// If we're coming from the top of the stairs, don't trap us in an infinite staircase
	// Or if we fell down the openspace
	if((top in oldloc) || oldloc == GetAbove(src))
		return
	
	if(isobserver(AM)) // Ghosts have their own methods for going up and down
		return
	
	if(AM.pulledby) // Animating the movement of pulled things is handled when the puller goes up the stairs
		return
	
	var/animation_delay = STAIR_MOVE_DELAY
	var/atom/movable/pulling = null
	if(isliving(AM))
		var/mob/living/L = AM
		animation_delay = L.movement_delay()
		if(L.pulling && !L.pulling.anchored)
			pulling = L.pulling
	
	// If the stairs aren't broken, go up.
	if(check_integrity())
		AM.dir = src.dir
		// Animate moving onto M
		switch(src.dir)
			if(NORTH)
				animate(AM, AM.pixel_y += 32, time = animation_delay)
			if(SOUTH)
				animate(AM, AM.pixel_y += -32, time = animation_delay)
			if(EAST)
				animate(AM, AM.pixel_x += 32, time = animation_delay)
			if(WEST)
				animate(AM, AM.pixel_x += -32, time = animation_delay)

		// Bring the pulled object along behind us
		if(pulling)
			switch(src.dir)
				if(NORTH)
					animate(pulling, pulling.pixel_y += 32, time = animation_delay)
				if(SOUTH)
					animate(pulling, pulling.pixel_y += -32, time = animation_delay)
				if(EAST)
					animate(pulling, pulling.pixel_x += 32, time = animation_delay)
				if(WEST)
					animate(pulling, pulling.pixel_x += -32, time = animation_delay)

		// Go up the stairs
		spawn(animation_delay)
			// Move to Top
			AM.forceMove(get_turf(top))

			// Animate moving from O to T
			switch(src.dir)
				if(NORTH)
					AM.pixel_y -= 64
					animate(AM, AM.pixel_y += 32, time = animation_delay)//, easing = SINE_EASING | EASE_OUT)
				if(SOUTH)
					AM.pixel_y -= -64
					animate(AM, AM.pixel_y += -32, time = animation_delay)//, easing = SINE_EASING | EASE_OUT)
				if(EAST)
					AM.pixel_x -= 64
					animate(AM, AM.pixel_x += 32, time = animation_delay)//, easing = SINE_EASING | EASE_OUT)
				if(WEST)
					AM.pixel_x -= -64
					animate(AM, AM.pixel_x += -32, time = animation_delay)//, easing = SINE_EASING | EASE_OUT)
		
		
			// If something is being pulled, bring it along directly to avoid the mob being torn away from it due to movement delays
			if(pulling)
				spawn(animation_delay)
					switch(src.dir)
						if(NORTH)
							pulling.pixel_y -= 32
						if(SOUTH)
							pulling.pixel_y -= -32
						if(EAST)
							pulling.pixel_x -= 32
						if(WEST)
							pulling.pixel_x -= -32
					pulling.forceMove(get_turf(top)) // Just bring it along directly, no fussing with animation timing
	return TRUE

//////////////////////////////////////////////////////////////////////
// Middle piece that you are animated onto/off of ////////////////////
//////////////////////////////////////////////////////////////////////
/obj/structure/stairs/middle
	icon_state = "0,1"
	opacity   = TRUE
	density   = TRUE // Too high to simply step up on
	climbable = TRUE // But they can be climbed if the bottom is out

	var/obj/structure/stairs/top/top = null
	var/obj/structure/stairs/bottom/bottom = null

/obj/structure/stairs/middle/Initialize()
	if(!GetAbove(src))
		warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL
	. = ..()

/obj/structure/stairs/middle/Destroy()
	if(top)
		top.middle = null
	if(bottom)
		bottom.middle = null
	..()

// These are necessarily fairly similar, but because the positional relations are different, we have to copy-pasta a fair bit
/obj/structure/stairs/middle/check_integrity(var/obj/structure/stairs/bottom/B = null,
											 var/obj/structure/stairs/middle/M = null, 
											 var/obj/structure/stairs/top/T = null,
											 var/turf/simulated/open/O = null)
	
	// In the  case where we're provided all the pieces, just try connecting them.
	// In order: all exist, they are appropriately adjacent, and they can connect
	if(istype(B) && istype(M) && istype(T) && istype(O) && \
			B.Adjacent(M) && (GetBelow(O) == B.loc) && T.Adjacent(O) && \
			..())
		return TRUE

	else if(istype(top) && istype(bottom))
		O = locate(/turf/simulated/open) in GetAbove(bottom)
		if(..(bottom, src, top, O))
			return TRUE

	var/turf/B1 = get_step(src, turn(src.dir, 180))
	O = GetAbove(B1)
	var/turf/T2 = GetAbove(src)

	B = locate(/obj/structure/stairs/bottom) in B1
	T = locate(/obj/structure/stairs/top)    in T2

	// Top is static for Middle stair, if it's invalid we can't do much
	if(!istype(T))
		return FALSE
	
	// If you set the dir, that's the dir it *wants* to connect in. It only chooses the others if that doesn't work
	// Everything is simply linked in our original direction
	if(istype(B1) && istype(T2) && istype(O) && ..(B, src, T, O))
		return TRUE

	// Else, we have to look in other directions
	for(var/dir in cardinal - src.dir)
		B1 = get_step(src, turn(dir, 180))
		O = GetAbove(B1)
		if(!istype(B1) || !istype(O))
			continue
		
		B = locate(/obj/structure/stairs/bottom) in B1
		if(..(B, src, T, O))
			return TRUE
	
	// The middle stair has some further special logic, in that it can be climbed, and so is technically valid if only the top exists
	// T is enforced by a prior if
	T.middle = src
	src.top = T
	src.dir = T.dir
	return TRUE

/obj/structure/stairs/middle/MouseDrop_T(mob/target, mob/user)
	. = ..()
	if(check_integrity())
		do_climb(user)
		user.forceMove(get_turf(top))

//////////////////////////////////////////////////////////////////////
// Top piece that you step onto //////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/obj/structure/stairs/top
	icon_state = "0,0"
	var/obj/structure/stairs/middle/middle = null
	var/obj/structure/stairs/bottom/bottom = null

/obj/structure/stairs/bottom/Initialize()
	if(GetBelow(src))
		warning("Stair created without level below: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL
	. = ..()

/obj/structure/stairs/top/Destroy()
	if(middle)
		middle.top = null
	if(bottom)
		bottom.top = null
	..()

// These are necessarily fairly similar, but because the positional relations are different, we have to copy-pasta a fair bit
/obj/structure/stairs/top/check_integrity(var/obj/structure/stairs/bottom/B = null,
										  var/obj/structure/stairs/middle/M = null,
										  var/obj/structure/stairs/top/T = null,
										  var/turf/simulated/open/O = null)
	
	// In the  case where we're provided all the pieces, just try connecting them.
	// In order: all exist, they are appropriately adjacent, and they can connect
	if(istype(B) && istype(M) && istype(T) && istype(O) && \
			B.Adjacent(M) && (GetBelow(O) == B.loc) && T.Adjacent(O) && \
			(. = ..()))
		return

	else if(istype(middle) && istype(bottom))
		O = locate(/turf/simulated/open) in GetAbove(bottom)
		if(..(bottom, middle, src, O))
			return TRUE


	O = get_step(src, turn(src.dir, 180))
	var/turf/B1 = GetBelow(O)
	var/turf/B2 = GetBelow(src)

	B = locate(/obj/structure/stairs/bottom) in B1
	M = locate(/obj/structure/stairs/middle) in B2

	// Middle stair is static for Top stair, so if it's invalid we can't do much
	if(!istype(M))
		return FALSE

	// If you set the dir, that's the dir it *wants* to connect in. It only chooses the others if that doesn't work
	// Everything is simply linked in our original direction
	if(istype(B) && istype(O) && (. = ..(B, M, src, O)))
		return

	// Else, we have to look in other directions
	for(var/dir in cardinal - src.dir)
		O = get_step(src, turn(dir, 180))
		B1 = GetBelow(O)
		if(!istype(B1) || !istype(O))
			continue
		
		B = locate(/obj/structure/stairs/bottom) in B1
		if((. = ..(B, M, src, O)))
			return
	
	// Out of the dir check, we have no valid neighbors, and thus are not complete. `.` was set by ..()
	return

/obj/structure/stairs/top/Crossed(var/atom/movable/AM, var/atom/oldloc)
	
	// If we're coming from the bottom of the stairs, don't trap us in an infinite staircase
	// Or if we climb up the middle
	if((bottom in oldloc) || oldloc == GetBelow(src))
		return
	
	if(isobserver(AM)) // Ghosts have their own methods for going up and down
		return
	
	if(AM.pulledby) // Animating the movement of pulled things is handled when the puller goes up the stairs
		return
	
	var/animation_delay = STAIR_MOVE_DELAY
	var/atom/movable/pulling = null
	if(isliving(AM))
		var/mob/living/L = AM
		animation_delay = L.movement_delay()
		if(L.pulling && !L.pulling.anchored)
			pulling = L.pulling
	
	// If the stairs aren't broken, go up.
	if(check_integrity())
		AM.dir = turn(src.dir, 180)
		// Animate moving onto M
		switch(src.dir)
			if(NORTH)
				animate(AM, AM.pixel_y -= 32, time = animation_delay)
			if(SOUTH)
				animate(AM, AM.pixel_y -= -32, time = animation_delay)
			if(EAST)
				animate(AM, AM.pixel_x -= 32, time = animation_delay)
			if(WEST)
				animate(AM, AM.pixel_x -= -32, time = animation_delay)

		// Bring the pulled object along behind us
		if(pulling)
			switch(src.dir)
				if(NORTH)
					animate(pulling, pulling.pixel_y -= 32, time = animation_delay)
				if(SOUTH)
					animate(pulling, pulling.pixel_y -= -32, time = animation_delay)
				if(EAST)
					animate(pulling, pulling.pixel_x -= 32, time = animation_delay)
				if(WEST)
					animate(pulling, pulling.pixel_x -= -32, time = animation_delay)

		// Go up the stairs
		spawn(animation_delay)
			// Move to Top
			AM.forceMove(get_turf(bottom))

			// Animate moving from O to T
			switch(src.dir)
				if(NORTH)
					AM.pixel_y += 64
					animate(AM, AM.pixel_y -= 32, time = animation_delay)//, easing = SINE_EASING | EASE_OUT)
				if(SOUTH)
					AM.pixel_y += -64
					animate(AM, AM.pixel_y -= -32, time = animation_delay)//, easing = SINE_EASING | EASE_OUT)
				if(EAST)
					AM.pixel_x += 64
					animate(AM, AM.pixel_x -= 32, time = animation_delay)//, easing = SINE_EASING | EASE_OUT)
				if(WEST)
					AM.pixel_x += -64
					animate(AM, AM.pixel_x -= -32, time = animation_delay)//, easing = SINE_EASING | EASE_OUT)
		
		
			// If something is being pulled, bring it along directly to avoid the mob being torn away from it due to movement delays
			if(pulling)
				spawn(animation_delay)
					switch(src.dir)
						if(NORTH)
							pulling.pixel_y += 32
						if(SOUTH)
							pulling.pixel_y += -32
						if(EAST)
							pulling.pixel_x += 32
						if(WEST)
							pulling.pixel_x += -32
					pulling.forceMove(get_turf(bottom)) // Just bring it along directly, no fussing with animation timing
	return TRUE



/*
/obj/structure/stairs/Initialize()
	. = ..()
	for(var/turf/turf in locs)
		var/turf/simulated/open/above = GetAbove(turf)
		if(!above)
			warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
			return qdel(src)
		if(!istype(above))
			above.ChangeTurf(/turf/simulated/open)

/obj/structure/stairs/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(get_dir(loc, target) == dir && upperStep(mover.loc))
		return FALSE
	. = ..()

/obj/structure/stairs/Bumped(atom/movable/A)
	// This is hackish but whatever.
	var/turf/target = get_step(GetAbove(A), dir)
	if(target.Enter(A, src)) // Pass src to be ignored to avoid infinate loop
		A.forceMove(target)
		if(isliving(A))
			var/mob/living/L = A
			if(L.pulling && !L.pulling.anchored)
				L.pulling.forceMove(target)

/obj/structure/stairs/proc/upperStep(var/turf/T)
	return (T == loc)

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density
*/






// Mapping pieces, placed at the bottommost part of the stairs
/obj/structure/stairs/spawner
	name = "Stairs spawner"

/obj/structure/stairs/spawner/Initialize()
	. = ..()
	var/turf/B1 = get_turf(src)
	var/turf/B2 = get_step(B1, dir)
	var/turf/T1 = GetAbove(B1)
	var/turf/T2 = GetAbove(B2)
	
	if(!istype(B1) || !istype(B2))
		warning("Stair created at invalid loc: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL
	if(!istype(T1) || !istype(T2))
		warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL
	
	// Spawn the stairs
	// Railings sold separately
	var/turf/simulated/open/O = T1
	var/obj/structure/stairs/top/T 	  = new(T2)
	var/obj/structure/stairs/middle/M = new(B2)
	var/obj/structure/stairs/bottom/B = new(B1)
	if(!isopenspace(O))
		O = new(O)

	B.dir = dir
	M.dir = dir
	T.dir = dir
	B.check_integrity(B, M, T, O)

	return INITIALIZE_HINT_QDEL
	

/obj/structure/stairs/spawner/north
	dir = NORTH

/obj/structure/stairs/spawner/south
	dir = SOUTH

/obj/structure/stairs/spawner/east
	dir = EAST

/obj/structure/stairs/spawner/west
	dir = WEST