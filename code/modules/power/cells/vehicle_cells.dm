/obj/item/weapon/cell/car
	name = "basic car battery"
	origin_tech = list(TECH_POWER = 8)
	icon_state = "hpcell"
	maxcharge = 30000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)

/obj/item/weapon/cell/car/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/car/advanced
	name = "advanced car battery"
	origin_tech = list(TECH_POWER = 8)
	icon_state = "hpcell"
	maxcharge = 50000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)

/obj/item/weapon/cell/car/advanced/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/car/high
	name = "high-caliber car battery"
	origin_tech = list(TECH_POWER = 8)
	icon_state = "hpcell"
	maxcharge = 70000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)

/obj/item/weapon/cell/car/high/empty/New()
	..()
	charge = 0