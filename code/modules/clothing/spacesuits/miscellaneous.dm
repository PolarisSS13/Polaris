//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	item_flags = EMPTY_BITFIELD
	flags_inv = HIDEFACE|BLOCKHAIR
	permeability_coefficient = 0.01
	armor = list(melee = 65, bullet = 50, laser = 50,energy = 25, bomb = 50, bio = 100, rad = 50)

//Captain's space suit This is not the proper path but I don't currently know enough about how this all works to mess with it.
/obj/item/clothing/suit/armor/captain
	name = "Site Manager's armor"
	desc = "A bulky, heavy-duty piece of exclusive corporate armor. YOU are in charge!"
	icon_state = "caparmor"
	w_class = ITEMSIZE_HUGE
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = EMPTY_BITFIELD
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy, /obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,/obj/item/handcuffs)
	slowdown = 1.5
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	min_pressure_protection = 0
	max_pressure_protection = 2 * ONE_ATMOSPHERE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7

//Deathsquad suit
/obj/item/clothing/head/helmet/space/deathsquad
	name = "deathsquad helmet"
	desc = "That's not red paint. That's real blood."
	icon_state = "deathsquad"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black-red", slot_l_hand_str = "syndicate-helm-black-red")
	armor = list(melee = 65, bullet = 55, laser = 35,energy = 20, bomb = 30, bio = 100, rad = 60)
	item_flags = THICKMATERIAL
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.6

//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	item_flags = EMPTY_BITFIELD
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	slowdown = 0
	item_flags = EMPTY_BITFIELD
	allowed = list(/obj/item) //for stuffing exta special presents

//Space pirate outfit
/obj/item/clothing/head/helmet/space/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	item_flags = EMPTY_BITFIELD
	flags_inv = BLOCKHEADHAIR
	body_parts_covered = 0
	siemens_coefficient = 0.9

/obj/item/clothing/suit/space/pirate //Whhhhyyyyyyy???
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	w_class = ITEMSIZE_NORMAL
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency/oxygen)
	slowdown = 0
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0.9
	flags_inv = HIDETAIL|HIDEHOLSTER
	body_parts_covered = UPPER_TORSO|ARMS

//Orange emergency space suit
/obj/item/clothing/head/helmet/space/emergency
	name = "emergency soft helmet"
	icon_state = "emergencyhelm"
	desc = "A simple airtight helmet with a wide-angle visor, meant to pair with a snowsuit.  It comes with a head-mounted flashlight."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency
	name = "emergency softsuit"
	icon_state = "emergency_softsuit"
	desc = "An airtight emergency suit made of thermal foil, colored in reflective blaze orange for rescuers to easily locate. It's too fragile to protect you from hail or hungry animals, but it does do a good job of keeping you from freezing to death."
	slowdown = 2

//civilian recreational spacesuit

/obj/item/clothing/head/helmet/space/sports
	name = "performance sports space helmet"
	icon_state = "sports_void"
	desc = "A sleek space helmet for the civilian extra-vehicular extreme sports market. Please replace after any impact!"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR

/obj/item/clothing/suit/space/sports
	name = "performance sports spacesuit"
	desc = "A high-dexterity spacesuit for the civilian extra-vehicular extreme sports market, for when zero-g sports in controlled environments are just too tame."
	description_fluff = "Ward-Takahashi zero-gravity performance sportswear does not require an EVA certification to purchase, though user manuals do list it as 'recommended' on condition of a 2550 lawsuit."
	icon_state = "sports_void"
	slowdown = 0
