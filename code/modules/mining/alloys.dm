//Alloys that contain subsets of each other's ingredients must be ordered in the desired sequence
//eg. steel comes after plasteel because plasteel's ingredients contain the ingredients for steel and
//it would be impossible to produce.

/datum/alloy
	var/list/requires
	var/product_mod = 1
	var/product
	var/metaltag

/datum/alloy/durasteel
	metaltag = "durasteel"
	requires = list(
		MAT_DIAMOND = 1,
		MAT_PLATINUM = 1,
		"carbon" = 2,
		"hematite" = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/durasteel

/datum/alloy/plasteel
	metaltag = "plasteel"
	requires = list(
		MAT_PLATINUM = 1,
		"carbon" = 2,
		"hematite" = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plasteel

/datum/alloy/steel
	metaltag = MAT_STEEL
	requires = list(
		"carbon" = 1,
		"hematite" = 1
		)
	product = /obj/item/stack/material/steel

/datum/alloy/borosilicate
	metaltag = "borosilicate glass"
	requires = list(
		MAT_PLATINUM = 1,
		"sand" = 2
		)
	product = /obj/item/stack/material/glass/phoronglass

/datum/alloy/bronze
	metaltag = "bronze"
	requires = list(
		MAT_COPPER = 2,
		MAT_TIN = 1
		)
	product = /obj/item/stack/material/bronze
