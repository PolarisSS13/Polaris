/obj/item/clothing/head/hood
	name = "hood"
	desc = "A generic hood."
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEEARS | BLOCKHAIR

// Winter coats
/obj/item/clothing/head/hood/winter
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "generic_hood"
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hood/winter/captain
	name = "colony director's winter hood"
	armor = list(melee = 20, bullet = 15, laser = 20, energy = 10, bomb = 15, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/security
	name = "security winter hood"
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 15, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/medical
	name = "medical winter hood"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/head/hood/winter/science
	name = "science winter hood"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/engineering
	name = "engineering winter hood"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)

/obj/item/clothing/head/hood/winter/engineering/atmos
	name = "atmospherics winter hood"

/obj/item/clothing/head/hood/winter/hydro
	name = "hydroponics winter hood"

/obj/item/clothing/head/hood/winter/cargo
	name = "cargo winter hood"

/obj/item/clothing/head/hood/winter/miner
	name = "mining winter hood"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

// Explorer gear
/obj/item/clothing/head/hood/explorer
	name = "explorer hood"
	desc = "An armoured hood for exploring harsh environments."
	icon_state = "explorer"
	flags = THICKMATERIAL
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 35, bio = 75, rad = 35)

// Costumes
/obj/item/clothing/head/hood/carp_hood
	name = "carp hood"
	desc = "A hood attached to a carp costume."
	icon_state = "carp_casual"
	item_state_slots = list(slot_r_hand_str = "carp_casual", slot_l_hand_str = "carp_casual") //Does not exist -S2-
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE	//Space carp like space, so you should too

/obj/item/clothing/head/hood/ian_hood
	name = "corgi hood"
	desc = "A hood that looks just like a corgi's head, it won't guarantee dog biscuits."
	icon_state = "ian"
	item_state_slots = list(slot_r_hand_str = "ian", slot_l_hand_str = "ian") //Does not exist -S2-

// Hoodies
/obj/item/clothing/head/hoodie_hood
	name = "hoodie hood"
	desc = "A hood attached to a hoodie."
	icon_state = "grey_hoodie_hood"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")
	min_cold_protection_temperature = T0C - 20
	flags_inv = BLOCKHEADHAIR
	body_parts_covered = HEAD

/obj/item/clothing/head/hoodie_hood/black
	icon_state = "black_hoodie_hood"

/obj/item/clothing/head/hoodie_hood/red
	icon_state = "red_hoodie_hood"

/obj/item/clothing/head/hoodie_hood/blue
	icon_state = "blue_hoodie_hood"

/obj/item/clothing/head/hoodie_hood/green
	icon_state = "green_hoodie_hood"

/obj/item/clothing/head/hoodie_hood/yellow
	icon_state = "yellow_hoodie_hood"

/obj/item/clothing/head/hoodie_hood/orange
	icon_state = "orange_hoodie_hood"

// Snowsuits
/obj/item/clothing/head/hood/winter/snowsuit
	name = "snowsuit hood"
	desc = "A hood attached to a snowsuit."
	icon_state = "snowsuit_hood"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 5, rad = 0)

/obj/item/clothing/head/hood/winter/snowsuit/command
	name = "command snowsuit hood"

/obj/item/clothing/head/hood/winter/snowsuit/science
	name = "science snowsuit hood"

/obj/item/clothing/head/hood/winter/snowsuit/security
	name = "security snowsuit hood"

/obj/item/clothing/head/hood/winter/snowsuit/engineering
	name = "engineering snowsuit hood"

/obj/item/clothing/head/hood/winter/snowsuit/medical
	name = "medical snowsuit hood"

/obj/item/clothing/head/hood/winter/snowsuit/cargo
	name = "cargo snowsuit hood"
