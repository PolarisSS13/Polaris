// Gloves
/datum/gear/gloves
	display_name = "gloves, black"
	path = /obj/item/clothing/gloves/black
	cost = 2
	slot = slot_gloves
	sort_category = "Gloves and Handwear"

/datum/gear/gloves/color
	display_name = "gloves, colored selection"
	path = /obj/item/clothing/gloves/black
	cost = 1

/datum/gear/gloves/color/New()
	..()
	var/list/glovetype = list(
	"gloves, black" = /obj/item/clothing/gloves/black,
	"gloves, blue" = path = /obj/item/clothing/gloves/blue,
	"gloves, brown" = /obj/item/clothing/gloves/brown,
	"gloves, light-brown" = /obj/item/clothing/gloves/light_brown,
	"gloves, green" = /obj/item/clothing/gloves/green,
	"gloves, grey" = /obj/item/clothing/gloves/grey,
	"gloves, orange" = /obj/item/clothing/gloves/orange,
	"gloves, purple" = /obj/item/clothing/gloves/purple,
	"gloves, rainbow" = /obj/item/clothing/gloves/rainbow,
	"gloves, red" = /obj/item/clothing/gloves/red,
	"gloves, white" = /obj/item/clothing/gloves/white
	)
	gear_tweaks += new/datum/gear_tweak/path(glovetype)

/datum/gear/gloves/latex
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/sterile/latex
	cost = 2

/datum/gear/gloves/nitrile
	display_name = "gloves, nitrile"
	path = /obj/item/clothing/gloves/sterile/nitrile
	cost = 2
/datum/gear/gloves/evening
	display_name = "gloves, evening (colorable)"
	path = /obj/item/clothing/gloves/evening
	cost = 1

/datum/gear/gloves/evening/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/duty
	display_name = "gloves, duty"
	path = /obj/item/clothing/gloves/duty
	cost = 2

/datum/gear/gloves/forensic
	display_name = "gloves, forensic (Detective)"
	path = /obj/item/clothing/gloves/forensic
	allowed_roles = list("Detective")
	cost = 1

/datum/gear/gloves/fingerless
	display_name = "gloves, fingerless (colorable)"
	path = /obj/item/clothing/gloves/fingerless
	cost = 1

/datum/gear/gloves/fingerless/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/ring
	display_name = "ring selection"
	description = "Choose from a number of rings."
	path = /obj/item/clothing/gloves/ring
	cost = 1

/datum/gear/gloves/ring/New()
	..()
	var/list/ringtype = list(
	"CTI ring" = /obj/item/clothing/gloves/ring/cti,
	"Mariner University ring" = /obj/item/clothing/gloves/ring/mariner,
	"engagement ring" = /obj/item/clothing/gloves/ring/engagement,
	"signet ring" = /obj/item/clothing/gloves/ring/seal/signet,
	"masonic ring" = /obj/item/clothing/gloves/ring/seal/mason,
	"ring, glass" = /obj/item/clothing/gloves/ring/material/glass,
	"ring, wood" = /obj/item/clothing/gloves/ring/material/wood,
	"ring, plastic" = /obj/item/clothing/gloves/ring/material/plastic,
	"ring, iron" = /obj/item/clothing/gloves/ring/material/iron,
	"ring, bronze" = /obj/item/clothing/gloves/ring/material/bronze,
	"ring, steel" = /obj/item/clothing/gloves/ring/material/steel,
	"ring, copper" = /obj/item/clothing/gloves/ring/material/copper,
	"ring, silver" = /obj/item/clothing/gloves/ring/material/silver,
	"ring, gold" = /obj/item/clothing/gloves/ring/material/gold,
	"ring, platinum" = /obj/item/clothing/gloves/ring/material/platinum
	)
	gear_tweaks += new/datum/gear_tweak/path(ringtype)

/datum/gear/gloves/circuitry
	display_name = "gloves, circuitry (empty)"
	path = /obj/item/clothing/gloves/circuitry
	cost = 1

/datum/gear/gloves/botanic_leather
	display_name = "gloves, botanic leather"
	path = /obj/item/clothing/gloves/botanic_leather
	cost = 2
