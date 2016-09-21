/obj/item/weapon/ball/football
	name = "football"
	desc = "A football."
	icon = 'icons/obj/sports.dmi'
	icon_state = "football"
	w_class = 2

/obj/item/clothing/suit/armor/football_pads
	name = "football pads"
	desc = "Football pads"
	icon_state = "football_pad"
	armor = list(melee = 15, bullet = 1, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/football_helmet
	name = "football helmet"
	desc = "Football helmet."
	icon_state = "football_helm"
	armor = list(melee = 15, bullet = 1, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/*
	Football Jersey
*/
/obj/item/clothing/accessory/football_jersey
	name = "football jersey"
	desc = "A football jersey."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
		)
	icon_state = "football_jersey"
	item_state = "football_jersey"
	icon_override = 'icons/mob/ties.dmi'
	var/fire_resist = T0C+100
	allowed = list(/obj/item/weapon/tank/emergency_oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = 3
	slot = "over"