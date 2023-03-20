
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = " "
	var/base_desc = " "
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	w_class = ITEMSIZE_SMALL
	atom_flags = ATOM_REAGENTS_IS_OPEN | ATOM_IS_INSULATED
	unacidable = 1 //glass doesn't dissolve in acid
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

	var/label_text = ""

	var/list/prefill = null	//Reagents to fill the container with on New(), formatted as "reagentID" = quantity

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/item/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/storage/secure/safe,
		/obj/machinery/iv_drip,
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/mob/living/simple_mob/animal/passive/cow,
		/mob/living/simple_mob/animal/goat,
		/obj/machinery/computer/centrifuge,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/structure/frame,
		/obj/machinery/radiocarbon_spectrometer,
		/obj/machinery/portable_atmospherics/powered/reagent_distillery
		)

/obj/item/reagent_containers/glass/Initialize()
	. = ..()
	if(LAZYLEN(prefill))
		for(var/R in prefill)
			reagents.add_reagent(R,prefill[R])
		prefill = null
		update_icon()
	base_name = name
	base_desc = desc

/obj/item/reagent_containers/glass/examine(var/mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		if(reagents && reagents.reagent_list.len)
			. += "<span class='notice'>It contains [reagents.total_volume] units of liquid.</span>"
		else
			. += "<span class='notice'>It is empty.</span>"
		if(!is_open_container())
			. += "<span class='notice'>Airtight lid seals it completely.</span>"

/obj/item/reagent_containers/glass/attack_self()
	..()
	if(is_open_container())
		to_chat(usr, "<span class = 'notice'>You put the lid on \the [src].</span>")
		atom_flags ^= ATOM_REAGENTS_IS_OPEN
	else
		to_chat(usr, "<span class = 'notice'>You take the lid off \the [src].</span>")
		atom_flags |= ATOM_REAGENTS_IS_OPEN
	update_icon()

/obj/item/reagent_containers/glass/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(item_flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return	..()

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/reagent_containers/glass/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src] first.</span>")
		return 1
	if(user.a_intent == I_HURT)
		return 1
	return ..()

/obj/item/reagent_containers/glass/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")

/obj/item/reagent_containers/glass/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!is_open_container() || !proximity) //Is the container open & are they next to whatever they're clicking?
		return 1 //If not, do nothing.
	for(var/type in can_be_placed_into) //Is it something it can be placed into?
		if(istype(target, type))
			return 1
	if(standard_dispenser_refill(user, target)) //Are they clicking a water tank/some dispenser?
		return 1
	if(standard_pour_into(user, target)) //Pouring into another beaker?
		return
	if(user.a_intent == I_HURT)
		if(standard_splash_mob(user,target))
			return 1
		if(reagents && reagents.total_volume)
			to_chat(user, "<span class='notice'>You splash the solution onto [target].</span>") //They are on harm intent, aka wanting to spill it.
			reagents.splash(target, reagents.total_volume)
			return 1
	..()

/obj/item/reagent_containers/glass/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 50)
			to_chat(user, "<span class='notice'>The label can be at most 50 characters long.</span>")
		else if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>You set the label.</span>")
			label_text = tmp_label
			update_name_label()
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
	if(istype(W,/obj/item/storage/bag))
		..()
	if(W && W.w_class <= w_class && (atom_flags & ATOM_REAGENTS_IS_OPEN) && user.a_intent != I_HELP)
		to_chat(user, "<span class='notice'>You dip \the [W] into \the [src].</span>")
		reagents.touch_obj(W, reagents.total_volume)

/obj/item/reagent_containers/glass/proc/update_name_label()
	if(label_text == "")
		name = base_name
	else if(length(label_text) > 20)
		var/short_label_text = copytext(label_text, 1, 21)
		name = "[base_name] ([short_label_text]...)"
	else
		name = "[base_name] ([label_text])"
	desc = "[base_desc] It is labeled \"[label_text]\"."

/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	center_of_mass = list("x" = 15,"y" = 11)
	matter = list("glass" = 500)
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/reagent_containers/glass/beaker/Initialize()
	. = ..()
	desc += " Can hold up to [volume] units."

/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]-10"
			if(10 to 24) 	filling.icon_state = "[icon_state]10"
			if(25 to 49)	filling.icon_state = "[icon_state]25"
			if(50 to 74)	filling.icon_state = "[icon_state]50"
			if(75 to 79)	filling.icon_state = "[icon_state]75"
			if(80 to 90)	filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		filling.color = reagents.get_color()
		add_overlay(filling)

	if (!is_open_container())
		add_overlay("lid_[initial(icon_state)]")

/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	center_of_mass = list("x" = 16,"y" = 11)
	matter = list("glass" = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	atom_flags = ATOM_REAGENTS_IS_OPEN

/obj/item/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	center_of_mass = list("x" = 16,"y" = 13)
	matter = list("glass" = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	atom_flags = ATOM_REAGENTS_IS_OPEN | ATOM_REAGENTS_SKIP_REACTIONS

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	center_of_mass = list("x" = 16,"y" = 11)
	matter = list("glass" = 5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	atom_flags = ATOM_REAGENTS_IS_OPEN

/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	center_of_mass = list("x" = 15,"y" = 9)
	matter = list("glass" = 250)
	volume = 30
	w_class = ITEMSIZE_TINY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	atom_flags = ATOM_REAGENTS_IS_OPEN

/obj/item/reagent_containers/glass/beaker/cryoxadone
	name = "beaker (cryoxadone)"
	prefill = list("cryoxadone" = 30)

/obj/item/reagent_containers/glass/beaker/sulphuric
	prefill = list("sacid" = 60)

/obj/item/reagent_containers/glass/beaker/stopperedbottle
	name = "stoppered bottle"
	desc = "A stoppered bottle for keeping beverages fresh."
	icon_state = "stopperedbottle"
	center_of_mass = list("x" = 16,"y" = 13)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	atom_flags = ATOM_REAGENTS_IS_OPEN

/obj/item/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	center_of_mass = list("x" = 16,"y" = 10)
	matter = list(MAT_STEEL = 200)
	w_class = ITEMSIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	atom_flags = ATOM_REAGENTS_IS_OPEN
	unacidable = 0
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'
	var/obj/item/holding
	var/helmet_type = /obj/item/clothing/head/helmet/bucket
	var/static/list/accept_items_for_mashing = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/material/snow/snowball,
		/obj/item/stack/material/snow
	)

/obj/item/reagent_containers/glass/bucket/attackby(var/obj/item/D, mob/user)

	// Turn bucket into a janibot.
	if(isprox(D))
		to_chat(user, "You add [D] to [src].")
		qdel(D)
		user.put_in_hands(new /obj/item/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)
		return TRUE

	// Turn bucket into a helmet.
	if(D.is_wirecutter() && helmet_type)
		to_chat(user, SPAN_NOTICE("You cut a big hole in \the [src] with \the [D].  It's kinda useless as a bucket now."))
		user.put_in_hands(new helmet_type)
		user.drop_from_inventory(src)
		qdel(src)
		return TRUE

	// Turn bucket into a robot assembly.
	if(istype(D, /obj/item/stack/material) && D.get_material_name() == MAT_STEEL)
		var/obj/item/stack/material/M = D
		if (M.use(1))
			var/obj/item/secbot_assembly/edCLN_assembly/B = new /obj/item/secbot_assembly/edCLN_assembly
			B.loc = get_turf(src)
			to_chat(user, SPAN_NOTICE("You armed the robot frame."))
			if (user.get_inactive_hand()==src)
				user.remove_from_mob(src)
				user.put_in_inactive_hand(B)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("You need one sheet of metal to arm the robot frame."))
		return  TRUE

	// Wet mop with reagents in bucket.
	if(istype(D, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, SPAN_NOTICE("You wet \the [D] in \the [src]."))
			playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		return TRUE

	// Put a fruit or snack into the bucket for mashing.
	if(!holding)
		var/is_mashable = FALSE
		for(var/mashable_type in accept_items_for_mashing)
			if(istype(D, mashable_type))
				is_mashable = TRUE
				break
		if(!is_mashable)
			return ..()
		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("\The [src] is almost overflowing; pour some liquid out first."))
			return TRUE
		if(user.unEquip(D, target = src))
			holding = D
			visible_message(SPAN_NOTICE("\The [user] drops \the [D] into \the [src]."))
		return TRUE

	// Mash the fruit in the bucket. This `else` is not accidental!
	else if(!(D.item_flags & NOBLUDGEON))
		visible_message("\The [user] begins mashing \the [holding] with \the [D]...")
		if(do_after(user, 3 SECONDS, src) && !QDELETED(src) && reagents.total_volume < reagents.maximum_volume)
			visible_message("\The [user] finishes mashing \the [holding] with \the [D].")
			if(holding.reagents)
				holding.reagents.trans_to_obj(src, holding.reagents.total_volume)
			QDEL_NULL(holding)
		return TRUE

	return ..()

/obj/item/reagent_containers/glass/bucket/Destroy()
	QDEL_NULL(holding)
	return ..()

/obj/item/reagent_containers/glass/bucket/examine(mob/user)
	. = ..()
	if(loc == user && holding)
		. += "There is \a [holding] in \the [src]."

/obj/item/reagent_containers/glass/bucket/attack_self(mob/user)
	if(holding)
		holding.dropInto(get_turf(user))
		visible_message(SPAN_NOTICE("\The [user] tips \the [holding] out of \the [src]."))
		holding = null
		return TRUE
	. = ..()

/obj/item/reagent_containers/glass/bucket/update_icon()
	cut_overlays()
	if (!is_open_container())
		add_overlay("lid_[initial(icon_state)]")

/obj/item/reagent_containers/glass/bucket/wood
	desc = "An old wooden bucket."
	name = "wooden bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "woodbucket"
	item_state = "woodbucket"
	center_of_mass = list("x" = 16,"y" = 8)
	matter = list("wood" = 50)
	w_class = ITEMSIZE_LARGE
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	atom_flags = ATOM_REAGENTS_IS_OPEN
	unacidable = 0
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/reagent_containers/glass/bucket/wood/attackby(var/obj/D, mob/user as mob)
	if(isprox(D))
		to_chat(user, "This wooden bucket doesn't play well with electronics.")
		return
	return ..()

/obj/item/reagent_containers/glass/cooler_bottle
	desc = "A bottle for a water-cooler."
	name = "water-cooler bottle"
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler_bottle"
	matter = list("glass" = 2000)
	w_class = ITEMSIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
