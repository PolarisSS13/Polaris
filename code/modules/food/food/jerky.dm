/obj/item/reagent_containers/food/snacks/jerky
	name = "mystery jerky"
	icon = 'icons/obj/food_jerky.dmi'
	bitesize = 2
	w_class = ITEMSIZE_TINY
	dry = TRUE

/obj/item/reagent_containers/food/snacks/jerky/fish
	name = "dried fish"
	desc = "A piece of dried fish, with a couple of scales still attached."
	icon_state = "fishjerky"

/obj/item/reagent_containers/food/snacks/jerky/fish/get_drying_state()
	return "fish_dried"

/obj/item/reagent_containers/food/snacks/jerky/fish/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 5)

/obj/item/reagent_containers/food/snacks/jerky/meat
	name = "dried meat"
	desc = "A piece of chewy dried meat. It has the texture of leather."
	icon_state = "meatjerky"

/obj/item/reagent_containers/food/snacks/jerky/meat/get_drying_state()
	return "meat_dried"

/obj/item/reagent_containers/food/snacks/jerky/meat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("triglyceride", 1)

/obj/item/reagent_containers/food/snacks/jerky/cutlet
	name = "dried meat stick"
	desc = "A stick of chewy dried meat. Great for travel rations."
	icon_state = "smallmeatjerky"

/obj/item/reagent_containers/food/snacks/jerky/cutlet/get_drying_state()
	return "meat_dried_small"

/obj/item/reagent_containers/food/snacks/jerky/cutlet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/jerky/spider
	name = "dried spider meat"
	desc = "A piece of green, stringy dried meat, full of tubes. It smells faintly of acid."
	icon_state = "spiderjerky_charred"

/obj/item/reagent_containers/food/snacks/jerky/spider/get_drying_state()
	return "meat_dried"

/obj/item/reagent_containers/food/snacks/jerky/spider/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)

/obj/item/reagent_containers/food/snacks/jerky/spider/poison
	icon_state = "spiderjerky"

/obj/item/reagent_containers/food/snacks/jerky/spider/poison/Initialize()
	. = ..()
	reagents.add_reagent("spidertoxin", 3)
