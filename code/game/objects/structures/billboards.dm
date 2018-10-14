//BILLBOARDS

/obj/structure/billboard
	name = "billboard ad"
	desc = "Goodness, what are they selling us this time?"
	icon = 'icons/obj/billboards.dmi'
	icon_state = "billboard"
	light_range = 4
	light_power = 2
	light_color = "#ebf7fe"  //white blue
	density = 1
	anchored = 1
	bounds = "64,32"
	plane = ABOVE_PLANE
	layer = ABOVE_MOB_LAYER
	pixel_y = 10

/obj/structure/billboard/Destroy()
	set_light(0)
	return ..()

/obj/structure/billboard/New()
	..()
	icon_state = pick("ssl",
							"ntbuilding",
							"keeptidy",
							"smoke",
							"tunguska",
							"rent",
							"vets")

/obj/structure/billboard/city
	name = "city billboard"
	desc = "A billboard"
	icon_state = "welcome"
	light_range = 4
	light_power = 5
	light_color = "#bbfcb6"  //watered lime

/obj/structure/billboard/city/Destroy()
	set_light(0)
	return ..()

/obj/structure/billboard/city/New()
	..()
	icon_state = "welcome"

/obj/structure/billboard/sign
	name = "city billboard"
	icon_state = "welcome"
	light_color = "#bbfcb6"  //watered lime
	var/sign_type = "welcome"

/obj/structure/billboard/sign/New()
	..()
	icon_state = "[sign_type]"