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

	var/flip = 1
	if(prob(50))
		flip = -1

	adjust_scale(round(rand(8,12) / 10, 0.1) * flip, round(rand(8,12) / 10, 0.1))

	if(prob(1))
		add_overlay("[initial(icon_state)]-egg")

/obj/structure/outcrop/marble
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-marble"
	mindrop = 5
	upperdrop = 15
	outcropdrop = /obj/item/ore/marble

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

/obj/structure/outcrop/hydrogen
	name = "smooth outcrop"
	desc = "A smooth rocky outcrop."
	icon_state = "outcrop-hydrogen"
	mindrop = 1
	upperdrop = 3
	outcropdrop = /obj/item/ore/hydrogen

/obj/structure/outcrop/magmellite
	name = "smooth outcrop"
	desc = "A smooth rocky outcrop."
	icon_state = "outcrop-magmellite"
	mindrop = 1
	upperdrop = 3
	outcropdrop = /obj/item/ore/magmellite

/obj/structure/outcrop/iron
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-iron"
	mindrop = 10
	upperdrop = 20
	outcropdrop = /obj/item/ore/iron

/obj/structure/outcrop/bauxite
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-bauxite"
	mindrop = 5
	upperdrop = 10
	outcropdrop = /obj/item/ore/bauxite

/obj/structure/outcrop/copper
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-copper"
	mindrop = 6
	upperdrop = 12
	outcropdrop = /obj/item/ore/copper

/obj/structure/outcrop/tin
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-tin"
	mindrop = 3
	upperdrop = 8
	outcropdrop = /obj/item/ore/tin

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

/obj/structure/outcrop/quartz
	name = "spiky outcrop"
	desc = "A spiky rocky outcrop."
	icon_state = "outcrop-quartz"
	mindrop = 6
	upperdrop = 12
	outcropdrop = /obj/item/ore/quartz

/obj/structure/outcrop/rutile
	name = "hollow outcrop"
	desc = "A hollow rocky outcrop."
	icon_state = "outcrop-rutile"
	mindrop = 2
	upperdrop = 5
	outcropdrop = /obj/item/ore/rutile

/obj/structure/outcrop/verdantium
	name = "hollow outcrop"
	desc = "A hollow rocky outcrop."
	icon_state = "outcrop-verdantium"
	mindrop = 3
	upperdrop = 6
	outcropdrop = /obj/item/ore/verdantium

/obj/structure/outcrop/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/pickaxe))
		to_chat(user, "<span class='notice'>[user] begins to hack away at \the [src].</span>")
		if(do_after(user,40))
			to_chat(user, "<span class='notice'>You have finished digging!</span>")
			for(var/i=0;i<(rand(mindrop,upperdrop));i++)
				new outcropdrop(get_turf(src))
			qdel(src)
			return

/obj/random/outcrop //In case you want an outcrop without pre-determining the type of ore.
	name = "random rock outcrop"
	desc = "This is a random rock outcrop."
	icon = 'icons/obj/outcrop.dmi'
	icon_state = "outcrop-random"

/obj/random/outcrop/item_to_spawn()
	return pick(prob(100);/obj/structure/outcrop,
				prob(100);/obj/structure/outcrop/iron,
				prob(100);/obj/structure/outcrop/coal,
				prob(65);/obj/structure/outcrop/silver,
				prob(50);/obj/structure/outcrop/gold,
				prob(30);/obj/structure/outcrop/uranium,
				prob(30);/obj/structure/outcrop/phoron,
				prob(20);/obj/structure/outcrop/bauxite,
				prob(20);/obj/structure/outcrop/copper,
				prob(7);/obj/structure/outcrop/diamond,
				prob(3);/obj/structure/outcrop/hydrogen,
				prob(1);/obj/structure/outcrop/magmellite,
				prob(15);/obj/structure/outcrop/platinum,
				prob(15);/obj/structure/outcrop/rutile,
				prob(15);/obj/structure/outcrop/lead,
				prob(10);/obj/structure/outcrop/verdantium)
