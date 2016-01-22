/obj/item/weapon/gun/composite/premade
	var/build_components = list()
	var/set_model

/obj/item/weapon/gun/composite/premade/New()
	for(var/build_path in build_components)
		new build_path(src, null, null, set_model)
	barrel =  locate(/obj/item/gun_component/barrel)  in contents
	body =    locate(/obj/item/gun_component/body)    in contents
	grip =    locate(/obj/item/gun_component/grip)    in contents
	stock =   locate(/obj/item/gun_component/stock)   in contents
	chamber = locate(/obj/item/gun_component/chamber) in contents
	accessories.Cut()
	for(var/obj/item/gun_component/accessory/acc in contents)
		accessories += acc
	update_from_components()
	..()
