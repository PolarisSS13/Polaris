/obj/item/binoculars
	name = "binoculars"
	desc = "A pair of binoculars."
	icon_state = "binoculars"
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

	//matter = list("metal" = 50,"glass" = 50)


/obj/item/binoculars/attack_self(mob/user)
	zoom()
