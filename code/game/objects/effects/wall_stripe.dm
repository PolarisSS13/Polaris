//Stripes the wall it spawns on, then dies
/obj/effect/paint_stripe
	name = "stripe of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	plane = TURF_PLANE
	layer = ABOVE_PLANE
	blend_mode = BLEND_MULTIPLY

/obj/effect/paint_stripe/initialize()
	..()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.stripe_color = color
		W.update_icon()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.stripe_color = color
	return qdel(src)

/obj/effect/paint_stripe/green
	color = COLOR_GREEN_GRAY

/obj/effect/paint_stripe/red
	color = COLOR_RED_GRAY

/obj/effect/paint_stripe/paleblue
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/paint_stripe/yellow
	color = COLOR_BROWN

/obj/effect/paint_stripe/blue
	color = COLOR_BLUE_GRAY

/obj/effect/paint_stripe/brown
	color = COLOR_DARK_BROWN

/obj/effect/paint_stripe/mauve
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/paint_stripe/white
	color = COLOR_SILVER