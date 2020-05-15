/*
/obj/item
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"


/obj/item/Bump(mob/M as mob)
	spawn(0) //why does it wait 0 seconds before calling return why
		..()
	return

/obj/item/melee
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
			)
*/
