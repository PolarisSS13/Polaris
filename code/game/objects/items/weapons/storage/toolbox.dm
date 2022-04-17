/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state_slots = list(slot_r_hand_str = "toolbox_red", slot_l_hand_str = "toolbox_red")
	center_of_mass = list("x" = 16,"y" = 11)
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_SMALL * 7 //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")
	use_sound = 'sound/items/storage/toolbox.ogg'
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state_slots = list(slot_r_hand_str = "toolbox_red", slot_l_hand_str = "toolbox_red")
	starts_with = list(
		/obj/item/tool/crowbar/red,
		/obj/item/extinguisher/mini,
		/obj/item/device/radio
	)
/obj/item/storage/toolbox/emergency/Initialize()
	if(prob(50))
		new /obj/item/device/flashlight(src)
	else
		new /obj/item/device/flashlight/flare(src)
	. = ..()

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state_slots = list(slot_r_hand_str = "toolbox_blue", slot_l_hand_str = "toolbox_blue")
	starts_with = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/weldingtool,
		/obj/item/tool/crowbar,
		/obj/item/device/analyzer,
		/obj/item/tool/wirecutters
	)

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state_slots = list(slot_r_hand_str = "toolbox_yellow", slot_l_hand_str = "toolbox_yellow")
	starts_with = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wirecutters,
		/obj/item/device/t_scanner,
		/obj/item/tool/crowbar,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/stack/cable_coil/random_belt
	)
/obj/item/storage/toolbox/electrical/Initialize()
	. = ..()
	if(prob(5))
		new /obj/item/clothing/gloves/yellow(src)
	else
		new /obj/item/stack/cable_coil/random(src,30)
	calibrate_size()

/obj/item/storage/toolbox/syndicate
	name = "black and red toolbox"
	icon_state = "syndicate"
	item_state_slots = list(slot_r_hand_str = "toolbox_syndi", slot_l_hand_str = "toolbox_syndi")
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	force = 14
	starts_with = list(
		/obj/item/clothing/gloves/yellow,
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/weldingtool,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
		/obj/item/device/multitool
	)

/obj/item/storage/toolbox/syndicate/powertools
	starts_with = list(
		/obj/item/clothing/gloves/yellow,
		/obj/item/tool/screwdriver/power,
		/obj/item/weldingtool/experimental,
		/obj/item/tool/crowbar/power,
		/obj/item/device/multitool,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/device/analyzer
	)

/obj/item/storage/toolbox/lunchbox
	max_storage_space = ITEMSIZE_COST_SMALL * 4 //slightly smaller than a toolbox
	name = "rainbow lunchbox"
	icon_state = "lunchbox_rainbow"
	item_state_slots = list(slot_r_hand_str = "toolbox_pink", slot_l_hand_str = "toolbox_pink")
	desc = "A little lunchbox. This one is the colors of the rainbow!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_SMALL
	var/filled = FALSE
	attack_verb = list("lunched")

/obj/item/storage/toolbox/lunchbox/Initialize()
	if(filled)
		var/list/lunches = lunchables_lunches()
		var/lunch = lunches[pick(lunches)]
		new lunch(src)

		var/list/snacks = lunchables_snacks()
		var/snack = snacks[pick(snacks)]
		new snack(src)

		var/list/drinks = lunchables_drinks()
		var/drink = drinks[pick(drinks)]
		new drink(src)
	. = ..()

/obj/item/storage/toolbox/lunchbox/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/heart
	name = "heart lunchbox"
	icon_state = "lunchbox_lovelyhearts"
	item_state_slots = list(slot_r_hand_str = "toolbox_pink", slot_l_hand_str = "toolbox_pink")
	desc = "A little lunchbox. This one has cute little hearts on it!"

/obj/item/storage/toolbox/lunchbox/heart/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/cat
	name = "cat lunchbox"
	icon_state = "lunchbox_sciencecatshow"
	item_state_slots = list(slot_r_hand_str = "toolbox_green", slot_l_hand_str = "toolbox_green")
	desc = "A little lunchbox. This one has a cute little science cat from a popular show on it!"

/obj/item/storage/toolbox/lunchbox/cat/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/nt
	name = "NanoTrasen brand lunchbox"
	icon_state = "lunchbox_nanotrasen"
	item_state_slots = list(slot_r_hand_str = "toolbox_blue", slot_l_hand_str = "toolbox_blue")
	desc = "A little lunchbox. This one is branded with the NanoTrasen logo!"

/obj/item/storage/toolbox/lunchbox/nt/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/mars
	name = "\improper Mojave university lunchbox"
	icon_state = "lunchbox_marsuniversity"
	item_state_slots = list(slot_r_hand_str = "toolbox_red", slot_l_hand_str = "toolbox_red")
	desc = "A little lunchbox. This one is branded with the Mojave university logo!"

/obj/item/storage/toolbox/lunchbox/mars/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/cti
	name = "\improper CTI lunchbox"
	icon_state = "lunchbox_cti"
	item_state_slots = list(slot_r_hand_str = "toolbox_blue", slot_l_hand_str = "toolbox_blue")
	desc = "A little lunchbox. This one is branded with the CTI logo!"

/obj/item/storage/toolbox/lunchbox/cti/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/nymph
	name = "\improper Diona nymph lunchbox"
	icon_state = "lunchbox_dionanymph"
	item_state_slots = list(slot_r_hand_str = "toolbox_yellow", slot_l_hand_str = "toolbox_yellow")
	desc = "A little lunchbox. This one is an adorable Diona nymph on the side!"

/obj/item/storage/toolbox/lunchbox/nymph/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/syndicate
	name = "black and red lunchbox"
	icon_state = "lunchbox_syndie"
	item_state_slots = list(slot_r_hand_str = "toolbox_syndi", slot_l_hand_str = "toolbox_syndi")
	desc = "A little lunchbox. This one is a sleek black and red, made of a durable steel!"

/obj/item/storage/toolbox/lunchbox/syndicate/filled
	filled = TRUE
