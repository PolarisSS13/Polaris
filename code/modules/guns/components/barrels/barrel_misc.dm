/obj/item/gun_component/barrel/rifle
	weapon_type = GUN_RIFLE
	caliber = CALIBER_RIFLE_SNIPER
	accepts_accessories = 1

/obj/item/gun_component/barrel/cannon
	weapon_type = GUN_CANNON
	caliber = CALIBER_CANNON

/obj/item/gun_component/barrel/shotgun
	weapon_type = GUN_SHOTGUN
	caliber = CALIBER_SHOTGUN
	accepts_accessories = 1


/obj/item/gun_component/barrel/shotgun/double
	name = "double barrel"
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)