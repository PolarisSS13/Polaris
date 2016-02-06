/obj/item/gun_component/barrel/laser
	projectile_type = GUN_TYPE_LASER
	name = "projector"
	caliber = CALIBER_LASER
	var/assume_projectile

/obj/item/gun_component/barrel/laser/get_projectile_type()
	return assume_projectile

/obj/item/gun_component/barrel/laser/New()
	..()
	update_from_caliber()

/obj/item/gun_component/barrel/laser/update_from_caliber()
	..()
	assume_projectile = get_laser_type_from_caliber(caliber)
	fire_sound = get_fire_sound_from_caliber(caliber)
	if(holder && istype(holder.chamber, /obj/item/gun_component/chamber/laser))
		var/obj/item/gun_component/chamber/laser/echamber = holder.chamber
		echamber.charge_cost = get_laser_cost_from_caliber(caliber)

/obj/item/gun_component/barrel/laser/pistol
	weapon_type = GUN_PISTOL
	caliber = CALIBER_LASER_MID

/obj/item/gun_component/barrel/laser/pistol/taser
	caliber = CALIBER_LASER_SHOCK

/obj/item/gun_component/barrel/laser/smg
	weapon_type = GUN_SMG
	caliber = CALIBER_LASER_WEAK
	accepts_accessories = 1

/obj/item/gun_component/barrel/laser/smg/xray
	caliber = CALIBER_LASER_XRAY

/obj/item/gun_component/barrel/laser/rifle
	weapon_type = GUN_RIFLE
	caliber = CALIBER_LASER_PRECISION
	accepts_accessories = 1

/obj/item/gun_component/barrel/laser/rifle/ion
	caliber = CALIBER_LASER_ION

/obj/item/gun_component/barrel/laser/cannon
	weapon_type = GUN_CANNON
	caliber = CALIBER_LASER_HEAVY

/obj/item/gun_component/barrel/laser/assault
	weapon_type = GUN_ASSAULT
	caliber = CALIBER_LASER_MID
	accepts_accessories = 1

/obj/item/gun_component/barrel/laser/assault/practice
	caliber = CALIBER_LASER_PRACTICE

/obj/item/gun_component/barrel/laser/shotgun
	weapon_type = GUN_SHOTGUN
	caliber = CALIBER_LASER_WEAK
	accepts_accessories = 1

/obj/item/gun_component/barrel/laser/pistol/lasertag
	caliber = CALIBER_LASER_LASERTAG

/obj/item/gun_component/barrel/laser/assault/lasertag
	caliber = CALIBER_LASER_LASERTAG
