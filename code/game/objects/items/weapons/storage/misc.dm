/*
 * Donut Box
 */

var/global/list/random_weighted_donuts = list(
	/obj/item/reagent_containers/food/snacks/donut/plain = 5,
	/obj/item/reagent_containers/food/snacks/donut/plain/jelly = 5,
	/obj/item/reagent_containers/food/snacks/donut/pink = 4,
	/obj/item/reagent_containers/food/snacks/donut/pink/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/purple = 4,
	/obj/item/reagent_containers/food/snacks/donut/purple/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/green = 4,
	/obj/item/reagent_containers/food/snacks/donut/green/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/beige = 4,
	/obj/item/reagent_containers/food/snacks/donut/beige/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/choc = 4,
	/obj/item/reagent_containers/food/snacks/donut/choc/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/blue = 4,
	/obj/item/reagent_containers/food/snacks/donut/blue/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/yellow = 4,
	/obj/item/reagent_containers/food/snacks/donut/yellow/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/olive = 4,
	/obj/item/reagent_containers/food/snacks/donut/olive/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/homer = 3,
	/obj/item/reagent_containers/food/snacks/donut/homer/jelly = 3,
	/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles = 3,
	/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles/jelly = 3,
	/obj/item/reagent_containers/food/snacks/donut/chaos = 1
)

/obj/item/storage/box/donut
	icon = 'icons/obj/food_donuts.dmi'
	icon_state = "donutbox"
	name = "donut box"
	desc = "A box that holds tasty donuts, if you're lucky."
	description_fluff = "While the slogan on the box claims that these donuts are 'baked fresh locally', there is technically no legal marketing definition for 'fresh', 'local', or indeed 'baked'."
	center_of_mass = list("x" = 16,"y" = 9)
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard

/obj/item/storage/box/donut/Initialize()
	PopulateDonutSelection()
	. = ..()
	update_icon()


/obj/item/storage/box/donut/update_icon()
	cut_overlays()
	var/x_offset = 0
	for(var/obj/item/reagent_containers/food/snacks/donut/D in contents)
		var/mutable_appearance/ma = mutable_appearance(icon = icon, icon_state = D.overlay_state)
		ma.pixel_x = x_offset
		add_overlay(ma)
		x_offset += 3


/obj/item/storage/box/donut/proc/PopulateDonutSelection()
	starts_with = list()
	for (var/i = 1 to 6)
		starts_with += pickweight(random_weighted_donuts)


/obj/item/storage/box/donut/empty/PopulateDonutSelection()
	return

/obj/item/storage/box/nuggets
	name = "box of nuggets"
	icon = 'icons/obj/food_nuggets.dmi'
	icon_state = "nuggetbox_ten"
	desc = "A share pack of golden chicken nuggets in various fun shapes. Rumours of the rare and deadly 'fifth nugget shape' remain unsubstantiated."
	description_fluff = "While these nuggets remain beloved by children, drunks and picky eaters across the known galaxy, ongoing legal action leaves the meaning of 'chicken' in dispute."
	center_of_mass = list("x" = 16,"y" = 9)
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	can_hold = null
	foldable = /obj/item/stack/material/cardboard
	var/nugget_type = /obj/item/reagent_containers/food/snacks/nugget
	var/nugget_amount = 10

/obj/item/storage/box/nuggets/Initialize()
	can_hold = list(nugget_type)
	. = ..()
	if(nugget_amount)
		name = "[nugget_amount]-piece chicken nuggets box"
		max_storage_space = ITEMSIZE_COST_SMALL * nugget_amount
	immanentize_nuggets()
	update_icon()

/obj/item/storage/box/nuggets/proc/immanentize_nuggets()
	for(var/i in 1 to nugget_amount)
		new /obj/item/reagent_containers/food/snacks/nugget(src)

/obj/item/storage/box/nuggets/update_icon()
	if(length(contents) == 0)
		icon_state = "[initial(icon_state)]_empty"
	else if(length(contents) == nugget_amount)
		icon_state = "[initial(icon_state)]_full"
	else
		icon_state = initial(icon_state)

// Subtypes below.
/obj/item/storage/box/nuggets/empty/immanentize_nuggets()
	return

/obj/item/storage/box/nuggets/twenty
	nugget_amount = 20
	icon_state = "nuggetbox_twenty"

/obj/item/storage/box/nuggets/twenty/empty/immanentize_nuggets()
	return

/obj/item/storage/box/nuggets/forty
	nugget_amount = 40
	icon_state = "nuggetbox_forty"

/obj/item/storage/box/nuggets/forty/empty/immanentize_nuggets()
	return

/obj/item/storage/box/wormcan
	icon = 'icons/obj/food.dmi'
	icon_state = "wormcan"
	name = "can of worms"
	desc = "You probably do want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/wormsickly,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/wormdeluxe
	)
	starts_with = list(/obj/item/reagent_containers/food/snacks/worm = 6)

/obj/item/storage/box/wormcan/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/box/wormcan/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty"

/obj/item/storage/box/wormcan/sickly
	icon_state = "wormcan_sickly"
	name = "can of sickly worms"
	desc = "You probably don't want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	starts_with = list(/obj/item/reagent_containers/food/snacks/wormsickly = 6)

/obj/item/storage/box/wormcan/sickly/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty_sickly"

/obj/item/storage/box/wormcan/deluxe
	icon_state = "wormcan_deluxe"
	name = "can of deluxe worms"
	desc = "You absolutely want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	starts_with = list(/obj/item/reagent_containers/food/snacks/wormdeluxe = 6)

/obj/item/storage/box/wormcan/deluxe/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty_deluxe"
