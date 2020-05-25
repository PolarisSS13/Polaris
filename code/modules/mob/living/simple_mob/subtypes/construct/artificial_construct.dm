// Construct class mobs are artificial mobs that are not robotic, or otherwise exist as an electro-mechanical thing.
// As such, they tend to be rather resistant to the elements, even ones robots are weak to, like shock.
// Note, this is NOT related to cult constructs.

/mob/living/simple_mob/artificial_construct
	mob_class = MOB_CLASS_CONSTRUCT
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	taser_kill = FALSE
	poison_resist = 1.0
	heat_resist = 0.75
	shock_resist = 0.75
	cold_resist = 0.75
	thick_armor = TRUE