//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndie"
	item_state_slots = list(slot_r_hand_str = "syndie_helm", slot_l_hand_str = "syndie_helm")
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_green" //todo: species-specific light overlays

	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_TAJ = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/head_space.dmi',
		SPECIES_NABBER_MONARCH = 'icons/mob/species/nabber/monarch/head_space.dmi'
		)

/obj/item/clothing/suit/space/void/merc
	icon_state = "rig-syndie"
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	item_state_slots = list(slot_r_hand_str = "syndie_voidsuit", slot_l_hand_str = "syndie_voidsuit")
	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.6
	breach_threshold = 16 //Extra Thicc
	resilience = 0.05 //Military Armor

	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/suit.dmi',
		SPECIES_TAJ = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/suit.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/suit_space.dmi',
		SPECIES_NABBER_MONARCH = 'icons/mob/species/nabber/monarch/suit_space.dmi'
		)

/obj/item/clothing/head/helmet/space/void/merc/fire
	icon_state = "rig0-firebug"
	name = "soot-covered voidsuit helmet"
	desc = "A blackened helmet that has had many of its protective plates coated in or replaced with high-grade thermal insulation, to protect against incineration. Property of Gorlex Marauders."
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 20, bomb = 50, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_fire"

	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_TAJ = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/head_space.dmi',
		SPECIES_NABBER_MONARCH = 'icons/mob/species/nabber/monarch/head_space.dmi'
		)

/obj/item/clothing/suit/space/void/merc/fire
	icon_state = "rig-firebug"
	name = "soot-covered voidsuit"
	desc = "A blackened suit that has had many of its protective plates coated in or replaced with high-grade thermal insulation, to protect against incineration. Property of Gorlex Marauders."
	armor = list(melee = 50, bullet = 40, laser = 60, energy = 20, bomb = 50, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs,/obj/item/material/twohanded/fireaxe,/obj/item/flamethrower)
	siemens_coefficient = 0.7
	breach_threshold = 18 //Super Extra Thicc
	slowdown = 1

	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/suit.dmi',
		SPECIES_TAJ = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/suit.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/suit_space.dmi',
		SPECIES_NABBER_MONARCH = 'icons/mob/species/nabber/monarch/suit_space.dmi'
		)
