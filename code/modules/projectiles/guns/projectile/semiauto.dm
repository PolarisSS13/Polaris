/obj/item/weapon/gun/projectile/semiauto/garand
	name = "\improper M1 Garand"
	desc = "This is the vintage semi-automatic rifle that famously helped win World War 2. What the hell it's doing aboard a space station in the 26th century, you can only imagine. Uses .30-06 rounds."
	icon_state = "garand"
	item_state = "boltaction" // Placeholder but we'll probably never bother changing this.
	w_class = ITEMSIZE_LARGE
	caliber = ".30-06" // 60 damage, but ammo can't be made in an autolathe.
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/e30_06
	allowed_magazines = list(/obj/item/ammo_magazine/e30_06)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/garand_ping.ogg'

/obj/item/weapon/gun/projectile/semiauto/garand/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"