/obj/item/gun_component/body
	name = "body"
	component_type = COMPONENT_BODY
	projectile_type = GUN_TYPE_BALLISTIC
	var/base_desc = "It is an ambiguous firearm of some sort."
	var/two_handed

/obj/item/gun_component/body/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/gun_component))
		var/obj/item/gun_component/GC = thing
		if(GC.component_type == COMPONENT_ACCESSORY)
			user << "<span class='warning'>Accessories can only be installed into gun assemblies or firearms, not into individual components.</span>"
			return
		if(GC.component_type == component_type)
			user << "<span class='warning'>Why are you trying to install one [component_type] into another?</span>"
			return
		var/obj/item/weapon/gun_assembly/GA = new(get_turf(src))
		GA.attackby(src, user)
		GA.attackby(GC, user)
		GA.update_components()
		if(!GA.contents.len)
			qdel(GA)
		return
	..()

/obj/item/gun_component/body/pistol
	weapon_type = GUN_PISTOL
	slot_flags = SLOT_BELT
	w_class = 3
	force = 5
	item_state = "gun"
	base_desc = "It's a pistol."

/obj/item/gun_component/body/pistol/small
	name = "light body"
	force = 2
	w_class = 2
	base_desc = "It's a small pistol."

/obj/item/gun_component/body/pistol/large
	name = "heavy body"
	force = 8
	w_class = 3
	base_desc = "It's a heavy pistol."

/obj/item/gun_component/body/smg
	weapon_type = GUN_SMG
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	force = 7
	item_state = "c20r"
	base_desc = "It's a submachine gun."

/obj/item/gun_component/body/rifle
	weapon_type = GUN_RIFLE
	slot_flags = SLOT_BACK
	w_class = 4
	force = 10
	accepts_accessories = 1
	item_state = "l6closednomag"
	base_desc = "It's a rifle."
	two_handed = 1

/obj/item/gun_component/body/cannon
	weapon_type = GUN_CANNON
	w_class = 5
	force = 8
	slot_flags = 0
	accepts_accessories = 1
	item_state = "riotgun"
	base_desc = "It's a cannon."
	two_handed = 1

/obj/item/gun_component/body/assault
	weapon_type = GUN_ASSAULT
	slot_flags = SLOT_BACK
	w_class = 4
	force = 10
	accepts_accessories = 1
	item_state = "z8carbine"
	base_desc = "It's an assault rifle."
	two_handed = 1

/obj/item/gun_component/body/shotgun
	weapon_type = GUN_SHOTGUN
	slot_flags = SLOT_BACK
	w_class = 4
	force = 10
	accepts_accessories = 1
	item_state = "shotgun"
	base_desc = "It's a shotgun."
	two_handed = 1

/obj/item/gun_component/body/pistol/laser
	projectile_type = GUN_TYPE_LASER
	item_state = "retro"
	base_desc = "It's a laser pistol."

/obj/item/gun_component/body/pistol/large/laser
	projectile_type = GUN_TYPE_LASER

/obj/item/gun_component/body/smg/laser
	projectile_type = GUN_TYPE_LASER
	item_state = "xray"
	base_desc = "It's a heavy laser pistol."

/obj/item/gun_component/body/rifle/laser
	projectile_type = GUN_TYPE_LASER
	item_state = "laser"
	base_desc = "It's a laser rifle."

/obj/item/gun_component/body/cannon/laser
	projectile_type = GUN_TYPE_LASER
	item_state = "lasercannon"
	base_desc = "It's a laser cannon."

/obj/item/gun_component/body/assault/laser
	projectile_type = GUN_TYPE_LASER
	item_state = "laser"
	w_class = 3
	base_desc = "It's a laser assault rifle."

/obj/item/gun_component/body/shotgun/laser
	projectile_type = GUN_TYPE_LASER
	item_state = "pulse"
	base_desc = "It's a laser shotgun."
