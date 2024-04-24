/datum/design/item/mechfab/trueexo/mercenaryhead
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_COMBAT = 3, TECH_DATA = 4)
	materials = list(MAT_TITANIUM = 5000, MAT_PLASTEEL = 2500, MAT_COPPER = 2000)

/datum/design/item/mechfab/trueexo/mercenary/chassis
	name = "mercenary Chassis"
	id = "exosuit_mercenary_chassis"
	build_path = /obj/item/mech_component/chassis/mercenary
	materials = list(MAT_TITANIUM = 10000, MAT_PLASTEEL = 5000, MAT_COPPER = 2500)

/datum/design/item/mechfab/trueexo/mercenary/arms
	name = "mercenary Arms"
	id = "exosuit_mercenary_arms"
	build_path = /obj/item/mech_component/manipulators/mercenary

/datum/design/item/mechfab/trueexo/mercenary/legs
	name = "mercenary Legs"
	id = "exosuit_mercenary_legs"
	build_path = /obj/item/mech_component/propulsion/mercenary

/datum/design/item/mechfab/trueexo/mercenary/head
	name = "mercenary Head"
	id = "exosuit_mercenary_head"
	build_path = /obj/item/mech_component/sensors/mercenary
