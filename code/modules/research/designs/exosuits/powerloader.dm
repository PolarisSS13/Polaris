/datum/design/item/mechfab/trueexo/powerloader
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_DATA = 4)
	materials = list(MAT_STEEL = 7500, MAT_COPPER = 1500)

/datum/design/item/mechfab/trueexo/powerloader/chassis
	name = "Powerloader Chassis"
	id = "exosuit_powerloader_chassis"
	build_path = /obj/item/mech_component/chassis/powerloader
	materials = list(MAT_STEEL = 10000, MAT_COPPER = 2500)

/datum/design/item/mechfab/trueexo/powerloader/arms
	name = "Powerloader Arms"
	id = "exosuit_powerloader_arms"
	build_path = /obj/item/mech_component/manipulators/powerloader

/datum/design/item/mechfab/trueexo/powerloader/legs
	name = "Powerloader Legs"
	id = "exosuit_powerloader_legs"
	build_path = /obj/item/mech_component/propulsion/powerloader

/datum/design/item/mechfab/trueexo/powerloader/head
	name = "Powerloader Head"
	id = "exosuit_powerloader_head"
	build_path = /obj/item/mech_component/sensors/powerloader
