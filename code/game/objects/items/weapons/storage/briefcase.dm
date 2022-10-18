/obj/item/storage/briefcase
	name = "brown briefcase"
	desc = "It's made of AUTHENTIC faux-leather. Its owner must be a real professional."
	icon_state = "briefcase"
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 4
	use_sound = 'sound/items/storage/briefcase.ogg'
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/storage/briefcase/standard/black
	name = "black briefcase"
	icon_state = "briefcase_black"

/obj/item/storage/briefcase/standard/nt
	name = "branded briefcase"
	desc = "It's made of AUTHENTIC faux-leather and printed with the NanoTrasen logo. Its owner must be a real executive."
	icon_state = "briefcase_nt"


/obj/item/storage/briefcase/standard/alum
	name = "aluminium briefcase"
	desc = "It's made of lightweight but sturdy metal. Its owner might be a real professional of a different kind."
	icon_state = "briefcase_alum"

/obj/item/storage/briefcase/standard/alum/Initialize()
	if(prob(50))
		name = "aluminum briefcase"
	. = ..()

/obj/item/storage/briefcase/clutch
	name = "clutch purse"
	desc = "A fashionable handheld bag."
	icon_state = "clutch"
	item_state_slots = list(slot_r_hand_str = "smpurse", slot_l_hand_str = "smpurse")
	force = 0
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_SMALL
	max_storage_space = ITEMSIZE_COST_SMALL * 4

/obj/item/storage/briefcase/bookbag
	name = "bookbag"
	desc = "A small bookbag for holding... things other than books?"
	icon_state = "bookbag"
	force = 4.0
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 4
