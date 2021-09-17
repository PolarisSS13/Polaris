/*
 * All the code relating to Toy Guns
 *
 *	Contains:
 *	-Shotgun
 *	-Pistol
 *	-N99 Pistol
 *	-Levergun
 *	-Revolver
 *	-Big Iron
 *	-Crossbow
 *	-SMG
 *
 */


/*
 * Shotgun
 */
/obj/item/weapon/gun/projectile/shotgun/pump/toy
	name = "\improper Donk-Soft shotgun"
	desc = "Donk-Soft foam shotgun! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 6
	w_class = ITEMSIZE_LARGE
	force = 2
	slot_flags = null
	caliber = "foam"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/afoam_dart
	projectile_type = /obj/item/projectile/bullet/foam_dart
	handle_casings = HOLD_CASINGS
	matter = list(MAT_PLASTIC = 2000)

/*
 * Pistol
 */
/obj/item/weapon/gun/projectile/pistol/toy
	name = "\improper Donk-Soft pistol"
	desc = "Donk-Soft foam pistol! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "pistol"
	item_state = "gun"
	magazine_type = /obj/item/ammo_magazine/mfoam_dart/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam_dart/pistol)
	projectile_type = /obj/item/projectile/bullet/foam_dart
	caliber = "foam"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = MAGAZINE
	matter = list(MAT_PLASTIC = 1000)

/obj/item/weapon/gun/projectile/pistol/toy/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"

/*
 * N99 Pistol
 */
/obj/item/weapon/gun/projectile/pistol/toy/n99
	name = "\improper Donk-Soft commemorative pistol"
	desc = "A commemorative Donk-Soft pistol made special to promote 'Remnants' a popular apocolyptic TV series."
	icon_state = "n99"
	item_state = "gun"
	caliber = "foam"
	load_method = MAGAZINE
	matter = list(MAT_PLASTIC = 1000)

/obj/item/weapon/gun/projectile/pistol/toy/n99/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"

/*
 * Levergun
 */
/obj/item/weapon/gun/projectile/shotgun/pump/toy/levergun
	name = "\improper Donk-Soft levergun"
	desc = "Donk-Soft foam levergun! Time to cowboy up! Ages 8 and up."
	icon_state = "leveraction"
	item_state = "leveraction"
	max_shells = 6
	pump_animation = "leveraction-cycling"

/*
 * Revolver
 */
/obj/item/weapon/gun/projectile/revolver/toy
	name = "\improper Donk-Soft revolver"
	desc = "Donk-Soft foam revolver! Time to cowboy up! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	caliber = "foam"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/afoam_dart
	projectile_type = /obj/item/projectile/bullet/foam_dart
	matter = list(MAT_PLASTIC = 1000)

/*
 * Big Iron
 */
/obj/item/weapon/gun/projectile/revolver/toy
	name = "\improper Donk-Soft big iron"
	desc = "A Donk-Soft pistol made special to promote 'A Fistful of Phoron' a popular frontier comic book."
	icon_state = "big_iron"
	item_state = "revolver"
	caliber = "foam"

/*
 * Crossbow
 */
/obj/item/weapon/gun/projectile/pistol/toy/crossbow
	name = "\improper Donk-Soft crossbow"
	desc = "Donk-Soft foam pistol! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "foamcrossbow"
	item_state = "foamcrossbow"
	projectile_type = /obj/item/projectile/bullet/foam_dart
	caliber = "foam"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = SINGLE_CASING
	max_shells = 5
	matter = list(MAT_PLASTIC = 1000)

/*
 * SMG
 */
/obj/item/weapon/gun/projectile/automatic/toy
	name = "\improper Donk-Soft SMG"
	desc = "Donk-Soft foam SMG! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "smg"
	caliber = "foam"
	w_class = ITEMSIZE_NORMAL
	load_method = MAGAZINE
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	slot_flags = SLOT_BELT
	magazine_type = /obj/item/ammo_magazine/mfoam_dart/smg
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam_dart/smg)
	projectile_type = /obj/item/projectile/bullet/foam_dart
	matter = list(MAT_PLASTIC = 1000)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=2,    burst_accuracy=list(0,-5,-5), dispersion=list(0.0, 0.1, 0.3))
	)