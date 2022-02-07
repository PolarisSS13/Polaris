/turf/simulated/floor/outdoors/grass
	name = "grass"
	icon_state = "grass0"
	edge_blending_priority = 4
	initial_flooring = /decl/flooring/grass
	can_dig = TRUE
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks,
		/turf/simulated/floor/outdoors/dirt
	)
	var/grass_chance = 0
	var/tree_chance =  0
	var/list/grass_types = list(
		/obj/structure/flora/ausbushes/sparsegrass,
		/obj/structure/flora/ausbushes/fullgrass
	)

/turf/simulated/floor/outdoors/grass/Initialize()
	if(!check_density())
		if(tree_chance && prob(tree_chance))
			new /obj/structure/flora/tree/sif(src)
		else if(grass_chance && prob(grass_chance))
			var/grass_type = pickweight(grass_types)
			new grass_type(src)
	. = ..()

/datum/category_item/catalogue/flora/sif_grass
	name = "Sivian Flora - Moss"
	desc = "A natural moss that has adapted to the sheer cold climate of Sif. \
	The moss came to rely partially on bioluminescent bacteria provided by the local tree populations. \
	As such, the moss often grows in large clusters in the denser forests of Sif. \
	The moss has evolved into it's distinctive blue hue thanks to it's reliance on bacteria that has a similar color."
	value = CATALOGUER_REWARD_TRIVIAL

/turf/simulated/floor/outdoors/grass/sif
	name = "growth"
	icon_state = "grass_sif0"
	initial_flooring = /decl/flooring/grass/sif
	edge_blending_priority = 4
	catalogue_data = list(/datum/category_item/catalogue/flora/sif_grass)
	catalogue_delay = 2 SECONDS

/turf/simulated/floor/outdoors/grass/forest
	name = "thick grass"
	icon_state = "grass-dark0"
	edge_blending_priority = 5

/turf/simulated/floor/outdoors/grass/sif/forest
	name = "thick growth"
	icon_state = "grass_sif_dark0"
	initial_flooring = /decl/flooring/grass/sif/forest
	edge_blending_priority = 5
