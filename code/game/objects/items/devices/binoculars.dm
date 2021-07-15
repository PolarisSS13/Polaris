
//Binoculars
/obj/item/device/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	zoomdevicename = "eyepieces"
	icon_state = "binoculars"

	w_class = ITEM_SIZE_SMALL
	force = 5.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

/obj/item/device/binoculars/attack_self(mob/user)
	zoom()

//Spyglass
/obj/item/device/binoculars/spyglass
	name = "spyglass"
	desc = "A classic spyglass. Useful for star-gazing, peeping, and recon."
	icon_state = "spyglass"
	slot_flags = SLOT_BELT