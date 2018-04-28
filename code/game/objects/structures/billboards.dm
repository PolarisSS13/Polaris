//BILLBOARDS

/obj/structure/billboard
	name = "billboard"
	desc = "A billboard"
	icon = 'icons/obj/billboards.dmi'
	icon_state = "billboard"
	light_range = 4
	light_power = 2
	light_color = "#ebf7fe"  //white blue
	density = 1
	anchored = 1
	bounds = "64,32"
	layer = MOB_LAYER + 1
	pixel_y = 10

/obj/structure/billboard/Destroy()
	set_light(0)
	return ..()

/obj/structure/billboard/New()
	..()
	icon_state = pick("ssl","ntbuilding","keeptidy")

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