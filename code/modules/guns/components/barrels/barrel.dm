/obj/item/gun_component/barrel
	name = "barrel"
	component_type = COMPONENT_BARREL
	projectile_type = GUN_TYPE_BALLISTIC
	weapon_type = null
	pixel_y = 6

	var/recoil_mod = 0
	var/caliber
	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/variable_projectile = 1
	var/override_name
	var/list/firemodes

/obj/item/gun_component/barrel/update_strings()
	..()
	if(model && model.produced_by.manufacturer_short != "unbranded")
		name = "[model.produced_by.manufacturer_short] [override_name ? override_name : caliber] [weapon_type] [initial(name)]"
	else
		name = "[override_name ? override_name : caliber] [weapon_type] [initial(name)]"

/obj/item/gun_component/barrel/proc/get_projectile_type()
	return

/obj/item/gun_component/barrel/proc/update_from_caliber()
	return
