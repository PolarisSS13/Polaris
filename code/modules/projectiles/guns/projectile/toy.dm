/*
 * Contains all the code relating to Toy Guns
 */


/*
 * Shotgun
 */
/obj/item/weapon/gun/projectile/shotgun/pump/toy
	name = "shotgun"
	desc = "TBD"
	description_fluff = "TBD"
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 6
	w_class = ITEMSIZE_LARGE
	force = 2
	slot_flags = SLOT_BACK
	caliber = "foam"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/afoam_dart
	projectile_type = /obj/item/projectile/bullet/foam_dart
	handle_casings = HOLD_CASINGS
