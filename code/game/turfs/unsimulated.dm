/turf/unsimulated
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	initialized = TRUE // Don't call init on unsimulated turfs (at least not yet)

// Better nip this just in case.
/turf/unsimulated/rcd_values(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	return FALSE

/turf/unsimulated/rcd_act(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	return FALSE