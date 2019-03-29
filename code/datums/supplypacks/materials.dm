/*
*	Here is where any supply packs
*	related to materials live.
*/


/datum/supply_pack/materials
	group = "Materials"

/datum/supply_pack/materials/metal50
	name = "50 metal sheets"
	contains = list(/obj/fiftyspawner/steel)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Metal sheets crate"

/datum/supply_pack/materials/glass50
	name = "50 glass sheets"
	contains = list(/obj/fiftyspawner/glass)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Glass sheets crate"

/datum/supply_pack/materials/wood50
	name = "50 wooden planks"
	contains = list(/obj/fiftyspawner/wood)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Wooden planks crate"

/datum/supply_pack/materials/plastic50
	name = "50 plastic sheets"
	contains = list(/obj/fiftyspawner/plastic)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Plastic sheets crate"

/datum/supply_pack/materials/cardboard_sheets
	contains = list(/obj/fiftyspawner/cardboard)
	name = "50 cardboard sheets"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Cardboard sheets crate"

/datum/supply_pack/materials/carpet
	name = "Imported carpet"
	containertype = /obj/structure/closet/crate
	containername = "Imported carpet crate"
	cost = 15
	contains = list(
					/obj/fiftyspawner/carpet,
					/obj/fiftyspawner/tealcarpet
					)

//wood zone
/datum/supply_pack/materials/wood50
	name = "50 wooden planks"
	contains = list(/obj/item/stack/material/wood/fifty)
	cost = 10
	containername = "wooden planks crate"

/datum/supply_pack/materials/mahogany25
	name = "25 mahogany planks"
	contains = list(/obj/item/stack/material/wood/mahogany/twentyfive)
	cost = 10
	containername = "wooden planks crate"

/datum/supply_pack/materials/maple25
	name = "25 maple planks"
	contains = list(/obj/item/stack/material/wood/maple/twentyfive = 2)
	cost = 10
	containername = "wooden planks crate"

/datum/supply_pack/materials/walnut25
	name = "25 walnut planks"
	contains = list(/obj/item/stack/material/wood/walnut/twentyfive)
	cost = 10
	containername = "walnut planks crate"

/datum/supply_pack/materials/ebony25
	name = "25 ebony planks"
	contains = list(/obj/item/stack/material/wood/ebony/twentyfive)
	cost = 15 //luxury tax
	containername = "ebony planks crate"


/datum/supply_pack/misc/linoleum
	name = "Linoleum"
	containertype = /obj/structure/closet/crate
	containername = "Linoleum crate"
	cost = 15
	contains = list(/obj/fiftyspawner/linoleum)

/datum/supply_pack/materials/road50
	name = "50 road tiles"
	contains = list(/obj/fiftyspawner/road)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Road tiles crate"

/datum/supply_pack/materials/pavement50
	name = "50 pavement tiles"
	contains = list(/obj/fiftyspawner/pavement)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Pavement tiles crate"


