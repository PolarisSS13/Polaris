/datum/design/item/mechfab/trueexo/light
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_DATA = 4, TECH_BIO = 2)
	materials = list(MAT_STEEL = 5500, MAT_COPPER = 1000)

/datum/design/item/mechfab/trueexo/light/chassis
	name = "Light Chassis"
	id = "exosuit_light_chassis"
	build_path = /obj/item/mech_component/chassis/light
	materials = list(MAT_STEEL = 7600, MAT_COPPER = 2000)

/datum/design/item/mechfab/trueexo/light/arms
	name = "Light Arms"
	id = "exosuit_light_arms"
	build_path = /obj/item/mech_component/manipulators/light

/datum/design/item/mechfab/trueexo/light/legs
	name = "Light Legs"
	id = "exosuit_light_legs"
	build_path = /obj/item/mech_component/propulsion/light

/datum/design/item/mechfab/trueexo/light/head
	name = "Light Head"
	id = "exosuit_light_head"
	build_path = /obj/item/mech_component/sensors/light
