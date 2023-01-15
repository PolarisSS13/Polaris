/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	brightness_on = 4 //luminosity when on
	light_overlay = "hardhat_light"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)
	flags_inv = 0
	siemens_coefficient = 0.9
	action_button_name = "Toggle Head-light"
	w_class = ITEMSIZE_NORMAL
	ear_protection = 1
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"
	name = "orange hard hat"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	name = "firefighter helmet"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0.2* ONE_ATMOSPHERE
	max_pressure_protection = 20 * ONE_ATMOSPHERE


/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"
	name = "sleek hard hat"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0.2* ONE_ATMOSPHERE
	max_pressure_protection = 20 * ONE_ATMOSPHERE

/obj/item/clothing/head/hardhat/dblue
	name = "blue hard hat"
	icon_state = "hardhat0_dblue"

/obj/item/clothing/head/hardhat/red/firefighter
	name = "atmospheric firefighter helmet"
	desc = "An atmospheric firefighter's helmet, able to keep the user protected from heat and fire in normal atmospheric conditions."
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 15000
	min_pressure_protection = 0.5 * ONE_ATMOSPHERE
	max_pressure_protection = 20 * ONE_ATMOSPHERE
	icon_state = "atmos_fire"
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_TESHARI = 'icons/mob/species/teshari/head.dmi'
		)

/obj/item/clothing/head/hardhat/firefighter
	name = "firefighter helmet"
	desc = "A complete, face covering helmet specially designed for firefighting. It is airtight and has a port for internals."
	icon_state = "helmet_firefighter"
	item_flags = THICKMATERIAL | AIRTIGHT
	permeability_coefficient = 0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 15000
	min_pressure_protection = 0.5 * ONE_ATMOSPHERE
	max_pressure_protection = 20 * ONE_ATMOSPHERE
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	flash_protection = FLASH_PROTECTION_MODERATE
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_TESHARI = 'icons/mob/species/teshari/head.dmi'
		)

/obj/item/clothing/head/hardhat/firefighter/chief
	name = "chief firefighter helmet"
	desc = "A complete, face covering helmet specially designed for firefighting. This one is in the colors of the Chief Engineer. It is airtight and has a port for internals."
	icon_state = "helmet_firefighter_ce"
