/obj/item/reagent_containers/food/snacks/roast_sifpod
	name = "roast sifpod"
	desc = "A charred and blackened sifpod, roasted to kill the toxins and split open to reveal steaming blue-green fruit jelly within. A popular campfire snack."
	icon = 'icons/obj/food_sivian.dmi'
	icon_state = "roastpod"
	nutriment_amt = 4
	nutriment_desc = list(
		SPECIES_TESHARI = list(
			"rich, tart fruit jelly" = 4,
			"pungent muskiness"      = 1
		),
		TASTE_STRING_DEFAULT = list(
			"sweet, tart fruit jelly" = 4,
			"pungent muskiness"       = 1
		)
	)
	nutriment_allergens = ALLERGEN_FRUIT
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sif_gumbo
	name = "\improper Londuneyja gumbo"
	desc = "A hearty stew of fish, fruit, spices and vegetables native to the Londuneyja region of Sif, along with a few Solar staples. A dish commonly served in rural settings, talked up as capable of warding off even the freezing Sivian winds."
	gender = PLURAL
	icon = 'icons/obj/food_sivian.dmi'
	icon_state = "gumbo"
	trash = /obj/item/trash/gumbo_bowl
	nutriment_amt = 8
	nutriment_desc = list(
		"smoky fish"                = 3,
		"spiced vegetables"         = 3,
		"stewed fruit"              = 3,
		"savoury stewed rice"       = 5,
		"rich spices"               = 5
	)
	nutriment_allergens = ALLERGEN_FRUIT | ALLERGEN_FISH | ALLERGEN_VEGETABLE | ALLERGEN_GRAINS
	bitesize = 3

/obj/item/trash/gumbo_bowl
	name = "brown bowl"
	icon_state = "gumbo_bowl"

/obj/item/reagent_containers/food/snacks/sif_jambalaya
	name = "\improper Ullran jambalaya"
	desc = "A colourful rice dish made with local Sivian fare, often made in bulk to feed large families or groups of workers in the rural areas of the Ullran Expanse. Spider sausage is optional, but highly recommended."
	gender = PLURAL
	icon = 'icons/obj/food_sivian.dmi'
	icon_state = "jambalaya"
	trash = /obj/item/trash/jambalaya_plate
	nutriment_amt = 2
	nutriment_desc = list(
		"rich tomato and chili" = 3,
		"savoury rice"          = 5,
		"spiced meat"           = 5,
		"tangy fruit"           = 2
	)
	bitesize = 3
	nutriment_allergens = ALLERGEN_FRUIT | ALLERGEN_MEAT | ALLERGEN_VEGETABLE | ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/sif_jambalaya/Initialize()
	. = ..()
	reagents.add_reagent("protein",     1)
	reagents.add_reagent("tomatojuice", 1)
	reagents.add_reagent("water",       1)
	reagents.add_reagent("rice",        1)

/obj/item/trash/jambalaya_plate
	name = "plate"
	icon_state = "blue_plate"

/obj/item/reagent_containers/food/snacks/sif_gerjao_auga
	name = "gerjao auga"
	desc = "A serving of finely shredded, fermented eyebulbs, similar in consistency to sauerkraut, but with an offputting citrus smell. Goes well with smoked shantak flank."
	gender = PLURAL
	icon = 'icons/obj/food_sivian.dmi'
	icon_state = "gerjao_auga"
	trash = /obj/item/trash/gerjao_auga_bowl
	nutriment_amt = 3
	nutriment_desc = list(
		"sharp vinegar" = 4,
		"bitter citrus" = 2,
		"sourness"      = 4
	)
	nutriment_allergens = ALLERGEN_FRUIT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sif_gerjao_auga/Initialize()
	. = ..()
	reagents.add_reagent("vinegar", 1)

/obj/item/trash/gerjao_auga_bowl
	name = "small bowl"
	icon_state = "small_blue_bowl"

/*
/obj/item/reagent_containers/food/snacks/sif_wabback_gratin
	name = "wabback gratin"
	desc = "A creamy, filling dish of baked black and white wabback slices, with a layer of cheese on top. The baking neutralizes the serotrotium and crisps the cheese!"

/obj/item/reagent_containers/food/snacks/siftromming
	name = "sifstromming"
	desc = "A portion of Sivian native fish, fermented in sifsap and brine. Commonly used to preserve meat in the Sivian wilds, and quite popular with the local Teshari."
*/
