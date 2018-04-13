/mob/living/simple_mob/mechanical
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

/mob/living/simple_mob/mechanical/isSynthetic()
	return TRUE

/mob/living/simple_mob/mechanical/speech_bubble_appearance()
	return faction != "neutral" ? "synthetic_evil" : "machine"