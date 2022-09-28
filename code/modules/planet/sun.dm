/datum/sun_holder
	var/atom/movable/sun_visuals/sun = new
	var/datum/planet/our_planet

/datum/sun_holder/New(var/source)
	our_planet = source

/datum/sun_holder/proc/update_color(new_color)
	sun.color = new_color

/datum/sun_holder/proc/update_brightness(new_brightness)
	sun.alpha = round(clamp(new_brightness, 0, 1)*255,1)

/datum/sun_holder/proc/apply_to_turf(turf/T)
	if(sun in T.vis_contents)
		warning("Was asked to add fake sun to [T.x], [T.y], [T.z] despite already having us in it's vis contents")
		return
	sun.apply_to_turf(T)

/datum/sun_holder/proc/remove_from_turf(turf/T)
	if(!(sun in T.vis_contents))
		warning("Was asked to remove fake sun from [T.x], [T.y], [T.z] despite it not having us in it's vis contents")
		return
	sun.remove_from_turf(T)

/datum/sun_holder/proc/rainbow()
	var/end = world.time + 30 SECONDS

	var/col_index = 1

	var/list/colors = list("#ff5d5d","#ffd17b","#ffff5e","#7eff7e","#6868ff","#b753ff","#d08fff","#ffffff")
	var/original_brightness = sun.alpha/255
	var/original_color = sun.color

	update_brightness(0.8)

	while(world.time < end)
		update_color(colors[col_index])
		if(++col_index > colors.len)
			col_index = 1
		sleep(3)

	update_brightness(original_brightness)
	update_color(original_color)

// Holds a full white icon that can be mutated to make sun on the O_LIGHTING plane
/atom/movable/sun_visuals
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	plane = PLANE_O_LIGHTING_VISUAL
	mouse_opacity = 0
	alpha = 0
	color = "#FFFFFF"

	var/turfs_providing_spreads = list()
	var/turfs_receiving_spreads = list()
	var/spreads = list()

/atom/movable/sun_visuals/New()
	..()
	spreads["1"] = new /atom/movable/sun_visuals_overlap(src, NORTH, "white_gradient")
	spreads["2"] = new /atom/movable/sun_visuals_overlap(src, SOUTH, "white_gradient")
	spreads["4"] = new /atom/movable/sun_visuals_overlap(src, EAST, "white_gradient")
	spreads["8"] = new /atom/movable/sun_visuals_overlap(src, WEST, "white_gradient")

	spreads["i5"] = new /atom/movable/sun_visuals_overlap(src, NORTHEAST, "white_inner")
	spreads["i6"] = new /atom/movable/sun_visuals_overlap(src, SOUTHEAST, "white_inner")
	spreads["i9"] = new /atom/movable/sun_visuals_overlap(src, NORTHWEST, "white_inner")
	spreads["i10"] = new /atom/movable/sun_visuals_overlap(src, SOUTHWEST, "white_inner")

	spreads["o5"] = new /atom/movable/sun_visuals_overlap(src, NORTHEAST, "white_outer")
	spreads["o6"] = new /atom/movable/sun_visuals_overlap(src, SOUTHEAST, "white_outer")
	spreads["o9"] = new /atom/movable/sun_visuals_overlap(src, NORTHWEST, "white_outer")
	spreads["o10"] = new /atom/movable/sun_visuals_overlap(src, SOUTHWEST, "white_outer")

/atom/movable/sun_visuals/proc/set_color(new_color)
	src.color = new_color
	for(var/key in spreads)
		var/atom/movable/sun_visuals_overlap/SVO = spreads[key]
		SVO.color = new_color

/atom/movable/sun_visuals/proc/set_alpha(new_alpha)
	src.alpha = new_alpha
	for(var/key in spreads)
		var/atom/movable/sun_visuals_overlap/SVO = spreads[key]
		SVO.alpha = new_alpha

/atom/movable/sun_visuals/proc/apply_to_turf(var/turf/T)
	T.vis_contents += src
	T.dynamic_lumcount += 0.5
	T.luminosity = 1

	var/list/localspreads
	// Test for corners
	for(var/direction in cornerdirs)
		var/turf/dirturf = get_step(T, direction)
		if(dirturf && !dirturf.outdoors)
			var/turf/TL = get_step(T, turn(direction, -45))
			var/turf/TR = get_step(T, turn(direction, 45))

			// If outdoors at 45 degrees are the same, then this is a corner
			if(TL && TR && TL.outdoors == TR.outdoors)
				var/atom/movable/sun_visuals_overlap/OL
				// Outer corner
				if(TL.outdoors)
					OL = spreads["o[direction]"]
				// Inner corner
				else
					OL = spreads["i[direction]"]
				T.vis_contents += OL
				LAZYADD(localspreads, OL)
				LAZYADD(turfs_receiving_spreads[dirturf], OL)
				dirturf.luminosity = 1

	// Take all orthagonals
	for(var/direction in cardinal)
		var/turf/dirturf = get_step(T, direction)
		if(dirturf && !dirturf.outdoors)
			var/turf/TL = get_step(T, turn(direction, -45))
			var/turf/TR = get_step(T, turn(direction, 45))
			// End of a wall, the corner will handle it
			if(TL && TR && TL.outdoors != TR.outdoors)
				continue
			var/atom/movable/sun_visuals_overlap/OL = spreads["[direction]"]
			T.vis_contents += OL
			LAZYADD(localspreads, OL)
			LAZYADD(turfs_receiving_spreads[dirturf], OL)
			dirturf.luminosity = 1

	if(LAZYLEN(localspreads))
		turfs_providing_spreads[T] = localspreads

/atom/movable/sun_visuals/proc/remove_from_turf(var/turf/T)
	T.vis_contents -= src
	T.dynamic_lumcount -= 0.5
	T.luminosity = !IS_DYNAMIC_LIGHTING(T)
	var/list/applied = turfs_providing_spreads[T]
	if(LAZYLEN(applied))
		T.vis_contents -= applied
		turfs_providing_spreads -= T
		applied.Cut()

/atom/movable/sun_visuals_overlap
	icon = 'icons/effects/effects.dmi'
	icon_state = null
	plane = PLANE_O_LIGHTING_VISUAL
	mouse_opacity = 0
	alpha = 0
	color = "#FFFFFF"

/atom/movable/sun_visuals_overlap/New(newloc, newdir, newstate)
	..()
	icon_state = newstate
	dir = newdir
	if(newdir & NORTH)
		pixel_y = 32
	else if(newdir & SOUTH)
		pixel_y = -32

	if(newdir & EAST)
		pixel_x = 32
	else if(newdir & WEST)
		pixel_x = -32
