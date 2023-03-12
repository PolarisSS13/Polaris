
/datum/gear/pipe
	display_name = "pipe"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/pipe/New()
	..()
	var/list/pipes = list()
	for(var/pipe_style in typesof(/obj/item/clothing/mask/smokable/pipe))
		var/obj/item/clothing/mask/smokable/pipe/pipe = pipe_style
		pipes[initial(pipe.name)] = pipe
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pipes))

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/storage/box/matches

/datum/gear/lighter
	display_name = "lighter, cheap"
	path = /obj/item/flame/lighter

/datum/gear/lighter/zippo
	display_name = "lighter, zippo selection"
	path = /obj/item/flame/lighter/zippo

/datum/gear/lighter/zippo/New()
	..()
	var/list/zippos = list()
	for(var/zippo in typesof(/obj/item/flame/lighter/zippo))
		var/obj/item/flame/lighter/zippo/zippo_type = zippo
		zippos[initial(zippo_type.name)] = zippo_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(zippos))

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/material/ashtray/plastic

/datum/gear/cigar
	display_name = "cigar"
	path = /obj/item/clothing/mask/smokable/cigarette/cigar

/datum/gear/cigarettes
	display_name = "cigarette selection"
	path = /obj/item/storage/fancy/cigarettes

/datum/gear/cigarettes/New()
	..()
	var/list/cigarettes = list()
	for(var/cigarette in (typesof(/obj/item/storage/fancy/cigarettes)))
		var/obj/item/storage/fancy/cigarettes/cigarette_brand = cigarette
		cigarettes[initial(cigarette_brand.name)] = cigarette_brand
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cigarettes))

/datum/gear/ecig
	display_name = "electronic cigarette"
	path = /obj/item/clothing/mask/smokable/ecig/util

/datum/gear/ecig_simple
	display_name = "electronic cigarette, simple"
	path = /obj/item/clothing/mask/smokable/ecig/simple

/datum/gear/ecig_deluxe
	display_name = "electronic cigarette, deluxe"
	path = /obj/item/clothing/mask/smokable/ecig/deluxe
	cost = 2
