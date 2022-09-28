// Mask
/datum/gear/mask
	display_name = "mask, sterile"
	path = /obj/item/clothing/mask/surgical
	slot = slot_wear_mask
	sort_category = "Masks and Facewear"

/datum/gear/mask/bandanas
	display_name = "face bandana selection"
	path = /obj/item/clothing/mask/bandana/blue

/datum/gear/mask/bandanas/New()
	..()
	var/list/bandanas = list()
	for(var/bandana in typesof(/obj/item/clothing/mask/bandana))
		var/obj/item/clothing/mask/bandana/bandana_type = bandana
		bandanas[initial(bandana_type.name)] = bandana_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandanas))

/datum/gear/mask/veil
	display_name = "black veil"
	path = /obj/item/clothing/mask/veil

/datum/gear/mask/gasmasks
	display_name = "gas mask selection"
	path = /obj/item/clothing/mask/gas
	cost = 2

/datum/gear/mask/gasmasks/New()
	..()
	var/masks = list()
	masks["gas mask"] = /obj/item/clothing/mask/gas
	masks["clear gas mask"] = /obj/item/clothing/mask/gas/clear
	masks["plague doctor mask"] = /obj/item/clothing/mask/gas/plaguedoctor
	masks["gold plague doctor mask"] = /obj/item/clothing/mask/gas/plaguedoctor/gold
	gear_tweaks += new/datum/gear_tweak/path(masks)

/datum/gear/mask/cloth
	display_name = "mask, cloth (colorable)"
	path = /obj/item/clothing/mask/surgical/cloth
	cost = 2

/datum/gear/mask/cloth/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/mask/dust
	display_name = "mask, dust"
	path = /obj/item/clothing/mask/surgical/dust
	cost = 2
