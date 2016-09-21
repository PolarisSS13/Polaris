/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 20
	category = /datum/uplink_category/ammunition
	blacklisted = 1

/datum/uplink_item/item/ammo/a357
	name = ".357 Speedloader"
	path = /obj/item/ammo_magazine/a357

/datum/uplink_item/item/ammo/mc9mm
	name = "Pistol Magazine (9mm)"
	path = /obj/item/ammo_magazine/mc9mm

/datum/uplink_item/item/ammo/c45m
	name = "Pistol Magazine (.45)"
	path = /obj/item/ammo_magazine/c45m

/datum/uplink_item/item/ammo/tommymag
	name = "Tommygun Magazine (.45)"
	path = /obj/item/ammo_magazine/tommymag

/datum/uplink_item/item/ammo/tommydrum
	name = "Tommygun Drum Magazine (.45)"
	path = /obj/item/ammo_magazine/tommydrum
	item_cost = 40 // Buy 40 bullets, get 10 free!

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	path = /obj/item/ammo_magazine/chemdart
	item_cost = 5

/datum/uplink_item/item/ammo/sniperammo
	name = "Anti-Materiel Rifle ammo box (14.5mm)"
	path = /obj/item/weapon/storage/box/sniperammo

/datum/uplink_item/item/ammo/a556
	name = "10rnd Rifle Magazine (5.56mm)"
	path = /obj/item/ammo_magazine/a556

/datum/uplink_item/item/ammo/a556/ap
	name = "10rnd Rifle Magazine (5.56mm AP)"
	path = /obj/item/ammo_magazine/a556/ap

/datum/uplink_item/item/ammo/c762
	name = "20rnd Rifle Magazine (7.62mm)"
	path = /obj/item/ammo_magazine/c762

/datum/uplink_item/item/ammo/c762/ap
	name = "20rnd Rifle Magazine (7.62mm AP)"
	path = /obj/item/ammo_magazine/c762/ap

/datum/uplink_item/item/ammo/s762
	name = "10rnd Rifle Magazine (7.62mm)"
	path = /obj/item/ammo_magazine/s762
	item_cost = 10 // Half the capacity.

/datum/uplink_item/item/ammo/s762/ap
	name = "10rnd Rifle Magazine (7.62mm AP)"
	path = /obj/item/ammo_magazine/s762/ap

/datum/uplink_item/item/ammo/a10mm
	name = "SMG Magazine (10mm)"
	path = /obj/item/ammo_magazine/a10mm

/datum/uplink_item/item/ammo/a762
	name = "Machinegun Magazine (7.62mm)"
	path = /obj/item/ammo_magazine/a762

/datum/uplink_item/item/ammo/a762/ap
	name = "Machinegun Magazine (7.62mm AP)"
	path = /obj/item/ammo_magazine/a762/ap

/datum/uplink_item/item/ammo/g12
	name = "12g Shotgun Box Magazine (Slug)"
	path = /obj/item/weapon/storage/box/shotgunammo/large

/datum/uplink_item/item/ammo/g12/pellet
	name = "12g Auto-Shotgun Magazine (Pellet)"
	path = /obj/item/weapon/storage/box/shotgunshells/large

/datum/uplink_item/item/ammo/g12/beanbag
	name = "12g Shotgun Box (Beanbag)"
	path = /obj/item/weapon/storage/box/beanbags/large
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/g12/stun
	name = "12g Shotgun Box Magazine (Stun)"
	path = /obj/item/weapon/storage/box/stunshells/large
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/g12/flash
	name = "12g Shotgun Box Magazine (Flash)"
	path = /obj/item/weapon/storage/box/flashshells/large
	item_cost = 10 // Discount due to it being LTL.