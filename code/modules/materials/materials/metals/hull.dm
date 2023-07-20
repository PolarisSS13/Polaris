/datum/material/steel/hull
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#666677"

/datum/material/steel/hull/get_place_stack_type() //Deconstructed into normal steel sheets.
	return /obj/item/stack/material/steel

/datum/material/plasteel/hull
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#777788"
	explosion_resistance = 40

/datum/material/plasteel/hull/get_place_stack_type() //Deconstructed into normal plasteel sheets.
	return /obj/item/stack/material/plasteel

/datum/material/durasteel/hull //The 'Hardball' of starship hulls.
	name = MAT_DURASTEELHULL
	stack_type = /obj/item/stack/material/durasteel/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/durasteel/hull/get_place_stack_type() //Deconstructed into normal durasteel sheets.
	return /obj/item/stack/material/durasteel

/datum/material/titanium/hull
	name = MAT_TITANIUMHULL
	stack_type = /obj/item/stack/material/titanium/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"

/datum/material/titanium/hull/get_place_stack_type() //Deconstructed into normal titanium sheets.
	return /obj/item/stack/material/titanium

/datum/material/morphium/hull
	name = MAT_MORPHIUMHULL
	stack_type = /obj/item/stack/material/morphium/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"

/datum/material/morphium/hull/get_place_stack_type()
	return /obj/item/stack/material/morphium
