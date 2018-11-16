/obj/item/clothing/suit/bio_suit/anomaly
	name = "Anomaly suit"
	desc = "A sealed bio suit capable of insulating against exotic alien energies."
	icon = 'icons/obj/clothing/spacesuits.dmi'
	icon_state = "engspace_suit"
	item_state = "engspace_suit"
	update_icon_define = "icons/mob/spacesuit.dmi"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 100)

/obj/item/clothing/head/bio_hood/anomaly
	name = "Anomaly hood"
	desc = "A sealed bio hood capable of insulating against exotic alien energies."
	icon_state = "engspace_helmet"
	item_state = "engspace_helmet"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 100)

/obj/item/clothing/suit/space/anomaly
	name = "Excavation suit"
	desc = "A pressure resistant excavation suit partially capable of insulating against exotic alien energies."
	icon_state = "cespace_suit"
	item_state = "cespace_suit"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	slowdown = 1

/obj/item/clothing/head/helmet/space/anomaly
	name = "Excavation hood"
	desc = "A pressure resistant excavation hood partially capable of insulating against exotic alien energies."
	icon_state = "cespace_helmet"
	item_state = "cespace_helmet"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)

/obj/item/clothing/head/helmet/space/anomalyC
	name = "Hood of Pwnage"
	desc = "A pressure resistant excavation hood partially capable of insulating against exotic alien energies."
	icon_state = "cespace_helmetC"
	item_state = "cespace_helmetC"
	armor = list(melee = 30, bullet = 35, laser = 20,energy = 38, bomb = 5, bio = 100, rad = 100)