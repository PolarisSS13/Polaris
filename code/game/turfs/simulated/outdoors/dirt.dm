/turf/simulated/floor/outdoors/dirt
	name = "dirt"
	desc = "Quite dirty!"
	icon_state = "dirt-dark"
	edge_blending_priority = 2
	turf_layers = list(/turf/simulated/floor/outdoors/rocks)
	initial_flooring = /decl/flooring/dirt
	can_dig = TRUE

/turf/simulated/floor/outdoors/newdirt
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "dirt0"
	edge_blending_priority = 2
	initial_flooring = /decl/flooring/outdoors/newdirt
	can_dig = TRUE
	var/possibledirts = list(
		"dirt0" = 150,
		"dirt1" = 25,
		"dirt2" = 25,
		"dirt3" = 10,
		"dirt4" = 3,
		"dirt5" = 3,
		"dirt6" = 1,
		"dirt7" = 25,
		"dirt8" = 10,
		"dirt9" = 25
	)

/decl/flooring/outdoors/newdirt
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "dirt0"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg',
		'sound/effects/footstep/MedDirt1.ogg',
		'sound/effects/footstep/MedDirt2.ogg',
		'sound/effects/footstep/MedDirt3.ogg',
		'sound/effects/footstep/MedDirt4.ogg'))

/turf/simulated/floor/outdoors/newdirt/Initialize(mapload)
	flooring_override = pickweight(possibledirts)
	return ..()


/turf/simulated/floor/outdoors/newdirt_nograss
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "dirt0"
	edge_blending_priority = 2
	initial_flooring = /decl/flooring/outdoors/newdirt
	var/possibledirts = list(
		"dirt0" = 200,
		"dirt3" = 20,
		"dirt4" = 3,
		"dirt5" = 3,
		"dirt6" = 1
	)

/turf/simulated/floor/outdoors/newdirt_nograss/Initialize(mapload)
	flooring_override = pickweight(possibledirts)
	return ..()

/turf/simulated/floor/outdoors/sidewalk
	name = "sidewalk"
	desc = "Concrete shaped into a path!"
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "sidewalk"
	edge_blending_priority = 1
	movement_cost = -0.5
	initial_flooring = /decl/flooring/outdoors/sidewalk
	var/possibledirts = list(
		"" = 150,
		"1" = 3,
		"2" = 3,
		"3" = 3,
		"4" = 3,
		"5" = 3,
		"6" = 2,
		"7" = 2,
		"8" = 2,
		"9" = 2,
		"10" = 2
	)

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
	flooring_override = "[initial(icon_state)][pickweight(possibledirts)]"
	return ..()

/turf/simulated/floor/outdoors/sidewalk/side
	icon_state = "side-walk"

/turf/simulated/floor/outdoors/sidewalk/slab
	icon_state = "slab"