/datum/seed/fjylozyn
	name = "fjylozyn"
	seed_name = "fjylozyn"
	display_name = "fjylozyn"
	mutants = null
	chems = list("nutriment" = list(3, 5), "toxin" = list(2, 3))
	kitchen_tag = "fjylozyn"

/datum/seed/fjylozyn/New()
	..()
	set_trait(TRAIT_MATURATION, 8)
	set_trait(TRAIT_PRODUCTION, 3)
	set_trait(TRAIT_POTENCY, 5)
	set_trait(TRAIT_PRODUCT_ICON,"fjylozyn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#990000")
	set_trait(TRAIT_PLANT_COLOUR,"#993333")
	set_trait(TRAIT_PLANT_ICON,"skrellvines")
	set_trait(TRAIT_YIELD, 6)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#990033")
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_WATER_CONSUMPTION, 10)