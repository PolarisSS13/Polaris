
/datum/cultist
	var/name = "cultist thing"
	var/desc = "If you can see this, something broke."
	var/cost = 30
	var/hidden = 0
	var/obj_path = null
	var/ability_icon_state = null
	var/category = null

/datum/cultist/spell
	category = CULT_ALL_SPELLS
	var/spell_power_desc = null


/*
 * Artifice, produced usually in the Forge.
 */

/datum/cultist/artifice
	category = CULT_ALL_ARTIFICE
	cost = 50
	var/list/material_cost = list()

/datum/cultist/artifice/bloodsteel
	name = "hemosteel"
	desc = "A material reinforced with living energy, rivalling the durability of plasteel."
	category = CULT_ALL_ARTIFICE
	material_cost = list(
	/obj/item/stack/material/steel = 1
	)
	obj_path = /obj/item/stack/material/bloodsteel

/datum/cultist/artifice/spacesuit
	name = "cult space suit"
	desc = "A space suit twisted via living energy into an alchemical masterpiece."
	category = CULT_ALL_ARTIFICE
	material_cost = list(
	/obj/item/clothing/suit/space = 1
	)
	obj_path = /obj/item/clothing/suit/space/cult

/datum/cultist/artifice/spacehelmet
	name = "cult space helmet"
	desc = "A space helmet twisted via living energy into an alchemical masterpiece."
	category = CULT_ALL_ARTIFICE
	material_cost = list(
	/obj/item/clothing/head/helmet/space = 1
	)
	obj_path = /obj/item/clothing/head/helmet/space/cult

/datum/cultist/artifice/crystalball
	name = "crystal ball"
	desc = "A perfect sphere of glass. It could be used as the focus for alchemical ."
	category = CULT_ALL_ARTIFICE
	material_cost = list(
	/obj/item/stack/material/glass = 5
	)
	obj_path = /obj/item/device/crystalball
