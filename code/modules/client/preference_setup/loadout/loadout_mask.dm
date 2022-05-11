// Mask
/datum/gear/mask
	display_name = "bandana, blue"
	path = /obj/item/clothing/mask/bandana/blue
	slot = slot_wear_mask
	sort_category = "Masks and Facewear"

/datum/gear/mask/gold
	display_name = "bandana, gold"
	path = /obj/item/clothing/mask/bandana/gold

/datum/gear/mask/green
	display_name = "bandana, green 2"
	path = /obj/item/clothing/mask/bandana/green

/datum/gear/mask/red
	display_name = "bandana, red"
	path = /obj/item/clothing/mask/bandana/red

/datum/gear/mask/sterile
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

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
	display_name = "cloth mask (recolorable)"
	path = /obj/item/clothing/mask/surgical/cloth
	cost = 2

/datum/gear/mask/cloth/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/mask/dust
	display_name = "dust mask"
	path = /obj/item/clothing/mask/surgical/dust
	cost = 2