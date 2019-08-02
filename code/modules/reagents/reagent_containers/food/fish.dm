/obj/item/weapon/reagent_containers/food/snacks/sushi
	nutriment_amt = 5
	nutriment_desc = list("fish" = 5)
	drop_sound = 'sound/items/drop/food.ogg'

/obj/item/weapon/reagent_containers/food/snacks/sushi/New()
	..()
	reagents.add_reagent("protein", 5)
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/sushi/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	nutriment_desc = list("protein" = 3, "carpotoxin" = 2, "nutriment" = 2)


/obj/item/weapon/reagent_containers/food/snacks/sushi/carpmeat/New()
	..()
	reagents.add_reagent("carpotoxin", 2)


/obj/item/weapon/reagent_containers/food/snacks/sushi/salmonmeat
	name = "raw salmon"
	desc = "A fillet of raw salmon."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	nutriment_desc = list("protein" = 3, "nutriment" = 2)


/obj/item/weapon/reagent_containers/food/snacks/sushi/salmonsteak
	name = "Salmon steak"
	desc = "A piece of freshly-grilled salmon meat."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "salmonsteak"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	nutriment_desc = list("protein" = 4, "nutriment" = 2)


/obj/item/weapon/reagent_containers/food/snacks/sushi/catfishmeat
	name = "raw catfish"
	desc = "A fillet of raw catfish."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	nutriment_desc = list("protein" = 3, "nutriment" = 2)


/obj/item/weapon/reagent_containers/food/snacks/fishfingers
	name = "Fish Fingers"
	desc = "A finger of fish."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"
	bitesize = 2
	nutriment_amt = 4
	nutriment_desc = list("flour" = 1, "protein" = 4, "nutriment" = 4)
	drop_sound = 'sound/items/drop/food.ogg'

/obj/item/weapon/reagent_containers/food/snacks/fishburger
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "fishburger"
	filling_color = "#FFDEFE"
	bitesize = 3
	nutriment_amt = 6
	nutriment_desc = list("fish" = 6)
	drop_sound = 'sound/items/drop/food.ogg'


/obj/item/weapon/reagent_containers/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon = 'icons/obj/seafood.dmi'
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	bitesize = 3
	nutriment_amt = 4
	nutriment_desc = list("fish" = 4, "capsaicin" = 1)



/obj/item/weapon/reagent_containers/food/snacks/fishandchips
	name = "Fish and Chips"
	desc = "I do say so myself chap."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "fishandchips"
	filling_color = "#E3D796"
	bitesize = 3
	nutriment_amt = 6
	nutriment_desc = list("fish" = 6)




/obj/item/weapon/reagent_containers/food/snacks/sushi/sashimi
	name = "carp sashimi"
	desc = "Celebrate surviving attack from hostile alien lifeforms by hospitalising yourself."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sashimi"
	nutriment_desc = list("nutriment" = 6, "capsaicin" = 5)




/obj/item/weapon/reagent_containers/food/snacks/sushi/fried_shrimp
	name = "fried shrimp"
	desc = "Just one of the many things you can do with shrimp!"
	icon = 'icons/obj/seafood.dmi'
	icon_state = "shrimp_fried"
	nutriment_desc = list("nutriment" = 2)



/obj/item/weapon/reagent_containers/food/snacks/sushi/boiled_shrimp
	name = "boiled shrimp"
	desc = "Just one of the many things you can do with shrimp!"
	icon = 'icons/obj/seafood.dmi'
	icon_state = "shrimp_cooked"
	nutriment_desc = list("nutriment" = 2)




/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/Ebi_maki
	name = "Ebi Makiroll"
	desc = "A large unsliced roll of Ebi Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "Ebi_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Ebi
	slices_num = 4
	nutriment_desc = list("nutriment" = 8)


/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Ebi
	name = "Ebi Sushi"
	desc = "A simple sushi consisting of cooked shrimp and rice."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Ebi"
	nutriment_desc = list("nutriment" = 2)



/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/Ikura_maki
	name = "Ikura Makiroll"
	desc = "A large unsliced roll of Ikura Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "Ikura_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Ikura
	slices_num = 4
	nutriment_desc = list("nutriment" = 8, "protein" = 4)




/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Ikura
	name = "Ikura Sushi"
	desc = "A simple sushi consisting of salmon roe."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Ikura"
	nutriment_desc = list("nutriment" = 2, "protein" = 1)

/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/Sake_maki
	name = "Sake Makiroll"
	desc = "A large unsliced roll of Ebi Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "Sake_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Sake
	slices_num = 4
	nutriment_desc = list("nutriment" = 8)

/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Sake
	name = "Sake Sushi"
	desc = "A simple sushi consisting of raw salmon and rice."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Sake"
	nutriment_desc = list("nutriment" = 2)


/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/SmokedSalmon_maki
	name = "Smoked Salmon Makiroll"
	desc = "A large unsliced roll of Smoked Salmon Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "SmokedSalmon_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_SmokedSalmon
	slices_num = 4
	nutriment_desc = list("nutriment" = 8)


/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_SmokedSalmon
	name = "Smoked Salmon Sushi"
	desc = "A simple sushi consisting of cooked salmon and rice."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_SmokedSalmon"
	nutriment_desc = list("nutriment" = 2)



/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/Tamago_maki
	name = "Tamago Makiroll"
	desc = "A large unsliced roll of Tamago Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "Tamago_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Tamago
	slices_num = 4
	nutriment_desc = list("nutriment" = 8)


/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Tamago
	name = "Tamago Sushi"
	desc = "A simple sushi consisting of egg and rice."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Tamago"
	nutriment_desc = list("nutriment" = 2)


/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/Inari_maki
	name = "Inari Makiroll"
	desc = "A large unsliced roll of Inari Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "Inari_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Inari
	slices_num = 4
	nutriment_desc = list("nutriment" = 8)



/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Inari
	name = "Inari Sushi"
	desc = "A piece of fried tofu stuffed with rice."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Inari"
	nutriment_desc = list("nutriment" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/Masago_maki
	name = "Masago Makiroll"
	desc = "A large unsliced roll of Masago Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "Masago_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Masago
	slices_num = 4
	nutriment_desc = list("nutriment" = 8, "protein" = 4)


/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Masago
	name = "Masago Sushi"
	desc = "A simple sushi consisting of goldfish roe."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Masago"
	nutriment_desc = list("nutriment" = 2, "protein" = 1)


/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/Tobiko_maki
	name = "Tobiko Makiroll"
	desc = "A large unsliced roll of Tobkio Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "Tobiko_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Tobiko
	slices_num = 4
	nutriment_desc = list("nutriment" = 8, "protein" = 4)

/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Tobiko
	name = "Tobiko Sushi"
	desc = "A simple sushi consisting of shark roe."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Masago"
	nutriment_desc = list("nutriment" = 2, "protein" = 1)


/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/TobikoEgg_maki
	name = "Tobiko and Egg Makiroll"
	desc = "A large unsliced roll of Tobkio and Egg Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "TobikoEgg_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_TobikoEgg
	slices_num = 4
	nutriment_desc = list("nutriment" = 8, "protein" = 4)



/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_TobikoEgg
	name = "Tobiko and Egg Sushi"
	desc = "A sushi consisting of shark roe and an egg."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_TobikoEgg"
	nutriment_desc = list("nutriment" = 2, "protein" = 1)

/obj/item/weapon/reagent_containers/food/snacks/sushi/sliceable/Tai_maki
	name = "Tai Makiroll"
	desc = "A large unsliced roll of Tai Sushi."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "Tai_maki"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Tai
	slices_num = 4
	nutriment_desc = list("nutriment" = 8)

/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Tai
	name = "Tai Sushi"
	desc = "A simple sushi consisting of catfish and rice."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Tai"
	nutriment_desc = list("nutriment" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sushi/sushi_Unagi
	name = "Unagi Sushi"
	desc = "A simple sushi consisting of eel and rice."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "sushi_Hokki"
	nutriment_desc = list("nutriment" = 2)