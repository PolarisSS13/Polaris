/obj/item/gun_component/barrel/laser/magic
	name = "wand fragment"
	caliber = CALIBER_STAFF_CHANGE
	weapon_type = null
	var/magic_model = /decl/weapon_model/magic

/obj/item/gun_component/barrel/laser/magic/New(var/newloc, var/weapontype, var/componenttype, var/use_model)
	..(newloc, weapontype, componenttype, magic_model)

/obj/item/gun_component/barrel/laser/magic/update_from_caliber()
	caliber = initial(caliber)
	..()

/obj/item/gun_component/barrel/laser/magic/animate
	caliber = CALIBER_STAFF_ANIMATE
	magic_model = /decl/weapon_model/magic/animate

/obj/item/gun_component/barrel/laser/magic/force
	caliber = CALIBER_STAFF_FORCE
	magic_model = /decl/weapon_model/magic/force
