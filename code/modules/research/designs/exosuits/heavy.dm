/datum/design/item/mechfab/trueexo/heavyhead
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_COMBAT = 3, TECH_DATA = 4)
	materials = list(MAT_TITANIUM = 5000, MAT_PLASTEEL = 2500, MAT_COPPER = 2000)

/datum/design/item/mechfab/trueexo/heavy/chassis
	name = "heavy Chassis"
	id = "exosuit_heavy_chassis"
	build_path = /obj/item/mech_component/chassis/heavy
	materials = list(MAT_TITANIUM = 10000, MAT_PLASTEEL = 5000, MAT_COPPER = 2500)

/datum/design/item/mechfab/trueexo/heavy/arms
	name = "heavy Arms"
	id = "exosuit_heavy_arms"
	build_path = /obj/item/mech_component/manipulators/heavy

/datum/design/item/mechfab/trueexo/heavy/legs
	name = "heavy Legs"
	id = "exosuit_heavy_legs"
	build_path = /obj/item/mech_component/propulsion/heavy

/datum/design/item/mechfab/trueexo/heavy/head
	name = "heavy Head"
	id = "exosuit_heavy_head"
	build_path = /obj/item/mech_component/sensors/heavy
