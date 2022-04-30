/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	req_one_access = list(access_armory)
	closet_appearance = null

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	cut_overlays()
	var/list/add = list()
	if (!opened)
		var/energy_count = 0
		var/projectile_count = 0
		for (var/obj/item/gun/gun in contents)
			if (istype(gun, /obj/item/gun/energy))
				++energy_count
			else if(istype(gun, /obj/item/gun/projectile))
				++projectile_count
		for (var/i = 0 to 2)
			if (!energy_count && !projectile_count)
				break
			var/image/image = new (icon)
			image.pixel_x = i * 4
			if (energy_count > projectile_count)
				image.icon_state = "laser"
				--energy_count
			else if (projectile_count)
				image.icon_state = "projectile"
				--projectile_count
			add += image
		add += "door"
		if (sealed)
			add += "sealed"
		if (broken)
			add += "broken"
		else if (locked)
			add += "locked"
		else
			add += "open"
	else
		add += "door_open"
	add_overlay(add)
