/datum/event2/meta/carp_migration
	name = "carp migration"
	event_class = "carp"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)
	chaos = 30
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/carp_migration

/datum/event2/meta/carp_migration/get_weight()
	return 10 + (metric.count_people_in_department(DEPARTMENT_SECURITY) * 20) + (metric.count_all_space_mobs() * 40)


/datum/event2/event/carp_migration
	announce_delay_lower_bound = 1 MINUTE
	announce_delay_upper_bound = 2 MINUTES
	length_lower_bound = 30 SECONDS
	length_upper_bound = 1 MINUTE
	var/use_map_edge_with_landmarks = TRUE // Use both landmarks and spawning from the "edge" of the map. Otherise uses landmarks over map edge.
	var/carp_cap = 30 // No more than this many (living) carp can exist from this event.
	var/carp_smallest_group = 3
	var/carp_largest_group = 5
	var/carp_wave_cooldown = 10 SECONDS

	var/list/spawned_carp = list()
	var/last_carp_wave_time = null // Last world.time we spawned a carp wave.
	var/list/valid_z_levels = null

/datum/event2/event/carp_migration/set_up()
	valid_z_levels = get_location_z_levels()
	valid_z_levels -= using_map.sealed_levels // Space levels only please!

/datum/event2/event/carp_migration/announce()
	var/announcement = "Unknown biological entities been detected near \the [location_name()], please stand-by."
	command_announcement.Announce(announcement, "Lifesign Alert")


/datum/event2/event/carp_migration/event_tick()
	if(last_carp_wave_time + carp_wave_cooldown > world.time)
		return
	last_carp_wave_time = world.time

	if(count_spawned_carps() < carp_cap)
		spawn_fish(number_of_groups = rand(1, 4), min_size_of_group = carp_smallest_group, max_size_of_group = carp_largest_group)

/datum/event2/event/carp_migration/end()
	// Clean up carp that died in space for some reason.
	for(var/mob/living/simple_mob/SM in spawned_carp)
		if(SM.stat == DEAD)
			var/turf/T = get_turf(SM)
			if(istype(T, /turf/space))
				if(prob(75))
					qdel(SM)

// Makes carp spawn, no landmarks required, but they're still used if they exist.
/datum/event2/event/carp_migration/proc/spawn_fish(number_of_groups, min_size_of_group, max_size_of_group, dir)
	if(isnull(dir))
		dir = pick(GLOB.cardinal)

	// Check if any landmarks exist!
	var/list/spawn_locations = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn" && (C.z in valid_z_levels))
			spawn_locations.Add(C.loc)

	var/prioritize_landmarks = TRUE
	if(use_map_edge_with_landmarks && prob(50))
		prioritize_landmarks = FALSE // One in two chance to come from the edge instead.

	if(spawn_locations.len && prioritize_landmarks) // Okay we've got landmarks, lets use those!
		shuffle_inplace(spawn_locations)
		number_of_groups = min(number_of_groups, spawn_locations.len)
		var/i = 1
		while (i <= number_of_groups)
			var/group_size = rand(min_size_of_group, max_size_of_group)
			for (var/j = 0, j < group_size, j++)
				spawn_one_carp(spawn_locations[i])
		i++
		return

	// Okay we did *not* have any landmarks, or we're being told to do both, so lets do our best!
	var/i = 1
	while(i <= number_of_groups)
		var/z_level = pick(valid_z_levels)
		var/group_size = rand(min_size_of_group, max_size_of_group)
		var/turf/map_center = locate(round(world.maxx/2), round(world.maxy/2), z_level)
		var/turf/group_center = pick_random_edge_turf(dir, z_level, TRANSITIONEDGE + 2)
		var/list/turfs = getcircle(group_center, 2)
		for(var/j = 0, j < group_size, j++)
			// On larger maps, BYOND gets in the way of letting simple_mobs path to the closest edge of the station.
			// So instead we need to simulate the carp's travel, then spawn them somewhere still hopefully off screen.

			// Find a turf to be the edge of the map.
			var/turf/edge_of_map = turfs[(i % turfs.len) + 1]

			// Now walk a straight line towards the center of the map, until we find a non-space tile.
			var/turf/edge_of_station = null

			var/list/space_line = list() // This holds all space tiles on the line. Will be used a bit later.
			for(var/turf/T in getline(edge_of_map, map_center))
				if(!T.is_space())
					break // We found the station!
				space_line += T
				edge_of_station = T

			// Now put the carp somewhere on the line, hopefully off screen.
			// I wish this was higher than 8 but the BYOND internal A* algorithm gives up sometimes when using
			// 16 or more.
			// In the future, a new AI stance that handles long distance travel using getline() could work.
			var/max_distance = 8
			var/turf/spawn_turf = null
			for(var/P in space_line)
				var/turf/point = P
				if(get_dist(point, edge_of_station) <= max_distance)
					spawn_turf = P
					break

			if(spawn_turf)
				// Finally, make the carp go towards the edge of the station.
				var/mob/living/simple_mob/animal/M = spawn_one_carp(spawn_turf)
				if(edge_of_station)
					M.ai_holder?.give_destination(edge_of_station) // Ask carp to swim towards the edge of the station.
		i++

/datum/event2/event/carp_migration/proc/spawn_one_carp(new_loc)
	var/mob/living/simple_mob/animal/M = new /mob/living/simple_mob/animal/space/carp/event(new_loc)
	GLOB.destroyed_event.register(M, src, .proc/on_carp_destruction)
	spawned_carp += M
	return M


// Counts living carp spawned by this event.
/datum/event2/event/carp_migration/proc/count_spawned_carps()
	. = 0
	for(var/I in spawned_carp)
		var/mob/living/simple_mob/animal/M = I
		if(!QDELETED(M) && M.stat != DEAD)
			. += 1

// If carp is bomphed, remove it from the list.
/datum/event2/event/carp_migration/proc/on_carp_destruction(mob/M)
	spawned_carp -= M
	GLOB.destroyed_event.unregister(M, src, .proc/on_carp_destruction)
