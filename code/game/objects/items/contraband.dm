/obj/item/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "A recreational drug. When you want to see the rainbow. Probably not work-approved..."
	wrapper_color = COLOR_PINK
	starts_with = list(/obj/item/reagent_containers/pill/happy = 7)


/obj/item/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Probably illegal. Trade brain for speed."
	wrapper_color = COLOR_BLUE
	starts_with = list(/obj/item/reagent_containers/pill/zoom = 7)


/obj/item/reagent_containers/glass/beaker/vial/random
	atom_flags = EMPTY_BITFIELD
	var/list/random_reagent_list = list(list("water" = 15) = 1, list("cleaner" = 15) = 1)


/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list("mindbreaker" = 10, "bliss" = 20)	= 3,
		list("carpotoxin" = 15)							= 2,
		list("impedrezene" = 15)						= 2,
		list("zombiepowder" = 10)						= 1)


/obj/item/reagent_containers/glass/beaker/vial/random/Initialize()
	. = ..()
	if(is_open_container())
		atom_flags ^= ATOM_REAGENTS_IS_OPEN
	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])
	var/list/names = new
	for(var/datum/reagent/R in reagents.reagent_list)
		names += R.name
	desc = "Contains [english_list(names)]."
	update_icon()


/obj/item/reagent_containers/powder
	name = "powder"
	desc = "A powdered form of... something."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "powder"
	item_state = "powder"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = 5
	w_class = ITEMSIZE_TINY
	volume = 50

	/// The name of the reagent with the most volume in this powder.
	var/main_reagent_name


/obj/item/reagent_containers/powder/Initialize(mapload, datum/reagents/initial_reagents)
	. = ..()
	if (istype(initial_reagents))
		initial_reagents.trans_to_holder(reagents, volume)
	else if (islist(initial_reagents))
		var/list/initial_reagents_list = initial_reagents
		for (var/reagent_type in initial_reagents_list)
			reagents.add_reagent(reagent_type, initial_reagents[reagent_type])
	if (!reagents.total_volume)
		return INITIALIZE_HINT_QDEL
	var/datum/reagent/main_reagent = reagents.get_master_reagent()
	main_reagent_name = lowertext(main_reagent.name)
	color = reagents.get_color()


/obj/item/reagent_containers/powder/examine(mob/user, distance, infix, suffix)
	. = ..()
	if (distance > 2 && isliving(user))
		return
	. += "It seems to be about [reagents.total_volume] units of [main_reagent_name]."


/obj/item/reagent_containers/powder/attackby(obj/item/item, mob/living/user)
	if (!ishuman(user))
		return ..()
	if (!istype(item, /obj/item/glass_extra/straw) && !istype(item, /obj/item/reagent_containers/rollingpaper))
		return ..()
	reagents.trans_to_mob(user, amount_per_transfer_from_this, CHEM_BLOOD)
	var/used_up = !reagents.total_volume
	user.visible_message(
		SPAN_ITALIC("\The [user] snorts some [name] with \a [item]."),
		SPAN_ITALIC("You snort [used_up ? "the last" : "some"] of the [main_reagent_name] with \the [item].")
	)
	playsound(loc, 'sound/effects/snort.ogg', 50, 1)
	if (used_up)
		qdel(src)


/obj/item/storage/pill_bottle/bliss
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/bliss = 7)

/obj/item/storage/pill_bottle/snowflake
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/snowflake = 7)

/obj/item/storage/pill_bottle/royale
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/royale = 7)

/obj/item/storage/pill_bottle/sinkhole
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/sinkhole = 7)

/obj/item/storage/pill_bottle/colorspace
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/colorspace = 7)

/obj/item/storage/pill_bottle/schnappi
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/schnappi = 7)
