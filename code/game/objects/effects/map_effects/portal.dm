GLOBAL_LIST_EMPTY(all_portal_masters)

// Portal map effects allow a mapper to join two distant places together, while looking hopefully seamlessly connected.
// This can allow for very strange PoIs that twist and turn in what appear to be physically impossible ways.

/obj/effect/map_effect/portal
	name = "portal subtype"
	invisibility = 0
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	var/obj/effect/map_effect/portal/counterpart = null // The portal line or master that this is connected to, on the 'other side'.

	// Information used to apply `pixel_[x|y]` offsets so that the visuals line up.
	var/total_height = 0 // Measured in tiles.
	var/total_width = 0

	var/portal_distance_x = 0 // How far the portal is from the left edge, in tiles.
	var/portal_distance_y = 0 // How far the portal is from the top edge.



/obj/effect/map_effect/portal/Destroy()
	vis_contents = null
	if(counterpart)
		counterpart.counterpart = null
		counterpart = null
	return ..()


/obj/effect/map_effect/portal/Crossed(atom/movable/AM)
	if(AM.is_incorporeal())
		return
	..()
	if(!AM)
		return
	if(!counterpart)
		return

	AM.forceMove(counterpart.get_focused_turf())

/obj/effect/map_effect/portal/proc/get_focused_turf()
	return get_step(get_turf(src), dir)

/obj/effect/map_effect/portal/proc/calculate_dimensions()
	var/highest_x = 0
	var/lowest_x = 0

	var/highest_y = 0
	var/lowest_y = 0

	// First pass is for finding the top right corner.
	for(var/thing in vis_contents)
		var/turf/T = thing
		if(T.x > highest_x)
			highest_x = T.x
		if(T.y > highest_y)
			highest_y = T.y

	lowest_x = highest_x
	lowest_y = highest_y

	// Second one is for the bottom left corner.
	for(var/thing in vis_contents)
		var/turf/T = thing
		if(T.x < lowest_x)
			lowest_x = T.x
		if(T.y < lowest_y)
			lowest_y = T.y

	// Now calculate the dimensions.
	total_width = (highest_x - lowest_x) + 1
	total_height = (highest_y - lowest_y) + 1

	var/turf/focused_T = counterpart.get_focused_turf()
	portal_distance_x = lowest_x - focused_T.x
	portal_distance_y = lowest_y - focused_T.y



// Portal masters manage everything else involving portals.
// This is the base type. Use `/side_a` or `/side_b` for actual portals.
/obj/effect/map_effect/portal/master
	name = "portal master"
	var/portal_id = "test" // For a portal to be made, both the A and B sides need to share the same ID value.
	var/list/portal_lines = list()

/obj/effect/map_effect/portal/master/Initialize()
	GLOB.all_portal_masters += src
	find_lines()
	find_counterparts()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/portal/master/LateInitialize()
	make_visuals()
	apply_offset()

/obj/effect/map_effect/portal/master/Destroy()
	GLOB.all_portal_masters -= src
	for(var/thing in portal_lines)
		qdel(thing)
	return ..()

/obj/effect/map_effect/portal/master/proc/find_lines()
	var/list/dirs_to_search = list( turn(dir, 90), turn(dir, -90) )

	for(var/dir_to_search in dirs_to_search)
		var/turf/current_T = get_turf(src)
		while(current_T)
			current_T = get_step(current_T, dir_to_search)
			var/obj/effect/map_effect/portal/line/line = locate() in current_T
			if(line)
				portal_lines += line
				line.my_master = src
			else
				break

/obj/effect/map_effect/portal/master/proc/find_counterparts()
	for(var/thing in GLOB.all_portal_masters)
		var/obj/effect/map_effect/portal/master/M = thing
		if(M == src)
			continue
		if(M.counterpart)
			continue

		if(M.portal_id == src.portal_id)
			counterpart = M
			M.counterpart = src
			if(portal_lines.len)
				for(var/i = 1 to portal_lines.len)
					var/obj/effect/map_effect/portal/line/our_line = portal_lines[i]
					var/obj/effect/map_effect/portal/line/their_line = M.portal_lines[i]
					our_line.counterpart = their_line
					their_line.counterpart = our_line

			break

/obj/effect/map_effect/portal/master/proc/make_visuals()
	var/list/observed_turfs = list()
	for(var/thing in portal_lines + src)
		var/obj/effect/map_effect/portal/P = thing
		P.icon_state = null

		var/turf/T = P.counterpart.get_focused_turf()
		P.vis_contents += T

		var/list/things = dview(world.view, T)
		for(var/turf/turf in things)
			if(get_dir(turf, T) & P.dir)
				if(turf in observed_turfs) // Avoid showing the same turf twice or more for improved performance.
					continue

				P.vis_contents += turf
				observed_turfs += turf

		P.calculate_dimensions()


/obj/effect/map_effect/portal/master/proc/apply_offset()
	for(var/thing in portal_lines + src)
		var/obj/effect/map_effect/portal/P = thing

		P.pixel_x = 32 * P.portal_distance_x
		P.pixel_y = 32 * P.portal_distance_y

/obj/effect/map_effect/portal/master/side_a
	name = "portal master A"
	icon_state = "portal_side_a"
//	color = "#00FF00"

/obj/effect/map_effect/portal/master/side_b
	name = "portal master B"
	icon_state = "portal_side_b"
//	color = "#FF0000"



// Portal lines extend out from the sides of portal masters,
// They let portals be longer than 1x1.
// Both sides MUST be the same length, meaning if side A is 1x3, side B must also be 1x3.
/obj/effect/map_effect/portal/line
	name = "portal line"
	var/obj/effect/map_effect/portal/master/my_master = null

/obj/effect/map_effect/portal/line/Destroy()
	if(my_master)
		my_master.portal_lines -= src
		my_master = null
	return ..()

/obj/effect/map_effect/portal/line/side_a
	name = "portal line A"
	icon_state = "portal_line_side_a"

/obj/effect/map_effect/portal/line/side_b
	name = "portal line B"
	icon_state = "portal_line_side_b"