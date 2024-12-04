//Wizard Rig
/obj/item/clothing/head/helmet/space/void/wizard
	name = "gem-encrusted voidsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "rig0-wiz"
	item_state_slots = list(slot_r_hand_str = "wiz_helm", slot_l_hand_str = "wiz_helm")
	unacidable = 1 //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.7
	sprite_sheets_refit = null
	sprite_sheets_obj = null
	wizard_garb = 1

	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_TAJ = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/head_space.dmi',
		SPECIES_NABBER_MONARCH = 'icons/mob/species/nabber/monarch/head_space.dmi'
		)

/obj/item/clothing/suit/space/void/wizard
	icon_state = "rig-wiz"
	name = "gem-encrusted voidsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	item_state_slots = list(slot_r_hand_str = "wiz_voidsuit", slot_l_hand_str = "wiz_voidsuit")
	w_class = ITEMSIZE_NORMAL
	unacidable = 1
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.7
	sprite_sheets_refit = null
	sprite_sheets_obj = null
	wizard_garb = 1

	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/suit.dmi',
		SPECIES_TAJ = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/suit.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/suit_space.dmi',
		SPECIES_NABBER_MONARCH = 'icons/mob/species/nabber/monarch/suit_space.dmi'
		)
