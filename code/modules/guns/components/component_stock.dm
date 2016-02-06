/obj/item/gun_component/stock
	name = "stock"
	component_type = COMPONENT_STOCK
	w_class = 1
	pixel_y = -9

	var/accuracy_mod = 1
	var/recoil_mod = 1

/obj/item/gun_component/stock/pistol
	weapon_type = GUN_PISTOL
	w_class = 3

/obj/item/gun_component/stock/pistol/small
	name = "small stock"
	w_class = 2

/obj/item/gun_component/stock/smg
	weapon_type = GUN_SMG

/obj/item/gun_component/stock/rifle
	weapon_type = GUN_RIFLE

/obj/item/gun_component/stock/cannon
	weapon_type = GUN_CANNON

/obj/item/gun_component/stock/assault
	weapon_type = GUN_ASSAULT

/obj/item/gun_component/stock/shotgun
	weapon_type = GUN_SHOTGUN

/obj/item/gun_component/stock/pistol/laser
	projectile_type = GUN_TYPE_LASER

/obj/item/gun_component/stock/smg/laser
	projectile_type = GUN_TYPE_LASER

/obj/item/gun_component/stock/rifle/laser
	projectile_type = GUN_TYPE_LASER
	accuracy_mod = -2

/obj/item/gun_component/stock/cannon/laser
	projectile_type = GUN_TYPE_LASER

/obj/item/gun_component/stock/assault/laser
	projectile_type = GUN_TYPE_LASER

/obj/item/gun_component/stock/shotgun/laser
	projectile_type = GUN_TYPE_LASER
