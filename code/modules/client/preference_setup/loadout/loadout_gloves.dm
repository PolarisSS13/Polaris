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
	var/glovetype = list()
	glovetype["gloves, black"] = /obj/item/clothing/gloves/black
	glovetype["gloves, blue"] = path = /obj/item/clothing/gloves/blue
	glovetype["gloves, brown"] = /obj/item/clothing/gloves/brown
	glovetype["gloves, light-brown"] = /obj/item/clothing/gloves/light_brown
	glovetype["gloves, green"] = /obj/item/clothing/gloves/green
	glovetype["gloves, grey"] = /obj/item/clothing/gloves/grey
	glovetype["gloves, orange"] = /obj/item/clothing/gloves/orange
	glovetype["gloves, purple"] = /obj/item/clothing/gloves/purple
	glovetype["gloves, rainbow"] = /obj/item/clothing/gloves/rainbow
	glovetype["gloves, red"] = /obj/item/clothing/gloves/red
	glovetype["gloves, white"] = /obj/item/clothing/gloves/white
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
	var/ringtype = list()
	ringtype["CTI ring"] = /obj/item/clothing/gloves/ring/cti
	ringtype["Mariner University ring"] = /obj/item/clothing/gloves/ring/mariner
	ringtype["engagement ring"] = /obj/item/clothing/gloves/ring/engagement
	ringtype["signet ring"] = /obj/item/clothing/gloves/ring/seal/signet
	ringtype["masonic ring"] = /obj/item/clothing/gloves/ring/seal/mason
	ringtype["ring, glass"] = /obj/item/clothing/gloves/ring/material/glass
	ringtype["ring, wood"] = /obj/item/clothing/gloves/ring/material/wood
	ringtype["ring, plastic"] = /obj/item/clothing/gloves/ring/material/plastic
	ringtype["ring, iron"] = /obj/item/clothing/gloves/ring/material/iron
	ringtype["ring, bronze"] = /obj/item/clothing/gloves/ring/material/bronze
	ringtype["ring, steel"] = /obj/item/clothing/gloves/ring/material/steel
	ringtype["ring, copper"] = /obj/item/clothing/gloves/ring/material/copper
	ringtype["ring, silver"] = /obj/item/clothing/gloves/ring/material/silver
	ringtype["ring, gold"] = /obj/item/clothing/gloves/ring/material/gold
	ringtype["ring, platinum"] = /obj/item/clothing/gloves/ring/material/platinum

	gear_tweaks += new/datum/gear_tweak/path(ringtype)

/datum/gear/gloves/circuitry
	display_name = "gloves, circuitry (empty)"
	path = /obj/item/clothing/gloves/circuitry
	cost = 1

/datum/gear/gloves/botanic_leather
	display_name = "gloves, botanic leather"
	path = /obj/item/clothing/gloves/botanic_leather
	cost = 2
