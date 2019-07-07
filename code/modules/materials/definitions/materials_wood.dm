
/material/wood
	name = MAT_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#664c15"
	integrity = 50
	icon_base = "wood"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 18
	protectiveness = 8 // 28%
	conductivity = 1
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"

/material/wood/log
	name = MAT_LOG
	icon_base = "log"
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"

/material/wood/log/sif
	name = MAT_SIFLOG
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/material/wood/holographic
	name = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/material/wood/sif
	name = MAT_SIFWOOD
//	stack_type = /obj/item/stack/material/wood/sif
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/material/cardboard
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#AAAAAA"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	radiation_resistance = 1

// To be implemented
/*
/material/paper
	name = "paper"
*/


/material/wood/mahogany
	name = MATERIAL_MAHOGANY
//	lore_text = "Mahogany is prized for its beautiful grain and rich colour, and as such is typically used for fine furniture and cabinetry."
//	adjective_name = MATERIAL_MAHOGANY
	icon_colour = WOOD_COLOR_RICH
//	construction_difficulty = 2
//	sale_price = 3


/material/wood/maple
	name = MATERIAL_MAPLE
//	lore_text = "Owing to its fast growth and ease of working, silver maple is a popular wood for flooring and furniture."
//	adjective_name = MATERIAL_MAPLE
	icon_colour = WOOD_COLOR_PALE

/material/wood/ebony
	name = MATERIAL_EBONY
//	lore_text = "Ebony is the name for a group of dark coloured, extremely dense, and fine grained hardwoods. \
				Despite gene modification to produce larger source trees and ample land to plant them on, \
				genuine ebony remains a luxury for the very wealthy thanks to the price fixing efforts of intergalactic luxuries cartels. \
				Most people will only ever touch ebony in small items, such as chess pieces, or the accent pieces of a fine musical instrument."
//	adjective_name = MATERIAL_EBONY
	icon_colour = WOOD_COLOR_BLACK
	weight = 22
//	sale_price = 4

/material/wood/walnut
	name = MATERIAL_WALNUT
//	lore_text = "Walnut is a dense hardwood that polishes to a very fine finish. \
				Walnut is especially favoured for construction of figurines (where it contrasts with lighter coloured woods) and tables. \
				The ultimate aspiration of many professionals is an office with a vintage walnut desk, the bigger and heavier the better."
//	adjective_name = MATERIAL_WALNUT
	icon_colour = WOOD_COLOR_CHOCOLATE
	weight = 20
//	sale_price = 2