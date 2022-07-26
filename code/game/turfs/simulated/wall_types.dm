/turf/simulated/wall/r_wall
	icon_state = "rgeneric"
	material = MAT_PLASTEEL
	reinf_material = MAT_PLASTEEL

/turf/simulated/wall/shull //Spaaaace ship.
	material = MAT_STEELHULL
	girder_material = MAT_STEELHULL

/turf/simulated/wall/rshull
	material = MAT_STEELHULL
	reinf_material = MAT_STEELHULL
	girder_material = MAT_STEELHULL

/turf/simulated/wall/pshull //Spaaaace-er ship.
	material = MAT_PLASTEELHULL
	girder_material = MAT_PLASTEELHULL

/turf/simulated/wall/rpshull
	material = MAT_PLASTEELHULL
	reinf_material = MAT_PLASTEELHULL
	girder_material = MAT_PLASTEELHULL

/turf/simulated/wall/dshull //Spaaaace-est ship.
	material = MAT_DURASTEELHULL
	girder_material = MAT_DURASTEELHULL

/turf/simulated/wall/rdshull
	material = MAT_DURASTEELHULL
	reinf_material = MAT_DURASTEELHULL
	girder_material = MAT_DURASTEELHULL

/turf/simulated/wall/thull
	material = MAT_TITANIUMHULL
	girder_material = MAT_TITANIUMHULL

/turf/simulated/wall/rthull
	material = MAT_TITANIUMHULL
	reinf_material = MAT_TITANIUMHULL
	girder_material = MAT_TITANIUMHULL

/turf/simulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "cult"
	material = "cult"
	reinf_material = "cult2"
	girder_material = "cult"

/turf/simulated/wall/iron
	material = MAT_IRON

/turf/simulated/wall/uranium
	material = MAT_URANIUM

/turf/simulated/wall/diamond
	material = MAT_DIAMOND

/turf/simulated/wall/gold
	material = MAT_GOLD

/turf/simulated/wall/silver
	material = MAT_SILVER

/turf/simulated/wall/lead
	material = MAT_LEAD

/turf/simulated/wall/r_lead
	material = MAT_LEAD
	reinf_material = MAT_LEAD

/turf/simulated/wall/phoron
	material = MAT_PHORON

/turf/simulated/wall/sandstone
	material = MAT_SANDSTONE

/turf/simulated/wall/ironphoron
	material = MAT_IRON
	reinf_material = MAT_PHORON

/turf/simulated/wall/golddiamond
	material = MAT_GOLD
	reinf_material = MAT_DIAMOND

/turf/simulated/wall/silvergold
	material = MAT_SILVER
	reinf_material = MAT_GOLD

/turf/simulated/wall/sandstonediamond
	material = MAT_SANDSTONE
	reinf_material = MAT_DIAMOND

/turf/simulated/wall/snowbrick
	material = "packed snow"

/turf/simulated/wall/resin
	material = "resin"
	girder_material = "resin"

/turf/simulated/wall/concrete
	desc = "A wall made out of concrete bricks"
	material = MAT_CONCRETE
	icon_state = "brick"


/turf/simulated/wall/r_concrete
	desc = "A sturdy wall made of concrete and reinforced with plasteel rebar"
	material = MAT_CONCRETE
	reinf_material = MAT_PLASTEELREBAR
	icon_state = "rbrick"

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/skipjack
	material = "alienalloy"

/turf/simulated/wall/skipjack/attackby()
	return

/turf/simulated/wall/titanium
	material = MAT_TITANIUM

/turf/simulated/wall/durasteel
	material = MAT_DURASTEEL
	reinf_material = MAT_DURASTEEL

/turf/simulated/wall/wood
	material = MAT_WOOD

/turf/simulated/wall/sifwood
	material = MAT_SIFWOOD

/turf/simulated/wall/log
	material = MAT_LOG

/turf/simulated/wall/log_sif
	material = MAT_SIFLOG

// Shuttle Walls
/turf/simulated/shuttle/wall
	name = "autojoin wall"
	icon_state = "light"
	opacity = 1
	density = 1
	blocks_air = 1

	var/base_state = "light" //The base iconstate to base sprites on
	var/hard_corner = 0 //Forces hard corners (as opposed to diagonals)
	var/true_name = "wall" //What to rename this to on init

	//Extra things this will try to locate and act like we're joining to. You can put doors, or whatever.
	//Carefully means only if it's on a /turf/simulated/shuttle subtype turf.
	var/static/list/join_carefully = list(
	/obj/structure/grille,
	/obj/machinery/door/blast/regular
	)
	var/static/list/join_always = list(
	/obj/structure/shuttle/engine,
	/obj/structure/shuttle/window,
	/obj/machinery/door/airlock/voidcraft
	)

/turf/simulated/shuttle/wall/hard_corner
	name = "hardcorner wall"
	icon_state = "light-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/no_join
	icon_state = "light-nj"
	join_group = null

/turf/simulated/shuttle/wall/dark
	icon = 'icons/turf/shuttle_dark.dmi'
	icon_state = "dark"
	base_state = "dark"

/turf/simulated/shuttle/wall/dark/hard_corner
	name = "hardcorner wall"
	icon_state = "dark-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/dark/no_join
	name = "nojoin wall"
	icon_state = "dark-nj"
	join_group = null

/turf/simulated/shuttle/wall/alien
	icon = 'icons/turf/shuttle_alien.dmi'
	icon_state = "alien"
	base_state = "alien"
	light_range = 3
	light_power = 0.75
	light_color = "#ff0066" // Pink-ish
	block_tele = TRUE // Will be used for dungeons so this is needed to stop cheesing with handteles.

/turf/simulated/shuttle/wall/alien/hard_corner
	name = "hardcorner wall"
	icon_state = "alien-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/alien/no_join
	name = "nojoin wall"
	icon_state = "alien-nj"
	join_group = null

/turf/simulated/shuttle/wall/Initialize()
	. = ..()

	//To allow mappers to rename shuttle walls to like "redfloor interior" or whatever for ease of use.
	name = true_name

	if(join_group)
		auto_join()
	else
		icon_state = base_state

	if(takes_underlays)
		underlay_update()

/turf/simulated/shuttle/wall/proc/auto_join()
	match_turf(NORTH, NORTH)
	match_turf(EAST, EAST)
	match_turf(SOUTH, SOUTH)
	match_turf(WEST, WEST)

	icon_state = "[base_state][join_flags]"
	if(isDiagonal(join_flags))
		if(hard_corner) //You are using 'hard' (aka full-tile) corners.
			icon_state += "h" //Hard corners have 'h' at the end of the state
		else //Diagonals need an underlay to not look ugly.
			takes_underlays = 1
	else //Everything else doesn't deserve our time!
		takes_underlays = initial(takes_underlays)

	return join_flags

/turf/simulated/shuttle/wall/proc/match_turf(direction, flag, mask=0)
	if((join_flags & mask) == mask)
		var/turf/simulated/shuttle/wall/adj = get_step(src, direction)
		if(istype(adj, /turf/simulated/shuttle/wall) && adj.join_group == src.join_group)
			join_flags |= flag      // turn on the bit flag
			return

		else if(istype(adj, /turf/simulated/shuttle))
			var/turf/simulated/shuttle/adj_cast = adj
			if(adj_cast.join_group == src.join_group)
				var/found
				for(var/E in join_carefully)
					found = locate(E) in adj
					if(found) break
				if(found)
					join_flags |= flag      // turn on the bit flag
					return

		var/always_found
		for(var/E in join_always)
			always_found = locate(E) in adj
			if(always_found) break
		if(always_found)
			join_flags |= flag      // turn on the bit flag
		else
			join_flags &= ~flag     // turn off the bit flag

/turf/simulated/shuttle/wall/voidcraft
	name = "voidcraft wall"
	icon = 'icons/turf/shuttle_void.dmi'
	icon_state = "void"
	base_state = "void"
	var/stripe_color = null // If set, generates a colored stripe overlay.  Accepts #XXXXXX as input.

/turf/simulated/shuttle/wall/voidcraft/hard_corner
	name = "hardcorner wall"
	icon_state = "void-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/voidcraft/no_join
	name = "nojoin wall"
	icon_state = "void-nj"
	join_group = null

/turf/simulated/shuttle/wall/voidcraft/red
	stripe_color = "#FF0000"

/turf/simulated/shuttle/wall/voidcraft/blue
	stripe_color = "#0000FF"

/turf/simulated/shuttle/wall/voidcraft/green
	stripe_color = "#00FF00"

/turf/simulated/shuttle/wall/voidcraft/Initialize()
	. = ..()
	update_icon()

/turf/simulated/shuttle/wall/voidcraft/update_icon()
	if(stripe_color)
		cut_overlays()
		var/image/I = image(icon = src.icon, icon_state = "o_[icon_state]")
		I.color = stripe_color
		add_overlay(I)

// Fake corners for making hulls look pretty
/obj/structure/hull_corner
	name = "hull corner"

	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "hull_corner"

	anchored = TRUE
	density = TRUE
	breakable = TRUE

/obj/structure/hull_corner/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/hull_corner/LateInitialize()
	. = ..()
	update_look()

/obj/structure/hull_corner/proc/get_dirs_to_test()
	return list(dir, turn(dir,90))

/obj/structure/hull_corner/proc/update_look()
	cut_overlays()

	var/turf/simulated/wall/T
	for(var/direction in get_dirs_to_test())
		T = get_step(src, direction)
		if(!istype(T))
			continue

		name = T.name
		desc = T.desc

		var/datum/material/B = T.material
		var/datum/material/R = T.reinf_material

		if(B?.icon_colour)
			color = B.icon_colour
		if(R?.icon_colour)
			var/image/I = image(icon, icon_state+"_reinf", dir=dir)
			I.color = R.icon_colour
			add_overlay(I)
		break

	if(!T)
		warning("Hull corner at [x],[y] not placed adjacent to a hull it can find.")

/obj/structure/hull_corner/long_vert
	icon = 'icons/turf/wall_masks32x64.dmi'
	bound_height = 64

/obj/structure/hull_corner/long_vert/get_dirs_to_test()
	return list(dir, turn(dir,90), turn(dir,-90))

/obj/structure/hull_corner/long_horiz
	icon = 'icons/turf/wall_masks64x32.dmi'
	bound_width = 64

/obj/structure/hull_corner/long_horiz/get_dirs_to_test()
	return list(dir, turn(dir,90), turn(dir,-90))
