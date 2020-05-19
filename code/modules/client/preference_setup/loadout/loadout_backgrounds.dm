/datum/gear/background
	display_name = "background item"
	slot = slot_tie
	sort_category = "Background"
	type_category = /datum/gear/background
	path = /obj/item/clothing/accessory
	cost = null

/datum/gear/background/pistol
	display_name = "compact pistol"
	slot = slot_in_backpack
	path = /obj/item/weapon/gun/projectile/pistol
	allowed_backgrounds = list(SUBSPECIES_DRONE_X, SUBSPECIES_DRONE_EMERGENT)
	cost = 3
