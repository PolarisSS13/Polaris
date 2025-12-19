/datum/design/item/mechfab/trueexo/modern
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_COMBAT = 4, TECH_DATA = 4)
	materials = list(MAT_PLASTEEL = 7500, MAT_COPPER = 1500)

/datum/design/item/mechfab/trueexo/modern/chassis
	name = "Modern Chassis"
	id = "exosuit_modern_chassis"
	build_path = /obj/item/mech_component/chassis/modern
	materials = list(MAT_PLASTEEL = 10000, MAT_COPPER = 2500)

/datum/design/item/mechfab/trueexo/modern/arms
	name = "Modern Arms"
	id = "exosuit_modern_arms"
	build_path = /obj/item/mech_component/manipulators/modern

/datum/design/item/mechfab/trueexo/modern/legs
	name = "Modern Legs"
	id = "exosuit_modern_legs"
	build_path = /obj/item/mech_component/propulsion/modern

/datum/design/item/mechfab/trueexo/modern/head
	name = "Modern Head"
	id = "exosuit_modern_head"
	build_path = /obj/item/mech_component/sensors/modern
