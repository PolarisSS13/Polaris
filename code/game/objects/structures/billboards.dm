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
	var/ads = list(			"ssl",
							"ntbuilding",
							"keeptidy",
							"smoke",
							"tunguska",
							"rent",
							"vets",
							"army",
							"fitness",
							"movie1",
							"movie2",
							"blank",
							"gentrified",
							"legalcoke",
							"pollux",
							"vacay",
							"atluscity",
							"sunstar",
							"speedweed",
							"golf")

	var/current_ad

/obj/structure/billboard/Destroy()
	set_light(0)
	return ..()

/obj/structure/billboard/New()
	..()
	var/type = rand(1,4)
	if(prob(50))
		icon_state = "[initial(icon_state)][type]"

	update_icon()

/obj/structure/billboard/update_icon()
	overlays.Cut()

	if(!current_ad)
		overlays += pick(ads)
	else
		overlays += current_ad


/obj/structure/billboard/city
	name = "city billboard"
	desc = "A billboard"
	icon_state = "billboard"
	light_range = 4
	light_power = 5
	light_color = "#bbfcb6"  //watered lime
	current_ad = "welcome"

/obj/structure/billboard/sign/lisa
	icon_state = "billboard"
	current_ad = "lisa"