
/datum/design/item/mechfab/trueexo/equip/utility
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2)

/datum/design/item/mechfab/trueexo/equip/utility/drill
	name = "Exosuit Drill"
	id = "exosuit_tool_drill"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(MAT_STEEL = 7500)
	build_path = /obj/item/mech_equipment/drill

/datum/design/item/mechfab/trueexo/equip/utility/gravipult
	name = "Exosuit Gravipult"
	id = "exosuit_tool_gravipult"
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 7500, MAT_PHORON = 4000)
	build_path = /obj/item/mech_equipment/catapult

/datum/design/item/mechfab/trueexo/equip/utility/light
	name = "Exosuit Floodlight"
	id = "exosuit_tool_light"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(MAT_ALUMINIUM = 7000, MAT_GLASS = 2000)
	build_path = /obj/item/mech_equipment/light

/datum/design/item/mechfab/trueexo/equip/utility/clamp
	name = "Exosuit Clamp"
	id = "exosuit_tool_clamp"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(MAT_STEEL = 7500)
	build_path = /obj/item/mech_equipment/clamp
