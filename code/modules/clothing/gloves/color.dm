/obj/item/clothing/gloves/yellow
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05

/obj/item/clothing/gloves/fyellow                             //Cheap Chinese Crap
	desc = "These gloves are cheap copies of the coveted gloves, no way this can end badly."
	name = "budget insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in New()
	permeability_coefficient = 0.05

	New()
		//average of 0.5, somewhat better than regular gloves' 0.75
		siemens_coefficient = pick(0,0.1,0.3,0.5,0.5,0.75,1.35)

/obj/item/clothing/gloves/black
	desc = "These work gloves are thick and fire-resistant."
	name = "black gloves"
	icon_state = "black"
	item_state = "bgloves"
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
	item_state = "orangegloves"

/obj/item/clothing/gloves/red
	name = "red gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "red"
	item_state = "redgloves"

/obj/item/clothing/gloves/rainbow
	name = "rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"
	item_state = "rainbowgloves"

/obj/item/clothing/gloves/blue
	name = "blue gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "blue"
	item_state = "bluegloves"

/obj/item/clothing/gloves/purple
	name = "purple gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "purple"
	item_state = "purplegloves"

/obj/item/clothing/gloves/green
	name = "green gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green"
	item_state = "greengloves"

/obj/item/clothing/gloves/grey
	name = "grey gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "gray"
	item_state = "graygloves"

/obj/item/clothing/gloves/light_brown
	name = "light brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown"
	item_state = "lightbrowngloves"

/obj/item/clothing/gloves/brown
	name = "brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown"
	item_state = "browngloves"

/obj/item/clothing/gloves/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "latex"
	item_state = "lgloves"

//Fingerless gloves


/obj/item/clothing/gloves/fingerless
	name = "fingerless white gloves"
	desc = "These would look pretty fancy, if it had the fingers."
	icon_state = "latex_alt"
	item_state = "lgloves_alt"
	species_restricted = list()

/obj/item/clothing/gloves/fingerless/orange
	name = "fingerless orange gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "orange_alt"
	item_state = "orangegloves_alt"

/obj/item/clothing/gloves/fingerless/yellow
	name = "fingerless yellow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "yellow_alt"
	item_state = "ygloves_alt"

/obj/item/clothing/gloves/fingerless/red
	name = "fingerless red gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "red_alt"
	item_state = "redgloves_alt"

/obj/item/clothing/gloves/fingerless/rainbow
	name = "fingerless rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow_alt"
	item_state = "rainbowgloves_alt"

/obj/item/clothing/gloves/fingerless/blue
	name = "fingerless blue gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "blue_alt"
	item_state = "bluegloves_alt"

/obj/item/clothing/gloves/fingerless/purple
	name = "fingerless purple gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "purple_alt"
	item_state = "purplegloves_alt"

/obj/item/clothing/gloves/fingerless/green
	name = "fingerless green gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green_alt"
	item_state = "greengloves_alt"

/obj/item/clothing/gloves/fingerless/grey
	name = "fingerless grey gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "gray_alt"
	item_state = "graygloves_alt"

/obj/item/clothing/gloves/fingerless/light_brown
	name = "fingerless light brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown_alt"
	item_state = "lightbrowngloves_alt"

/obj/item/clothing/gloves/fingerless/brown
	name = "fingerless brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown_alt"
	item_state = "browngloves_alt"

/obj/item/clothing/gloves/fingerless/black
	desc = "These work gloves are thick and fire-resistant."
	name = "fingerless black gloves"
	icon_state = "black_alt"
	item_state = "bgloves_alt"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE