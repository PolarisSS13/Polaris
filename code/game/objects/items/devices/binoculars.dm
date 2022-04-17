
//Binoculars
/obj/item/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	zoomdevicename = "eyepieces"
	icon = 'icons/obj/device.dmi'
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	icon_state = "binoculars"
	force = 5.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

/obj/item/binoculars/attack_self(mob/user)
	zoom()

//Spyglass
/obj/item/binoculars/spyglass
	name = "spyglass"
	desc = "A classic spyglass. Useful for star-gazing, peeping, and recon."
	icon_state = "spyglass"
	slot_flags = SLOT_BELT