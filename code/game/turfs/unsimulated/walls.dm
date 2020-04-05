/turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1
	blocks_air = TRUE

/turf/unsimulated/wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = 0

/turf/unsimulated/wall/other
	icon_state = "r_wall"

/turf/unsimulated/wall/void
	name = "black void"
	desc = "You're not sure if this void is looking back at you."
	icon_state = "void_wall" // It has an icon for the map editor. In-game its a literal black void.
	initialized = FALSE // We want this to Initialize().
	block_tele = TRUE // Just in case.

/turf/unsimulated/wall/void/Initialize()
	alpha = 0
	return ..()