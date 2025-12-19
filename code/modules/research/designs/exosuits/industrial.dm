/datum/design/item/mechfab/trueexo/industrial
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_DATA = 4)
	materials = list(MAT_STEEL = 7500, MAT_COPPER = 1500)

/datum/design/item/mechfab/trueexo/industrial/chassis
	name = "Industrial Chassis"
	id = "exosuit_industrial_chassis"
	build_path = /obj/item/mech_component/chassis/industrial
	materials = list(MAT_STEEL = 10000, MAT_COPPER = 2500)

/datum/design/item/mechfab/trueexo/industrial/arms
	name = "Industrial Arms"
	id = "exosuit_industrial_arms"
	build_path = /obj/item/mech_component/manipulators/industrial

/datum/design/item/mechfab/trueexo/industrial/legs
	name = "Industrial Legs"
	id = "exosuit_industrial_legs"
	build_path = /obj/item/mech_component/propulsion/industrial

/datum/design/item/mechfab/trueexo/industrial/head
	name = "Industrial Head"
	id = "exosuit_industrial_head"
	build_path = /obj/item/mech_component/sensors/industrial
