/obj/item/weapon/csi_marker
	name = "crime scene marker"
	desc = "Plastic cards used to mark points of interests on the scene. Just like in the holoshows!"
	icon = 'icons/obj/forensics.dmi'
	icon_state = "card1"
	w_class = ITEMSIZE_TINY
	layer = ABOVE_MOB_LAYER  //so you can mark bodies
	var/number = 1

/obj/item/weapon/csi_marker/initialize(mapload)
	. = ..()
	desc += " This one is marked with [number]"
	update_icon()

/obj/item/weapon/csi_marker/update_icon()
	icon_state = "card[Clamp(number,1,7)]"

/obj/item/weapon/csi_marker/n1
	number = 1
/obj/item/weapon/csi_marker/n2
	number = 2
/obj/item/weapon/csi_marker/n3
	number = 3
/obj/item/weapon/csi_marker/n4
	number = 4
/obj/item/weapon/csi_marker/n5
	number = 5
/obj/item/weapon/csi_marker/n6
	number = 6
/obj/item/weapon/csi_marker/n7
	number = 7