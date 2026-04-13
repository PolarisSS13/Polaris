
/datum/design/item/mechfab/trueexo/spine
	name = "Exosuit Spine"
	id = "exosuit_spine"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 120
	materials = list(MAT_STEEL = 10000)

/datum/design/item/mechfab/trueexo/armor/normal
	name = "Standard Exosuit Armor"
	id = "exosuit_armor_norm"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(MAT_STEEL = 7500)

/datum/design/item/mechfab/trueexo/armor/radproof
	name = "Radiation Hardened Exosuit Armor"
	id = "exosuit_armor_rad"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/radproof
	req_tech = list(TECH_MATERIAL = 3, TECH_PHORON = 3)
	materials = list(MAT_STEEL = 5000, MAT_LEAD = 2500)

/datum/design/item/mechfab/trueexo/armor/em
	name = "Ionized Exosuit Armor"
	id = "exosuit_armor_em"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/em
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 5000, MAT_METALHYDROGEN = 2500)

/datum/design/item/mechfab/trueexo/armor/combat
	name = "Combat Exosuit Armor"
	id = "exosuit_armor_combat"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/combat
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5)
	materials = list(MAT_TITANIUM = 5000, MAT_DIAMOND = 3000)
