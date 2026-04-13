/datum/design/item/mechfab/trueexo/sleek
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_DATA = 4, TECH_BIO = 3)
	materials = list(MAT_STEEL = 5500, MAT_COPPER = 1000)

/datum/design/item/mechfab/trueexo/sleek/chassis
	name = "sleek Chassis"
	id = "exosuit_sleek_chassis"
	build_path = /obj/item/mech_component/chassis/sleek
	materials = list(MAT_STEEL = 7600, MAT_COPPER = 2000)

/datum/design/item/mechfab/trueexo/sleek/arms
	name = "sleek Arms"
	id = "exosuit_sleek_arms"
	build_path = /obj/item/mech_component/manipulators/sleek

/datum/design/item/mechfab/trueexo/sleek/legs
	name = "sleek Legs"
	id = "exosuit_sleek_legs"
	build_path = /obj/item/mech_component/propulsion/sleek

/datum/design/item/mechfab/trueexo/sleek/head
	name = "sleek Head"
	id = "exosuit_sleek_head"
	build_path = /obj/item/mech_component/sensors/sleek
