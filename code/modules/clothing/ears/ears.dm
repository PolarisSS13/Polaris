/*
	Earmuffs
*/
/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state_slots = list(slot_r_hand_str = "earmuffs", slot_l_hand_str = "earmuffs")
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	volume_multiplier = 0.1

/*
	Skrell tentacle wear
*/
/obj/item/clothing/ears/skrell
	name = "Skrell tentacle wear"
	desc = "Some stuff worn by skrell to adorn their head tentacles."
	icon = 'icons/obj/clothing/ears.dmi'
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	species_restricted = list(SPECIES_SKRELL)

/obj/item/clothing/ears/skrell/chain
	name = "Gold headtail chains"
	desc = "A delicate golden chain worn by female skrell to decorate their head tails."
	icon_state = "skrell_chain"
	item_state_slots = list(slot_r_hand_str = "egg5", slot_l_hand_str = "egg5")
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/ears/skrell/chain/silver
	name = "Silver headtail chains"
	desc = "A delicate silver chain worn by female skrell to decorate their head tails."
	icon_state = "skrell_chain_sil"
	item_state_slots = list(slot_r_hand_str = "egg", slot_l_hand_str = "egg")

/obj/item/clothing/ears/skrell/chain/bluejewels
	name = "Blue jeweled golden headtail chains"
	desc = "A delicate golden chain adorned with blue jewels worn by female Skrell to decorate their head tails."
	icon_state = "skrell_chain_bjewel"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/chain/redjewels
	name = "Red jeweled golden headtail chains"
	desc = "A delicate golden chain adorned with red jewels worn by female Skrell to decorate their head tails."
	icon_state = "skrell_chain_rjewel"
	item_state_slots = list(slot_r_hand_str = "egg4", slot_l_hand_str = "egg4")

/obj/item/clothing/ears/skrell/chain/ebony
	name = "Ebony headtail chains"
	desc = "A delicate ebony chain worn by female Skrell to decorate their head tails."
	icon_state = "skrell_chain_ebony"
	item_state_slots = list(slot_r_hand_str = "egg6", slot_l_hand_str = "egg6")

/obj/item/clothing/ears/skrell/band
	name = "Gold headtail bands"
	desc = "Golden metallic bands worn by male Skrell to adorn their head tails."
	icon_state = "skrell_band"
	item_state_slots = list(slot_r_hand_str = "egg5", slot_l_hand_str = "egg5")
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/ears/skrell/band/silver
	name = "Silver headtail bands"
	desc = "Silver metallic bands worn by male Skrell to adorn their head tails."
	icon_state = "skrell_band_sil"
	item_state_slots = list(slot_r_hand_str = "egg", slot_l_hand_str = "egg")

/obj/item/clothing/ears/skrell/band/bluejewels
	name = "Blue jeweled golden headtail bands"
	desc = "Golden metallic bands adorned with blue jewels worn by male Skrell to adorn their head tails."
	icon_state = "skrell_band_bjewel"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/band/redjewels
	name = "Red jeweled golden headtail bands"
	desc = "Golden metallic bands adorned with red jewels worn by male Skrell to adorn their head tails."
	icon_state = "skrell_band_rjewel"
	item_state_slots = list(slot_r_hand_str = "egg4", slot_l_hand_str = "egg4")

/obj/item/clothing/ears/skrell/band/ebony
	name = "Ebony headtail bands"
	desc = "Ebony bands worn by male Skrell to adorn their head tails."
	icon_state = "skrell_band_ebony"
	item_state_slots = list(slot_r_hand_str = "egg6", slot_l_hand_str = "egg6")

/obj/item/clothing/ears/skrell/colored/band
	name = "Colored headtail bands"
	desc = "Metallic bands worn by male Skrell to adorn their head tails."
	icon_state = "skrell_band_sil"
	item_state_slots = list(slot_r_hand_str = "egg", slot_l_hand_str = "egg")

/obj/item/clothing/ears/skrell/colored/chain
	name = "Colored headtail chains"
	desc = "A delicate chain worn by female Skrell to decorate their head tails."
	icon_state = "skrell_chain_sil"
	item_state_slots = list(slot_r_hand_str = "egg", slot_l_hand_str = "egg")

/obj/item/clothing/ears/skrell/cloth_female
	name = "red headtail cloth"
	desc = "A cloth shawl worn by female Skrell draped around their head tails."
	icon_state = "skrell_cloth_female"
	item_state_slots = list(slot_r_hand_str = "egg4", slot_l_hand_str = "egg4")

/obj/item/clothing/ears/skrell/cloth_female/black
	name = "black headtail cloth"
	icon_state = "skrell_cloth_black_female"
	item_state_slots = list(slot_r_hand_str = "egg6", slot_l_hand_str = "egg6")

/obj/item/clothing/ears/skrell/cloth_female/blue
	name = "blue headtail cloth"
	icon_state = "skrell_cloth_blue_female"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/cloth_female/green
	name = "green headtail cloth"
	icon_state = "skrell_cloth_green_female"
	item_state_slots = list(slot_r_hand_str = "egg3", slot_l_hand_str = "egg3")

/obj/item/clothing/ears/skrell/cloth_female/pink
	name = "pink headtail cloth"
	icon_state = "skrell_cloth_pink_female"
	item_state_slots = list(slot_r_hand_str = "egg1", slot_l_hand_str = "egg1")

/obj/item/clothing/ears/skrell/cloth_female/lightblue
	name = "light blue headtail cloth"
	icon_state = "skrell_cloth_lblue_female"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/cloth_male
	name = "red headtail cloth"
	desc = "A cloth band worn by male skrell around their head tails."
	icon_state = "skrell_cloth_male"
	item_state_slots = list(slot_r_hand_str = "egg4", slot_l_hand_str = "egg4")

/obj/item/clothing/ears/skrell/cloth_male/black
	name = "black headtail cloth"
	icon_state = "skrell_cloth_black_male"
	item_state_slots = list(slot_r_hand_str = "egg6", slot_l_hand_str = "egg6")

/obj/item/clothing/ears/skrell/cloth_male/blue
	name = "blue headtail cloth"
	icon_state = "skrell_cloth_blue_male"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/cloth_male/green
	name = "green headtail cloth"
	icon_state = "skrell_cloth_green_male"
	item_state_slots = list(slot_r_hand_str = "egg3", slot_l_hand_str = "egg3")

/obj/item/clothing/ears/skrell/cloth_male/pink
	name = "pink headtail cloth"
	icon_state = "skrell_cloth_pink_male"
	item_state_slots = list(slot_r_hand_str = "egg1", slot_l_hand_str = "egg1")

/obj/item/clothing/ears/skrell/cloth_male/lightblue
	name = "light blue headtail cloth"
	icon_state = "skrell_cloth_lblue_male"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/hearingaid
	name = "hearing aid"
	desc = "A device that assists the hard of hearing"
	icon = 'icons/obj/clothing/ears.dmi'
	icon_state = "hearing_aid"

/obj/item/clothing/ears/hearingaid/black
	name = "black hearing aid"
	icon_state = "hearing_aid_black"

/obj/item/clothing/ears/hearingaid/silver
	name = "silver hearing aid"
	icon_state = "hearing_aid_silver"

/obj/item/clothing/ears/hearingaid/white
	name = "white hearing aid"
	icon_state = "hearing_aid_white"
