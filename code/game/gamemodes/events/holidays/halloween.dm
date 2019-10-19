//spooky foods (you can't actually make these when it's not halloween)
/obj/item/weapon/reagent_containers/food/snacks/sugarcookie/spookyskull
	name = "skull cookie"
	desc = "Spooky! It's got delicious calcium flavouring!"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "skeletoncookie"

/obj/item/weapon/reagent_containers/food/snacks/sugarcookie/spookycoffin
	name = "coffin cookie"
	desc = "Spooky! It's got delicious coffee flavouring!"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "coffincookie"


//spooky items

/obj/item/weapon/storage/spooky
	name = "trick-o-treat bag"
	desc = "A pumpkin-shaped bag that holds all sorts of goodies!"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "treatbag"

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/sugarcookie/spookyskull,
		/obj/item/weapon/reagent_containers/food/snacks/sugarcookie/spookycoffin,
		/obj/item/weapon/reagent_containers/food/snacks/candy_corn,
		/obj/item/weapon/reagent_containers/food/snacks/candy,
		/obj/item/weapon/reagent_containers/food/snacks/candiedapple,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar)