/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"

/turf/unsimulated/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"

/turf/unsimulated/floor/void
	name = "black void"
	desc = "You're not sure if this void is looking back at you."
	icon_state = "void_floor" // It has an icon for the map editor. In-game its a literal black void.
	initialized = FALSE // We want this to Initialize().
	block_tele = TRUE // Just in case.

/turf/unsimulated/floor/void/Initialize()
	alpha = 0
	return ..()