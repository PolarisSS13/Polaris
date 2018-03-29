/obj/item/clothing/head/helmet/space/void/vanax
	name = "\improper Hegemony livesuit helmet"
	desc = "A Hegemony-designed utilitarian environment suit helmet, still common among the Spacer Vanax."
	icon_state = "vax_hegemony"
	item_state_slots = list(slot_r_hand_str = "syndicate", slot_l_hand_str = "syndicate") //placeholder
	heat_protection = HEAD
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 0) //realistically would have some armor but muhbalance.

	species_restricted = list(SPECIES_VANAX) //todo: make them unretrofitable.

	var/default_flags = HEAD|FACE|EYES //allows for different helmets to cover different parts while still working w/open_food_intake

/obj/item/clothing/head/helmet/space/void/vanax/verb/open_food_intake()

	set name = "Open Food Intake"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.stat) return

	if(body_parts_covered == 0)
		to_chat(H, "You reseal your helmet's food intake.")
		body_parts_covered = default_flags
	else
		to_chat(H, "You unseal your food intake.")
		body_parts_covered = 0

/obj/item/clothing/suit/space/void/vanax
	name = "\improper Hegemony livesuit"
	desc = "A Hegemony environment suit, still favored by the Spacer Vanax because of its durability and ease of manufacture."
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank)
	icon_state = "vax_hegemony"
	helmet = new/obj/item/clothing/head/helmet/space/void/vanax //livesuits come with helmets built-in

	species_restricted = list(SPECIES_VANAX)

	breach_threshold = 12 //concider upping if they die too fast in testing.

/obj/item/clothing/head/helmet/space/void/vanax/engie
	name = "\improper Engineer's Guild livesuit helmet"
	desc = "A livesuit helmet designed for good visibility in low-light environments."
	icon_state = "vax_engie"
	item_state_slots = list(slot_r_hand_str = "eng_helm", slot_l_hand_str = "eng_helm")

/obj/item/clothing/suit/space/void/vanax/engie
	name = "\improper Engineer's Guild livesuit"
	desc = "This rugged livesuit was created by the Engineering Guild."
	icon_state = "vax_engie"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/vanax/engie

/obj/item/clothing/head/helmet/space/void/vanax/spacer
	name = "\improper Spacer's Guild livesuit helmet"
	desc = "A cool plastic-and-glass helmet designed after popular human fiction."
	icon_state = "vax_spacer"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/space/void/vanax/spacer
	name = "\improper Spacer's Guild livesuit"
	desc = "The blue plastic livesuit worn by members of the Vanax Spacer's Guild."
	icon_state = "vax_spacer"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/vanax/spacer

/obj/item/clothing/head/helmet/space/void/vanax/knight
	name = "\improper Knight's livesuit helm"
	desc = "This spaceworthy helmet was patterned after the knight's helmets used by Vanax before their discovery by the Unathi."
	icon_state = "vax_knight"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/space/void/vanax/knight
	name = "\improper Knight's livesuit"
	desc = "This distinctive steel-plated livesuit was popularized by the Breeder's Guild."
	icon_state = "vax_knight"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/vanax/knight

/obj/item/clothing/head/helmet/space/void/vanax/fashion
	name = "\improper Avazi House livesuit helmet"
	desc = "The Avazi Fashion House recently designed this popular livesuit helmet, designed to pleasingly frame a Vanax's face."
	icon_state = "vax_fashion"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/space/void/vanax/fashion
	name = "\improper Avazi House livesuit"
	desc = "The designers of the Avazi Fashion House are among the most renowned in Vanax society, and their livesuit designs second to none."
	icon_state = "vax_fashion"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/vanax/fashion

/obj/item/clothing/head/helmet/space/void/vanax/bishop
	name = "\improper Bishop-patterned livesuit helmet"
	desc = "The livesuit helmet that inspired a dozen lawsuits."
	icon_state = "vax_bishop"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/space/void/vanax/bishop
	name = "\improper Bishop-patterned livesuit"
	desc = "The bold designers of the Dzaz Fashion House chose to make this Bishop-themed livesuit design as a commentary on the symbiotic nature of Vanax and human culture."
	icon_state = "vax_bishop"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/vanax/bishop