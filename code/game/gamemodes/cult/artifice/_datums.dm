
/datum/cultist
	var/name = "cultist thing"
	var/desc = "If you can see this, something broke."
	var/cost = 30
	var/hidden = 0
	var/obj_path = null
	var/category = null
	var/datum_state = "crystal"
	var/icon/datum_icon = 'icons/obj/cult_icons.dmi'

/*
 * Artifice, produced usually in the Forge.
 */

GLOBAL_LIST_EMPTY(cultforge_recipe_list)

/hook/startup/proc/setup_cultforge_datums()
	for(var/path in subtypesof(/datum/cultist/artifice))
		GLOB.cultforge_recipe_list |= new path()

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
	desc = "A perfect sphere of glass. It could be used as the focus for alchemical."
	category = CULT_ALL_ARTIFICE
	cost = 200
	material_cost = list(
	/obj/item/stack/material/glass = 5
	)
	obj_path = /obj/item/device/crystalball

/datum/cultist/artifice/spellstone
	name = "pristine crystal ball"
	desc = "A perfect sphere of crystal. It is a perfect focus to bend the alchemical laws."
	category = CULT_ALL_ARTIFICE
	cost = 300
	material_cost = list(
	/obj/item/device/crystalball = 1
	)
	obj_path = /obj/item/device/crystalball/advanced

/*
 * Spell datums.
 */

GLOBAL_LIST_EMPTY(cultspell_list)

/hook/startup/proc/setup_cultspell_datums()
	for(var/path in subtypesof(/datum/cultist/spell))
		GLOB.cultspell_list |= new path()

/datum/cultist/spell
	cost = 100
	category = CULT_ALL_SPELLS
	var/ability_icon_state
	var/needs_tome = FALSE
