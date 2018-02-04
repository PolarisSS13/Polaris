/obj/item/clothing/gloves/yellow
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	siemens_coefficient = 0
	permeability_coefficient = 0.05

/obj/item/clothing/gloves/fyellow                             //Cheap Space Chinese Crap
	desc = "These gloves are cheap copies of the coveted insulated gloves - not as protective, but still better than nothing."
	name = "budget insulated gloves"
	icon_state = "yellow"
	siemens_coefficient = 0.40 //better than black gloves, not as good as real insulated gloves
	permeability_coefficient = 0.05

/obj/item/clothing/gloves/black
	desc = "These work gloves are thick and fire-resistant."
	name = "black gloves"
	icon_state = "black"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/orange
	name = "orange gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "orange"

/obj/item/clothing/gloves/red
	name = "red gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "red"

/obj/item/clothing/gloves/rainbow
	name = "rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"

/obj/item/clothing/gloves/blue
	name = "blue gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "blue"

/obj/item/clothing/gloves/purple
	name = "purple gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "purple"

/obj/item/clothing/gloves/green
	name = "green gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green"

/obj/item/clothing/gloves/grey
	name = "grey gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "gray"

/obj/item/clothing/gloves/light_brown
	name = "light brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown"

/obj/item/clothing/gloves/brown
	name = "brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown"

/obj/item/clothing/gloves/evening
	desc = "A pair of gloves that reach past the elbow.  Fancy!"
	name = "evening gloves"
	icon_state = "evening_gloves"
	addblends = "evening_gloves_a"

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

obj/item/clothing/gloves/fingerless
	desc = "A pair of gloves that don't actually cover the fingers."
	name = "fingerless gloves"
	icon_state = "fingerlessgloves"
	fingerprint_chance = 100