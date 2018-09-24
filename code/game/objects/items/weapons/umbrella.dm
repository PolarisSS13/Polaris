/obj/item/weapon/umbrella
	name = "umbrella"
	desc = "To keep the rain off you. Use with caution on windy days."
	icon = 'icons/obj/items.dmi'
	icon_state = "umbrella_closed"
	addblends = "umbrella_closed_a"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	var/open = FALSE

/obj/item/weapon/melee/umbrella/New()
	..()
	update_icon()

/obj/item/weapon/umbrella/attack_self()
	src.toggle_umbrella()

/obj/item/weapon/umbrella/proc/toggle_umbrella()
	open = !open
	icon_state = "umbrella_[open ? "open" : "closed"]"
	addblends = icon_state + "_a"
	item_state = icon_state
	update_icon()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()
	..()

// Randomizes color
/obj/item/weapon/umbrella/random/New()
	color = "#"+get_random_colour()
	..()