/obj/vehicle/train/cargo/engine/motorcycle/moped/space
	name = "space-moped"
	desc = "Space wheelies! Woo! "
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	plane = -25
	land_speed = 10 //if 0 it can't go on turf
	space_speed = 1
	var/datum/effect/effect/system/ion_trail_follow/ion

/obj/vehicle/train/cargo/engine/motorcycle/moped/space/New()
	..()
	ion = new /datum/effect/effect/system/ion_trail_follow()
	ion.set_up(src)

/obj/vehicle/train/cargo/engine/motorcycle/moped/space/turn_on()
	ion.start()
	anchored = 1

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()
	..()

/obj/vehicle/train/cargo/engine/motorcycle/moped/space/turn_off()
	ion.stop()
	anchored = kickstand

	update_icon()

	..()

/obj/vehicle/train/cargo/engine/motorcycle/moped/space/Destroy()
	qdel(ion)

	..()