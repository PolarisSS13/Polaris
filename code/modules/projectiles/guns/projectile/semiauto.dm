/obj/item/weapon/gun/projectile/garand
	name = "semi-automatic rifle"
	desc = "A vintage styled frontier rifle by Hedberg-Hammarstrom. The distinctive 'ping' is considered traditional, though its origins are much debated.. Uses 7.62mm rounds."
	description_fluff = "Sif’s largest home-grown firearms manufacturer, the Hedberg-Hammarstrom company offers a range of high-quality, high-cost hunting rifles and shotguns designed with the Sivian wilderness - and its wildlife - in mind. \
	The company operates just one production plant in Kalmar, but their weapons have found popularity on garden worlds as far afield as the Tajaran homeworld due to their excellent build quality, \
	precision, and stopping power."
	icon_state = "garand"
	item_state = "boltaction"
	w_class = ITEMSIZE_LARGE
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	//fire_sound = 'sound/weapons/rifleshot.ogg'
	load_method = MAGAZINE // ToDo: Make it so MAGAZINE, SPEEDLOADER and SINGLE_CASING can all be used on the same gun.
	magazine_type = /obj/item/ammo_magazine/m762garand
	allowed_magazines = list(/obj/item/ammo_magazine/m762garand)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/garand_ping.ogg'

/obj/item/weapon/gun/projectile/garand/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"
