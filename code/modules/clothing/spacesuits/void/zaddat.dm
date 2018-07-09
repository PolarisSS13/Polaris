/obj/item/clothing/head/helmet/space/void/zaddat
	name = "\improper Hegemony Shroud helmet"
	desc = "A Hegemony-designed utilitarian environment suit helmet, still common among the Spacer Zaddat."
	icon_state = "vax_hegemony"
	item_state_slots = list(slot_r_hand_str = "syndicate", slot_l_hand_str = "syndicate")
	heat_protection = HEAD
	body_parts_covered = HEAD|FACE|EYES
	slowdown = 0.5
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 0) //realistically would have some armor but balance.

	species_restricted = list(SPECIES_ZADDAT)

/obj/item/clothing/suit/space/void/zaddat
	name = "\improper Hegemony Shroud"
	desc = "A Hegemony environment suit, still favored by the Spacer Zaddat because of its durability and ease of manufacture."
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank)
	icon_state = "vax_hegemony"
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat //shrouds come with helmets built-in

	species_restricted = list(SPECIES_ZADDAT)

	breach_threshold = 12

/obj/item/clothing/head/helmet/space/void/zaddat/engie
	name = "\improper Engineer's Guild Shroud helmet"
	desc = "A livesuit helmet designed for good visibility in low-light environments."
	icon_state = "vax_engie"
	item_state_slots = list(slot_r_hand_str = "eng_helm", slot_l_hand_str = "eng_helm")

/obj/item/clothing/suit/space/void/zaddat/engie
	name = "\improper Engineer's Guild Shroud"
	desc = "This rugged livesuit was created by the Xozi Engineering Guild."
	icon_state = "vax_engie"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat/engie

/obj/item/clothing/head/helmet/space/void/zaddat/spacer
	name = "\improper Spacer's Guild Shroud helmet"
	desc = "A cool plastic-and-glass helmet designed after popular human fiction."
	icon_state = "vax_spacer"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/space/void/zaddat/spacer
	name = "\improper Spacer's Guild Shroud"
	desc = "The blue plastic livesuit worn by members of the Zaddat Spacer's Guild."
	icon_state = "vax_spacer"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat/spacer

/obj/item/clothing/head/helmet/space/void/zaddat/knight
	name = "\improper Knight's Shroud helm"
	desc = "This spaceworthy helmet was patterned after the knight's helmets used by Zaddat before their discovery by the Unathi."
	icon_state = "vax_knight"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/space/void/zaddat/knight
	name = "\improper Knight's Zaddat"
	desc = "This distinctive steel-plated livesuit was popularized by the Breeder's Guild."
	icon_state = "vax_knight"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat/knight

/obj/item/clothing/head/helmet/space/void/zaddat/fashion
	name = "\improper Avazi House Shroud helmet"
	desc = "The Avazi Fashion House recently designed this popular livesuit helmet, designed to pleasingly frame a Zadat's face."
	icon_state = "vax_fashion"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/space/void/zaddat/fashion
	name = "\improper Avazi House Shroud"
	desc = "The designers of the Avazi Fashion House are among the most renowned in Zaddat society, and their livesuit designs second to none."
	icon_state = "vax_fashion"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat/fashion

/obj/item/clothing/head/helmet/space/void/zaddat/bishop
	name = "\improper Bishop-patterned Shroud helmet"
	desc = "The Shroud helmet that inspired a dozen lawsuits."
	icon_state = "vax_bishop"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/space/void/zaddat/bishop
	name = "\improper Bishop-patterned livesuit"
	desc = "The bold designers of the Dzaz Fashion House chose to make this Bishop-themed Shroud design as a commentary on the symbiotic nature of Vanax and human culture. Allegedly."
	icon_state = "vax_bishop"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat/bishop