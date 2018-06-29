/turf/simulated/floor/outdoors/dirt
	name = "dirt"
	desc = "Quite dirty!"
	icon_state = "dirt-dark"
	edge_blending_priority = 2
	turf_layers = list(/turf/simulated/floor/outdoors/rocks)
	initial_flooring = /decl/flooring/dirt
	var/grass_chance = 20
	var/tree_chance = 2
	var/list/grass_types = list(
		/obj/structure/flora/ausbushes/sparsegrass,
		/obj/structure/flora/ausbushes/fullgrass
		)

/turf/simulated/floor/outdoors/dirt/initialize()
	if(prob(50))
		icon_state = "[initial(icon_state)]2"
		//edge_blending_priority++

	if(grass_chance && prob(grass_chance))
		var/grass_type = pick(grass_types)
		new grass_type(src)
	. = ..()
