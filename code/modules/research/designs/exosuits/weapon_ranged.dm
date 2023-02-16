
/datum/design/item/mechfab/trueexo/equip/gun
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 3)

/datum/design/item/mechfab/trueexo/equip/gun/smg
	name = "Exosuit SMG"
	id = "exosuit_weapon_smg"
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/mech_equipment/mounted_system/projectile

/datum/design/item/mechfab/trueexo/equip/gun/smg_ammo
	name = "Exosuit SMG Ammunition"
	id = "exosuit_weapon_smg_ammo"
	materials = list(MAT_STEEL = 4000, MAT_PLASTIC = 500, MAT_GRAPHITE = 500)
	build_path = /obj/item/ammo_magazine/mech/smg_top

/datum/design/item/mechfab/trueexo/equip/gun/rifle
	name = "Exosuit Rifle"
	id = "exosuit_weapon_rifle"
	materials = list(MAT_STEEL = 7000, MAT_GRAPHITE = 1000)
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 4, TECH_MAGNET = 2)
	build_path = /obj/item/mech_equipment/mounted_system/projectile/assault_rifle

/datum/design/item/mechfab/trueexo/equip/gun/rifle_ammo
	name = "Exosuit Rifle Ammunition"
	id = "exosuit_weapon_rifle_ammo"
	materials = list(MAT_STEEL = 4000, MAT_PLASTIC = 500, MAT_GRAPHITE = 500)
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 4, TECH_MAGNET = 2)
	build_path = /obj/item/ammo_magazine/mech/rifle/drum

/datum/design/item/mechfab/trueexo/equip/gun/lmg
	name = "Exosuit LMG"
	id = "exosuit_weapon_lmg"
	materials = list(MAT_STEEL = 7000, MAT_GRAPHITE = 1000)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ILLEGAL = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mech_equipment/mounted_system/projectile/machine

/datum/design/item/mechfab/trueexo/equip/gun/lmg_ammo
	name = "Exosuit LMG Ammunition"
	id = "exosuit_weapon_lmg_ammo"
	materials = list(MAT_PLASTEEL = 4000, MAT_PLASTIC = 500, MAT_GRAPHITE = 500)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ILLEGAL = 2, TECH_MAGNET = 2)
	build_path = /obj/item/ammo_magazine/mech/rifle/drum

/datum/design/item/mechfab/trueexo/equip/gun/taser
	name = "Exosuit Taser Carbine"
	id = "exosuit_weapon_taser"
	materials = list(MAT_ALUMINIUM = 5000, MAT_PLASTIC = 2000)
	build_path = /obj/item/mech_equipment/mounted_system/taser

/datum/design/item/mechfab/trueexo/equip/gun/ion
	name = "Exosuit Ion Rifle"
	id = "exosuit_weapon_ion"
	materials = list(MAT_ALUMINIUM = 5000, MAT_OSMIUM = 1000, MAT_URANIUM = 1000)
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mech_equipment/mounted_system/taser/ion

/datum/design/item/mechfab/trueexo/equip/gun/laser
	name = "Exosuit Laser Rifle"
	id = "exosuit_weapon_laser"
	materials = list(MAT_ALUMINIUM = 5000, MAT_STEEL = 2000)
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 3)
	build_path = /obj/item/mech_equipment/mounted_system/taser/laser
