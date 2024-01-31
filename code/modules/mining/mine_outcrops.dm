/obj/structure/outcrop
	name = "outcrop"
	desc = "A boring rocky outcrop."
	icon = 'icons/obj/outcrop.dmi'
	density = 1
	throwpass = 1
	climbable = 1
	anchored = 1
	icon_state = "outcrop"
	var/mindrop = 5
	var/upperdrop = 10
	var/outcropdrop = /obj/item/ore/glass


/obj/structure/outcrop/Initialize()
	. = ..()
	if (prob(1))
		add_overlay("[initial(icon_state)]-egg")


/obj/structure/outcrop/attackby(obj/item/item, mob/living/user)
	if (!istype(item, /obj/item/pickaxe))
		return ..()
	visible_message(
		SPAN_ITALIC("\The [user] begins to hack away at \the [src]."),
		SPAN_ITALIC("You hear the industrious clanging of metal on rock!")
	)
	if (!do_after(user, 4 SECONDS, src))
		return TRUE
	visible_message(
		SPAN_ITALIC("\The [user] breaks the [src] apart."),
		SPAN_ITALIC("You hear rocks shatter apart!")
	)
	var/turf/turf = get_turf(src)
	qdel(src)
	if (!turf)
		return TRUE
	for (var/i = 1 to rand(mindrop, upperdrop))
		new outcropdrop (turf)
	return TRUE


/obj/structure/outcrop/diamond
	name = "shiny outcrop"
	desc = "A shiny rocky outcrop."
	icon_state = "outcrop-diamond"
	mindrop = 2
	upperdrop = 4
	outcropdrop = /obj/item/ore/diamond


/obj/structure/outcrop/phoron
	name = "shiny outcrop"
	desc = "A shiny rocky outcrop."
	icon_state = "outcrop-phoron"
	mindrop = 4
	upperdrop = 8
	outcropdrop = /obj/item/ore/phoron


/obj/structure/outcrop/iron
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-iron"
	mindrop = 10
	upperdrop = 20
	outcropdrop = /obj/item/ore/iron


/obj/structure/outcrop/coal
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-coal"
	mindrop = 10
	upperdrop = 20
	outcropdrop = /obj/item/ore/coal


/obj/structure/outcrop/lead
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-lead"
	mindrop = 2
	upperdrop = 5
	outcropdrop = /obj/item/ore/lead


/obj/structure/outcrop/gold
	name = "hollow outcrop"
	desc = "A hollow rocky outcrop."
	icon_state = "outcrop-gold"
	mindrop = 4
	upperdrop = 6
	outcropdrop = /obj/item/ore/gold


/obj/structure/outcrop/silver
	name = "hollow outcrop"
	desc = "A hollow rocky outcrop."
	icon_state = "outcrop-silver"
	mindrop = 6
	upperdrop = 8
	outcropdrop = /obj/item/ore/silver


/obj/structure/outcrop/platinum
	name = "hollow outcrop"
	desc = "A hollow rocky outcrop."
	icon_state = "outcrop-platinum"
	mindrop = 2
	upperdrop = 5
	outcropdrop = /obj/item/ore/osmium


/obj/structure/outcrop/uranium
	name = "spiky outcrop"
	desc = "A spiky rocky outcrop, it glows faintly."
	icon_state = "outcrop-uranium"
	mindrop = 4
	upperdrop = 8
	outcropdrop = /obj/item/ore/uranium


/obj/random/outcrop
	name = "random rock outcrop"
	desc = "This is a random rock outcrop."
	icon = 'icons/obj/outcrop.dmi'
	icon_state = "outcrop-random"


/obj/random/outcrop/item_to_spawn()
	return pick(
		prob(100); /obj/structure/outcrop,
		prob(100); /obj/structure/outcrop/iron,
		prob(100); /obj/structure/outcrop/coal,
		prob(65); /obj/structure/outcrop/silver,
		prob(50); /obj/structure/outcrop/gold,
		prob(30); /obj/structure/outcrop/uranium,
		prob(30); /obj/structure/outcrop/phoron,
		prob(15); /obj/structure/outcrop/platinum,
		prob(15); /obj/structure/outcrop/lead,
		prob(7); /obj/structure/outcrop/diamond
	)
