/decl/flooring/outdoors/sidewalk
	name = "sidewalk"
	desc = "Concrete shaped into a path!"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "sidewalk"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/LightStone1.ogg',
		'sound/effects/footstep/LightStone2.ogg',
		'sound/effects/footstep/LightStone3.ogg',
		'sound/effects/footstep/LightStone4.ogg',))

/turf/simulated/floor/outdoors/sidewalk/Initialize(mapload)
	var/possibledirts = list(
		"[initial(icon_state)]" = 150,
		"[initial(icon_state)]1" = 3,
		"[initial(icon_state)]2" = 3,
		"[initial(icon_state)]3" = 3,
		"[initial(icon_state)]4" = 3,
		"[initial(icon_state)]5" = 3,
		"[initial(icon_state)]6" = 2,
		"[initial(icon_state)]7" = 2,
		"[initial(icon_state)]8" = 2,
		"[initial(icon_state)]9" = 2,
		"[initial(icon_state)]10" = 2
	)
	flooring_override = pickweight(possibledirts)
	return ..()

/turf/simulated/floor/outdoors/sidewalk/side
	icon_state = "side-walk"

/turf/simulated/floor/outdoors/sidewalk/slab
	icon_state = "slab"