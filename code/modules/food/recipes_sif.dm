/datum/recipe/roast_sifpod
	appliance = OVEN
	items = list(/obj/item/reagent_containers/food/snacks/siffruit)
	reagent_mix = RECIPE_REAGENT_REPLACE // Clear the sifsap.
	result = /obj/item/reagent_containers/food/snacks/roast_sifpod

/datum/recipe/roast_sifpod/grown
	items = null
	fruit = list("sifpod" = 1)

/datum/recipe/sif_gerjao_auga
	appliance = MICROWAVE
	fruit = list("eyebulbs" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	reagents = list(
		"water"          = 5,
		"sodiumchloride" = 2,
		"enzyme"         = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sif_gerjao_auga

/datum/recipe/sif_jambalaya
	appliance = OVEN
	reagent_mix = RECIPE_REAGENT_REPLACE
	result_quantity = 5 // This is a lot, but we have no way to make a big bulk stew item and split it up currently.
	reagents = list(
		"water" = 5,
		"rice"  = 10,
		"spacespice" = 2
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	fruit = list(
		"eyebulbs" = 1,
		"tomato"   = 1,
		"chili"    = 1,
		"celery"   = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sif_jambalaya

/datum/recipe/sif_jambalaya/fish
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)

/datum/recipe/sif_jambalaya/mixed
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)

/datum/recipe/sif_gumbo
	appliance = OVEN
	reagent_mix = RECIPE_REAGENT_REPLACE
	result_quantity = 3 // See jambalaya above.
	reagents = list(
		"water" = 5,
		"rice"  = 5,
		"spacespice" = 2
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	fruit = list(
		"wabback" = 1,
		"celery" = 1,
	)
	// fish, wabback, meat, rice, celery
	result = /obj/item/reagent_containers/food/snacks/sif_gumbo

/datum/recipe/sif_gumbo/fish
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)

/datum/recipe/sif_gumbo/mixed
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
