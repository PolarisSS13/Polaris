/obj/structure/drying_rack
	name = "drying rack"
	desc = "A rack used to hold meat or vegetables for drying, or to stretch leather out and hold it taut during the tanning process."
	icon = 'icons/obj/drying_rack.dmi'
	icon_state = "rack"
	var/dismantle_product = /obj/item/stack/material/steel
	var/dismantle_amount = 3
	var/obj/item/drying

/obj/structure/drying_rack/wood
	icon_state = "rack_wooden"
	dismantle_product = /obj/item/stack/material/fuel/wood

/obj/structure/drying_rack/sifwood
	icon_state = "rack_wooden_sif"
	dismantle_product = /obj/item/stack/material/fuel/wood/sif

/obj/structure/drying_rack/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src) // SSObj fires ~every 2s , starting from wetness 30 takes ~1m

/obj/structure/drying_rack/Destroy()
	QDEL_NULL(drying)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/drying_rack/process()
	var/dry_product = drying?.dry_out(src)
	if(dry_product)
		if(drying != dry_product)
			if(drying && !QDELETED(drying))
				drying.dropInto(loc)
			drying = dry_product
		if(drying)
			drying.forceMove(src)
		update_icon()

/obj/structure/drying_rack/examine(var/mob/user)
	. = ..()
	if(drying)
		. += "\The [drying] is [drying.get_dryness_text()]."

/obj/structure/drying_rack/update_icon()
	cut_overlays()
	var/drying_state = drying?.get_drying_overlay(src)
	if(drying_state)
		add_overlay(drying_state)

/obj/structure/drying_rack/attackby(var/obj/item/W, var/mob/user)

	if(W.is_wrench())
		playsound(src, W.usesound, 75, 1)
		visible_message(SPAN_NOTICE("\The [user] begins dismantling \the [src]."))
		if(do_after(user, 5 SECONDS * W.toolspeed))
			visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."))
			if(drying)
				drying.dropInto(loc)
				drying = null
			if(dismantle_product && dismantle_amount)
				new dismantle_product(loc, dismantle_amount)
			qdel(src)
		return TRUE

	if(!drying && W.is_dryable() && !istype(W, /obj/item/stack/material/fuel))
		if(user.unEquip(W))
			W.forceMove(src)
			drying = W
			update_icon()
		return TRUE

	return ..()

/obj/structure/drying_rack/attack_hand(var/mob/user)
	if(drying)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!H.put_in_any_hand_if_possible(drying))
				drying.forceMove(get_turf(src))
		else
			drying.dropInto(loc)
		drying = null
		update_icon()
	return ..()

/obj/structure/drying_rack/attack_robot(var/mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	return ..()
