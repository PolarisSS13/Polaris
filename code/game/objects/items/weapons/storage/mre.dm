/*
MRE Stuff
 */

/obj/item/storage/mre
	name = "standard MRE"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	max_w_class = ITEMSIZE_SMALL
	var/opened = FALSE
	var/meal_desc = "This one is menu 1, meat pizza."
	starts_with = list(
	/obj/item/storage/mrebag,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/examine(mob/user)
	. = ..()
	. += meal_desc

/obj/item/storage/mre/update_icon()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"
	. = ..()

/obj/item/storage/mre/attack_self(mob/user)
	open(user)

/obj/item/storage/mre/open(mob/user)
	if(!opened)
		to_chat(usr, "<span class='notice'>You tear open the bag, breaking the vacuum seal.</span>")
		opened = 1
		update_icon()
	. = ..()

/obj/item/storage/mre/menu2
	meal_desc = "This one is menu 2, margherita."
	starts_with = list(
	/obj/item/storage/mrebag/menu2,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu3
	meal_desc = "This one is menu 3, vegetable pizza."
	starts_with = list(
	/obj/item/storage/mrebag/menu3,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu4
	meal_desc = "This one is menu 4, hamburger."
	starts_with = list(
	/obj/item/storage/mrebag/menu4,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu5
	meal_desc = "This one is menu 5, taco."
	starts_with = list(
	/obj/item/storage/mrebag/menu5,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu6
	meal_desc = "This one is menu 6, meatbread."
	starts_with = list(
	/obj/item/storage/mrebag/menu6,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu7
	meal_desc = "This one is menu 7, salad."
	starts_with = list(
	/obj/item/storage/mrebag/menu7,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu8
	meal_desc = " This one is menu 8, hot chili."
	starts_with = list(
	/obj/item/storage/mrebag/menu8,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu9
	name = "vegan MRE"
	meal_desc = "This one is menu 9, boiled rice (skrell-safe)."
	icon_state = "vegmre"
	starts_with = list(
	/obj/item/storage/mrebag/menu9,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert/menu9,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread/vegan,
	/obj/random/mre/drink,
	/obj/random/mre/sauce/vegan,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu10
	name = "protein MRE"
	meal_desc = "This one is menu 10, protein."
	icon_state = "meatmre"
	starts_with = list(
	/obj/item/storage/mrebag/menu10,
	/obj/item/storage/mrebag/menu10,
	/obj/item/reagent_containers/food/snacks/candy/proteinbar,
	/obj/item/reagent_containers/food/condiment/small/packet/protein,
	/obj/random/mre/sauce/sugarfree,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu11
	name = "emergency MRE"
	meal_desc = "This one is menu 11, nutriment paste. Only for emergencies."
	icon_state = "crayonmre"
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/liquidfood,
	/obj/item/reagent_containers/food/snacks/liquidfood,
	/obj/item/reagent_containers/food/snacks/liquidfood,
	/obj/item/reagent_containers/food/snacks/liquidfood,
	/obj/item/reagent_containers/food/snacks/liquidprotein,
	/obj/item/reagent_containers/food/snacks/liquidprotein,
	)

/obj/item/storage/mre/menu12
	name = "crayon MRE"
	meal_desc = "This one doesn't have a menu listing. How very odd."
	icon_state = "crayonmre"
	starts_with = list(
	/obj/item/storage/fancy/crayons,
	/obj/item/storage/mrebag/dessert/menu11,
	/obj/random/mre/sauce/crayon,
	/obj/random/mre/sauce/crayon,
	/obj/random/mre/sauce/crayon
	)

/obj/item/storage/mre/menu13
	name = "medical MRE"
	meal_desc = "This one is menu 13, vitamin paste & dessert. Only for emergencies."
	icon_state = "crayonmre"
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/liquidvitamin,
	/obj/item/reagent_containers/food/snacks/liquidvitamin,
	/obj/item/reagent_containers/food/snacks/liquidvitamin,
	/obj/item/reagent_containers/food/snacks/liquidprotein,
	/obj/random/mre/drink,
	/obj/item/storage/mrebag/dessert,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/random
	meal_desc = "The menu label is faded out."
	starts_with = list(
	/obj/random/mre/main,
	/obj/item/storage/mrebag/side,
	/obj/item/storage/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mrebag
	name = "main course"
	desc = "A vacuum-sealed bag containing the MRE's main course. Self-heats when opened."
	icon = 'icons/obj/food.dmi'
	icon_state = "pouch_medium"
	storage_slots = 1
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_SMALL
	var/opened = FALSE
	starts_with = list(/obj/item/reagent_containers/food/snacks/slice/meatpizza/filled)

/obj/item/storage/mrebag/Initialize()
	. = ..()

/obj/item/storage/mrebag/update_icon()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"
	. = ..()

/obj/item/storage/mrebag/attack_self(mob/user)
	open(user)

/obj/item/storage/mrebag/open(mob/user)
	if(!opened)
		to_chat(usr, "<span class='notice'>The pouch heats up as you break the vaccum seal.</span>")
		opened = 1
		update_icon()
	. = ..()

/obj/item/storage/mrebag/menu2
	starts_with = list(/obj/item/reagent_containers/food/snacks/slice/margherita/filled)

/obj/item/storage/mrebag/menu3
	starts_with = list(/obj/item/reagent_containers/food/snacks/slice/vegetablepizza/filled)

/obj/item/storage/mrebag/menu4
	starts_with = list(/obj/item/reagent_containers/food/snacks/monkeyburger)

/obj/item/storage/mrebag/menu5
	starts_with = list(/obj/item/reagent_containers/food/snacks/taco)

/obj/item/storage/mrebag/menu6
	starts_with = list(/obj/item/reagent_containers/food/snacks/slice/meatbread/filled)

/obj/item/storage/mrebag/menu7
	starts_with = list(/obj/item/reagent_containers/food/snacks/tossedsalad)

/obj/item/storage/mrebag/menu8
	starts_with = list(/obj/item/reagent_containers/food/snacks/hotchili)

/obj/item/storage/mrebag/menu9
	starts_with = list(/obj/item/reagent_containers/food/snacks/boiledrice)

/obj/item/storage/mrebag/menu10
	starts_with = list(/obj/item/reagent_containers/food/snacks/meatcube)

/obj/item/storage/mrebag/side
	name = "side dish"
	desc = "A vacuum-sealed bag containing the MRE's side dish. Self-heats when opened."
	icon_state = "pouch_small"
	starts_with = list(/obj/random/mre/side)

/obj/item/storage/mrebag/side/menu10
	starts_with = list(/obj/item/reagent_containers/food/snacks/meatcube)

/obj/item/storage/mrebag/dessert
	name = "dessert"
	desc = "A vacuum-sealed bag containing the MRE's dessert."
	icon_state = "pouch_small"
	starts_with = list(/obj/random/mre/dessert)

/obj/item/storage/mrebag/dessert/menu9
	starts_with = list(/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit)

/obj/item/storage/mrebag/dessert/menu11
	starts_with = list(/obj/item/pen/crayon/rainbow)
