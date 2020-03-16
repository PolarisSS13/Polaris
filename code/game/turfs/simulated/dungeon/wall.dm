// Special wall type for Point of Interests.

/turf/simulated/wall/dungeon
	block_tele = TRUE // Anti-cheese.

/turf/simulated/wall/dungeon/New(var/newloc)
	..(newloc,"dungeonium")

/turf/simulated/wall/dungeon/attackby()
	return

/turf/simulated/wall/dungeon/ex_act()
	return

/turf/simulated/wall/dungeon/take_damage()	//These things are suppose to be unbreakable
	return

/turf/simulated/wall/solidrock //for more stylish anti-cheese.
	description_info = "Probably not going to be able to drill or bomb your way through this, best to try and find a way around."
	var/icon_base = "rock"
	var/rock_side = "rock_side"
	block_tele = TRUE

/turf/simulated/wall/solidrock/New(var/newloc)
	..(newloc,"bedrock")

/turf/simulated/wall/solidrock/update_material()
	name = "solid rock"
	desc = "This rock seems dense, impossible to drill."

/turf/simulated/wall/solidrock/proc/get_cached_border(var/cache_id, var/direction, var/icon_file, var/icon_state, var/offset = 32)
	if(!mining_overlay_cache["[cache_id]_[direction]"])
		var/image/new_cached_image = image(icon_state, dir = direction, layer = ABOVE_TURF_LAYER)
		switch(direction)
			if(NORTH)
				new_cached_image.pixel_y = offset
			if(SOUTH)
				new_cached_image.pixel_y = -offset
			if(EAST)
				new_cached_image.pixel_x = offset
			if(WEST)
				new_cached_image.pixel_x = -offset
		mining_overlay_cache["[cache_id]_[direction]"] = new_cached_image
		return new_cached_image

	return mining_overlay_cache["[cache_id]_[direction]"]

/turf/simulated/wall/solidrock/update_icon(var/update_neighbors)
	if(density)
		var/image/I
		for(var/i = 1 to 4)
			I = image('icons/turf/wall_masks.dmi', "[material.icon_base][wall_connections[i]]", dir = 1<<(i-1))
			add_overlay(I)
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				add_overlay(get_cached_border(rock_side,direction,icon,rock_side))

	else if(update_neighbors)
		for(var/direction in alldirs)
			if(istype(get_step(src, direction), /turf/simulated/wall/solidrock))
				var/turf/simulated/wall/solidrock/M = get_step(src, direction)
				M.update_icon()

/turf/simulated/wall/ChangeTurf()
	..()

/turf/simulated/wall/solidrock/attackby()
	return

/turf/simulated/wall/solidrock/ex_act()
	return

/turf/simulated/wall/solidrock/take_damage()	//These things are suppose to be unbreakable
	return

/*/turf/simulated/wall/dungeon/mossyrock // Version for POI labyrinths. No teleporting, no breaking.
	name = "mossy rocks"
	desc = "An old, yet impressively durably rock wall."
	description_info = "It's amazingly solid for how old it appears to be. May be best to find a way around."
	icon_state = "mossyrock"
	var/base_state = "mossyrock"
	var/mossyrock_side = "mossyrock_side"*/