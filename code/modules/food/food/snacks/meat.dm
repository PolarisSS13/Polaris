/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/meat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	src.bitesize = 1.5

/obj/item/reagent_containers/food/snacks/meat/cook()

	if (!isnull(cooked_icon))
		icon_state = cooked_icon
		flat_icon = null //Force regenating the flat icon for coatings, since we've changed the icon of the thing being coated
	..()

	if (name == initial(name))
		name = "cooked [name]"

/obj/item/reagent_containers/food/snacks/meat/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/knife))
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		to_chat(user, "You cut the meat into thin strips.")
		qdel(src)
	else
		..()

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/reagent_containers/food/snacks/meat/human
/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/reagent_containers/food/snacks/meat/chicken
	name = "chicken"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "chickenbreast"
	cooked_icon = "chickenbreast_cooked"
	filling_color = "#BBBBAA"

/obj/item/reagent_containers/food/snacks/meat/chicken/Initialize()
		. = ..()
		reagents.remove_reagent("triglyceride", INFINITY)
		//Chicken is low fat. Less total calories than other meats