
/datum/design/item/mechfab/trueexo/equip/melee
	req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 2)

/datum/design/item/mechfab/trueexo/equip/melee/mechete
	name = "Exosuit Machete"
	id = "exosuit_weapon_mechete"
	materials = list(MAT_STEEL = 8000, MAT_ALUMINIUM = 3000)
	build_path = /obj/item/mech_equipment/mounted_system/melee/mechete

/datum/design/item/mechfab/trueexo/equip/melee/mechete/durasteel
	name = "Durasteel Exosuit Machete"
	id = "exosuit_weapon_durasteel_mechete"
	materials = list(MAT_TITANIUM = 5000, MAT_DURASTEEL = 6000)
	build_path = /obj/item/mech_equipment/mounted_system/melee/mechete/durasteel

/datum/design/item/mechfab/trueexo/equip/melee/flash
	name = "Exosuit H.I. Flash"
	id = "exosuit_weapon_flash"
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/mech_equipment/flash
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 3, TECH_MAGNET = 4)
