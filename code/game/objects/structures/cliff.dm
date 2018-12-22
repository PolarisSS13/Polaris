GLOBAL_LIST_EMPTY(cliff_icon_cache)

/*
Cliffs give a visual illusion of depth by seperating two places while presenting a 'top' and 'bottom' side.

Mobs moving into a cliff from the bottom side will simply bump into it and be denied moving into the tile,
where as mobs moving into a cliff from the top side will 'fall' off the cliff, forcing them to the bottom, causing damage and stunning them.

Mobs can climb this while wearing climbing equipment by clickdragging themselves onto a cliff, as if it were a table.

Projectiles and thrown objects can pass, however if moving upwards, there is a chance for it to be stopped by the cliff.
This makes fighting something that is on top of a cliff more challenging.

As a note, dir points upwards, e.g. pointing WEST means the left side is 'up', and the right side is 'down'.

When mapping these in, be sure to give at least a one tile clearance, as NORTH facing cliffs expand to
two tiles on initialization, and which way a cliff is facing may change during maploading.
*/

/obj/structure/cliff
	name = "cliff"
	desc = "A steep rock ledge. You might be able to climb it if you feel bold enough."
	icon = 'icons/obj/flora/rocks.dmi'
//	icon_state = "dogbed"

	anchored = TRUE
	density = TRUE
	opacity = FALSE
	climbable = TRUE
	climb_delay = 10 SECONDS
	block_turf_edges = TRUE // Don't want turf edges popping up from the cliff edge.

	var/icon_variant = null // Used to make cliffs less repeative by having a selection of sprites to display.
	var/corner = FALSE // Used for icon things.
	var/ramp = FALSE // Ditto.
	var/bottom = FALSE // Used for 'bottom' typed cliffs, to avoid infinite cliffs.

	var/is_double_cliff = FALSE // Set to true when making the two-tile cliffs, used for projectile checks.
	var/uphill_penalty = 30 // Odds of a projectile not making it up the cliff.

// These arrange their sprites at runtime, as opposed to being statically placed in the map file.
/obj/structure/cliff/automatic
	icon_state = "cliffbuilder"
	dir = NORTH

/obj/structure/cliff/automatic/corner
	icon_state = "cliffbuilder-corner"
	dir = NORTHEAST
	corner = TRUE

/obj/structure/cliff/automatic/ramp
	icon_state = "cliffbuilder-ramp"
	dir = NORTHEAST

// Tiny part that doesn't block, used for making 'ramps'.
/obj/structure/cliff/ramp
	density = FALSE

// Made automatically as needed by automatic cliffs.
/obj/structure/cliff/bottom
	bottom = TRUE

/obj/structure/cliff/automatic/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

// Paranoid about the maploader, direction is very important to cliffs, since they may get bigger if initialized while facing NORTH.
/obj/structure/cliff/automatic/LateInitialize()
	if(dir in GLOB.cardinal)
		icon_variant = pick("a", "b", "c")

	if(dir & NORTH && !bottom) // North-facing cliffs require more cliffs to be made.
		make_bottom()

	update_icon()

/obj/structure/cliff/proc/make_bottom()
	// First, make sure there's room to put the bottom side.
	var/turf/T = locate(x, y - 1, z)
	if(!istype(T))
		return FALSE

	// Now make the bottom cliff have mostly the same variables.
	var/obj/structure/cliff/bottom/bottom = new(T)
	is_double_cliff = TRUE
	climb_delay /= 2 // Since there are two cliffs to climb when going north, both take half the time.

	bottom.dir = dir
	bottom.is_double_cliff = TRUE
	bottom.climb_delay = climb_delay
	bottom.icon_variant = icon_variant
	bottom.corner = corner
	bottom.ramp = ramp
	bottom.layer = layer - 0.1
	bottom.density = density
	bottom.update_icon()

/obj/structure/cliff/update_icon()
	icon_state = "cliff-[dir][icon_variant][bottom ? "-bottom" : ""][corner ? "-corner" : ""][ramp ? "-ramp" : ""]"

	// Now for making the top-side look like a different turf.
	var/turf/T = get_step(src, dir)
	var/subtraction_icon_state = "[icon_state]-subtract"
	var/cache_string = "[icon_state]_[T.icon]_[T.icon_state]"
	if(T && subtraction_icon_state in icon_states(icon))
		cut_overlays()
		// If we've made the same icon before, just recycle it.
	//	if(cache_string in GLOB.cliff_icon_cache)
	//		add_overlay(GLOB.cliff_icon_cache[cache_string])
	//	else // Otherwise make a new one, but only once.
		world << "Going to blend [icon_state] with [subtraction_icon_state]."
		var/icon/underlying_ground = icon(T.icon, T.icon_state, T.dir)
		var/icon/subtract = icon(icon, subtraction_icon_state)
		underlying_ground.Blend(subtract, ICON_SUBTRACT)
		var/image/final = image(underlying_ground)
		final.layer = src.layer - 0.2
//		GLOB.cliff_icon_cache[cache_string] = final
		add_overlay(final)

/*
/turf/simulated/floor/water/shoreline/update_icon()
	underlays.Cut()
	cut_overlays()
	..() // Get the underlay first.
	var/cache_string = "[initial(icon_state)]_[water_state]_[dir]"
	if(cache_string in shoreline_icon_cache) // Check to see if an icon already exists.
		add_overlay(shoreline_icon_cache[cache_string])
	else // If not, make one, but only once.
		var/icon/shoreline_water = icon(src.icon, "shoreline_water", src.dir)
		var/icon/shoreline_subtract = icon(src.icon, "[initial(icon_state)]_subtract", src.dir)
		shoreline_water.Blend(shoreline_subtract,ICON_SUBTRACT)
		var/image/final = image(shoreline_water)
		final.layer = WATER_LAYER

		shoreline_icon_cache[cache_string] = final
		add_overlay(shoreline_icon_cache[cache_string])
*/

// Movement-related code.

/obj/structure/cliff/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE // Airflow can always pass.

	else if(isliving(mover))
		var/mob/living/L = mover
		if(L.hovering) // Flying mobs can always pass.
			return TRUE
		return ..()

	// Projectiles and objects flying 'upward' have a chance to hit the cliff instead, wasting the shot.
	else if(istype(mover, /obj))
		var/obj/O = mover
		if(check_shield_arc(src, dir, O)) // This is actually for mobs but it will work for our purposes as well.
			if(prob(uphill_penalty / (1 + is_double_cliff) )) // Firing upwards facing NORTH means it will likely have to pass through two cliffs, so the chance is halved.
				return FALSE
		return TRUE

/*
/obj/effect/directional_shield/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return TRUE
	else if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		if(istype(P, /obj/item/projectile/test)) // Turrets need to try to kill the shield and so their test bullet needs to penetrate.
			return TRUE

		var/bad_arc = reverse_direction(dir) // Arc of directions from which we cannot block.
		if(check_shield_arc(src, bad_arc, P)) // This is actually for mobs but it will work for our purposes as well.
			return FALSE
		else
			return TRUE
	return TRUE
*/


// These are hopefully temporary.
/obj/structure/cliff/cliff1
	icon_state = "1"

/obj/structure/cliff/cliff2
	icon_state = "2"

/obj/structure/cliff/cliff3
	icon_state = "3"

/obj/structure/cliff/cliff4
	icon_state = "4"

/obj/structure/cliff/cliff5
	icon_state = "5"

/obj/structure/cliff/cliff6
	icon_state = "6"

/obj/structure/cliff/cliff7
	icon_state = "7"

/obj/structure/cliff/cliff8
	icon_state = "8"

/obj/structure/cliff/cliff9
	icon_state = "9"


/obj/structure/cliff/cliff10
	icon_state = "10"

/obj/structure/cliff/cliff11
	icon_state = "11"

/obj/structure/cliff/cliff12
	icon_state = "12"

/obj/structure/cliff/cliff13
	icon_state = "13"

/obj/structure/cliff/cliff14
	icon_state = "14"

/obj/structure/cliff/cliff15
	icon_state = "15"

/obj/structure/cliff/cliff16
	icon_state = "16"

/obj/structure/cliff/cliff17
	icon_state = "17"

/obj/structure/cliff/cliff18
	icon_state = "18"

/obj/structure/cliff/cliff19
	icon_state = "19"


/obj/structure/cliff/cliff20
	icon_state = "20"

/obj/structure/cliff/cliff21
	icon_state = "21"

/obj/structure/cliff/cliff22
	icon_state = "22"

/obj/structure/cliff/cliff23
	icon_state = "23"

/obj/structure/cliff/cliff24
	icon_state = "24"

/obj/structure/cliff/cliff25
	icon_state = "25"

/obj/structure/cliff/cliff26
	icon_state = "26"

/obj/structure/cliff/cliff27
	icon_state = "27"

/obj/structure/cliff/cliff28
	icon_state = "28"

/obj/structure/cliff/cliff29
	icon_state = "29"


/obj/structure/cliff/cliff30
	icon_state = "30"

/obj/structure/cliff/cliff31
	icon_state = "31"

/obj/structure/cliff/cliff32
	icon_state = "32"

/obj/structure/cliff/cliff33
	icon_state = "33"

/obj/structure/cliff/cliff34
	icon_state = "34"

/obj/structure/cliff/cliff35
	icon_state = "35"

/obj/structure/cliff/cliff36
	icon_state = "36"

/obj/structure/cliff/cliff37
	icon_state = "37"
