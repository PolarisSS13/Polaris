/turf/simulated/floor/pavement
	name = "Pavement"
	desc = "It's a pavement" //I think I need a better description.
	icon = 'icons/turf/pavement.dmi'
	icon_state = "pavement"

/turf/simulated/floor/pavement/empty
	icon_state = "pave_empty"
	dir = 2

/turf/simulated/floor/pavement/corner
	icon_state = "pave_corner"

/turf/simulated/floor/pavement/corner_invert
	icon_state = "pave_invert_corner"

//| Stairs
	// - default is South, in terms of being at the top of the stairs looking down.
/turf/simulated/floor/stairs/
	name = "stairs"
	icon = 'icons/turf/ramps.dmi'
	icon_state = "ramptop"
/turf/simulated/floor/stairs/north
	dir = 1
	icon_state = "ramptop"
/turf/simulated/floor/stairs/east
	dir = 4
	icon_state = "ramptop"
/turf/simulated/floor/stairs/west
	dir = 8
	icon_state = "ramptop"

/turf/simulated/floor/stairs/stairsdark/
	icon_state = "rampbottom"
/turf/simulated/floor/stairs/stairsdark/north
	dir = 1
	icon_state = "rampbottom"
/turf/simulated/floor/stairs/stairsdark/east
	dir = 4
	icon_state = "rampbottom"
/turf/simulated/floor/stairs/stairsdark/west
	dir = 8
	icon_state = "rampbottom"

/turf/simulated/floor/road
	name = "Road"
	desc = "It's a road"
	icon = 'icons/turf/roads.dmi'
	icon_state = "road"

/turf/simulated/floor/road/empty
	icon_state = "road_empty"

/turf/simulated/floor/road/corner
	icon_state = "road_corner"

/turf/simulated/floor/road/markings
	icon_state = "road_marking"



