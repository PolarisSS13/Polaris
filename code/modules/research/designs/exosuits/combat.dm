/datum/design/item/mechfab/trueexo/combat
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_COMBAT = 5, TECH_DATA = 4)
	materials = list(MAT_PLASTEEL = 7500, MAT_COPPER = 1500)

/datum/design/item/mechfab/trueexo/combat/chassis
	name = "Combat Chassis"
	id = "exosuit_combat_chassis"
	build_path = /obj/item/mech_component/chassis/combat
	materials = list(MAT_PLASTEEL = 10000, MAT_COPPER = 2500)

/datum/design/item/mechfab/trueexo/combat/arms
	name = "Combat Arms"
	id = "exosuit_combat_arms"
	build_path = /obj/item/mech_component/manipulators/combat

/datum/design/item/mechfab/trueexo/combat/legs
	name = "Combat Legs"
	id = "exosuit_combat_legs"
	build_path = /obj/item/mech_component/propulsion/combat

/datum/design/item/mechfab/trueexo/combat/head
	name = "Combat Head"
	id = "exosuit_combat_head"
	build_path = /obj/item/mech_component/sensors/combat
