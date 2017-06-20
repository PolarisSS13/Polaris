/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zMove(UP))
		to_chat(src, "<span class='notice'>You move upwards.</span>")

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(zMove(DOWN))
		to_chat(src, "<span class='notice'>You move down.</span>")

/mob/proc/zMove(direction)
	if(eyeobj)
		return eyeobj.zMove(direction)
	if(!can_ztravel())
		to_chat(src, "<span class='warning'>You lack means of travel in that direction.</span>")
		return

	var/turf/start = loc
	if(!istype(start))
		to_chat(src, "<span class='notice'>You are unable to move from here.</span>")
		return 0

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(!destination)
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return 0

	if(!start.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>\The [start] is in the way.</span>")
		return 0

	if(!destination.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>\The [destination] blocks your way.</span>")
		return 0

	var/area/area = get_area(src)
	if(direction == UP && area.has_gravity)
		var/obj/structure/lattice/lattice = locate() in destination.contents
		if(lattice)
			var/pull_up_time = max(5 SECONDS + (src.movement_delay() * 10), 1)
			to_chat(src, "<span class='notice'>You grab \the [lattice] and start pulling yourself upward...</span>")
			destination.audible_message("<span class='notice'>You hear something climbing up \the [lattice].</span>")
			if(do_after(src, pull_up_time))
				to_chat(src, "<span class='notice'>You pull yourself up.</span>")
			else
				to_chat(src, "<span class='warning'>You gave up on pulling yourself up.</span>")
				return 0
		else
			to_chat(src, "<span class='warning'>Gravity stops you from moving upward.</span>")
			return 0

	for(var/atom/A in destination)
		if(!A.CanPass(src, start, 1.5, 0))
			to_chat(src, "<span class='warning'>\The [A] blocks you.</span>")
			return 0
	Move(destination)
	return 1

/mob/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/observer/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/proc/can_ztravel()
	return 0

/mob/observer/can_ztravel()
	return 1

/mob/living/carbon/human/can_ztravel()
	if(incapacitated())
		return 0

	if(Process_Spacemove())
		return 1

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return 1

/mob/living/silicon/robot/can_ztravel()
	if(incapacitated() || is_dead())
		return 0

	if(Process_Spacemove()) //Checks for active jetpack
		return 1

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
		if(T.density)
			return 1




//FALLING STUFF

//Holds fall checks that should not be overriden by children
/atom/movable/proc/fall()
	if(!isturf(loc))
		return

	var/turf/below = GetBelow(src)
	if(!below)
		return

	var/turf/T = loc
	if(!T.CanZPass(src, DOWN) || !below.CanZPass(src, DOWN))
		return

	// No gravity in space, apparently.
	var/area/area = get_area(src)
	if(!area.has_gravity())
		return

	if(throwing)
		return

	if(can_fall())
		handle_fall(below)

//For children to override
/atom/movable/proc/can_fall()
	if(anchored)
		return FALSE

	if(locate(/obj/structure/lattice, loc))
		return FALSE

	// See if something prevents us from falling.
	var/turf/below = GetBelow(src)
	for(var/atom/A in below)
		if(!A.CanPass(src, src.loc))
			return FALSE

	return TRUE

/obj/effect/can_fall()
	return FALSE

/obj/effect/decal/cleanable/can_fall()
	return TRUE

// These didn't fall anyways but better to nip this now just incase.
/atom/movable/lighting_overlay/can_fall()
	return FALSE

// Mechas are anchored, so we need to override.
/obj/mecha/can_fall()
	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, loc)
	if(lattice)
		var/area/area = get_area(src)
		if(area.has_gravity())
			// Lattices seem a bit too flimsy to hold up a massive exosuit.
			lattice.visible_message("<span class='danger'>\The [lattice] collapses under the weight of \the [src]!</span>")
			qdel(lattice)

	// See if something prevents us from falling.
	var/turf/below = GetBelow(src)
	for(var/atom/A in below)
		if(!A.CanPass(src, src.loc))
			return FALSE

	return TRUE

/obj/item/pipe/can_fall()
	var/turf/simulated/open/below = loc
	below = below.below

	. = ..()

	if(anchored)
		return FALSE

	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up in below))
		return FALSE

/mob/living/simple_animal/parrot/can_fall() // Poly can fly.
	return FALSE

/mob/living/simple_animal/hostile/carp/can_fall() // So can carp apparently.
	return FALSE

/atom/movable/proc/handle_fall(var/turf/landing)
	Move(landing)
	if(locate(/obj/structure/stairs) in landing)
		return 1

	if(istype(landing, /turf/simulated/open))
		visible_message("\The [src] falls from the deck above through \the [landing]!", "You hear a whoosh of displaced air.")
	else
		visible_message("\The [src] falls from the deck above and slams into \the [landing]!", "You hear something slam into the deck.")

/mob/living/carbon/human/handle_fall(var/turf/landing)
	if(..())
		return
	to_chat(src, "<span class='danger'>You fall off and hit \the [landing]!</span>")
	playsound(loc, "punch", 25, 1, -1)
	var/damage = 20 // Because wounds heal rather quickly, 20 should be enough to discourage jumping off but not be enough to ruin you, at least for the first time.
	apply_damage(rand(0, damage), BRUTE, BP_HEAD)
	apply_damage(rand(0, damage), BRUTE, BP_TORSO)
	apply_damage(rand(0, damage), BRUTE, BP_L_LEG)
	apply_damage(rand(0, damage), BRUTE, BP_R_LEG)
	apply_damage(rand(0, damage), BRUTE, BP_L_ARM)
	apply_damage(rand(0, damage), BRUTE, BP_R_ARM)
	Weaken(4)
	updatehealth()

/obj/mecha/handle_fall(var/turf/landing)
	if(..())
		return

	// Tell the pilot that they just dropped down with a superheavy mecha.
	if(occupant)
		to_chat(occupant, "<span class='warning'>\The [src] crashed down onto \the [landing]!</span>")

	// Anything on the same tile as the landing tile is gonna have a bad day.
	for(var/mob/living/L in landing.contents)
		L.visible_message("<span class='danger'>\The [src] crushes \the [L] as it lands on them!</span>")
		L.adjustBruteLoss(rand(70, 100))
		L.Weaken(8)

	// Now to hurt the mech.
	take_damage(rand(15, 30))

	// And hurt the floor.
	if(istype(landing, /turf/simulated/floor))
		var/turf/simulated/floor/ground = landing
		ground.break_tile()