/obj/vehicle/car //vroom vroom.
	name = "electric all terrain vehicle"
	desc = "A ridable electric ATV designed for all terrain. Except space."
	icon = 'icons/vehicles/car.dmi'
	icon_state = "sportscar"
	on = 1
	powered = 1
	locked = 0
	var/key_type = /obj/item/weapon/key/quadbike
	var/obj/item/weapon/key/key
	pixel_x = -16
	var/riding_datum_type = /datum/riding/car
	move_delay = 0
	var/frame_state = "sportscar" //Custom-item proofing!
	var/custom_frame = FALSE
	var/cooldowntime
	var/spam_flag = 0
	var/horn_sound = 'sound/vehicles/car_horn.ogg'
	max_buckled_mobs = 2
	paint_color = "#ffffff"
	var/engine_start = 'sound/vehicles/ignition.ogg'
	var/engine_fail = 'sound/vehicles/wontstart.ogg'
	var/land_speed = 0.1
	var/space_speed = 0 //if 0 it can't go in space

/obj/vehicle/car/New()
	riding_datum = new riding_datum_type(src)
	cell = new /obj/item/weapon/cell/high(src)
	key = new key_type(src)
	turn_off()

/obj/vehicle/car/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen/crayon/spraycan))
		var/new_paint = input("Please select paint color.", "Paint Color", paint_color) as color|null
		if(new_paint)
			user << "You start painting the [src]."
			playsound(loc, 'sound/effects/spraycan_shake.ogg', 5, 1, 5)
			do_after(user, 50)
			add_fingerprint(user)
			paint_color = new_paint
			update_icon()
			return
	..()

/obj/vehicle/car/random/New()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	..()

/obj/vehicle/car/update_icon()
	..()
	overlays.Cut()
	if(custom_frame)
		var/image/Bodypaint = new(icon_state = "[frame_state]_a", layer = src.layer)
		Bodypaint.color = paint_color
		overlays += Bodypaint

		var/image/Overmob = new(icon_state = "[frame_state]_overlay", layer = src.layer + 0.2) //over mobs
		var/image/Overmob_color = new(icon_state = "[frame_state]_overlay_a", layer = src.layer + 0.4) //over the over mobs, gives the color.
		Overmob.plane = MOB_PLANE
		Overmob_color.plane = MOB_PLANE
		Overmob_color.color = paint_color

		overlays += Overmob
		overlays += Overmob_color
		return

	var/image/Bodypaint = new(icon_state = "[frame_state]_a", layer = src.layer)
	Bodypaint.color = paint_color
	overlays += Bodypaint

	var/image/Overmob = new(icon_state = "[frame_state]_overlay", layer = src.layer + 0.2) //over mobs
	var/image/Overmob_color = new(icon_state = "[frame_state]_overlay_a", layer = src.layer + 0.4) //over the over mobs, gives the color.
	Overmob.plane = MOB_PLANE
	Overmob_color.plane = MOB_PLANE
	Overmob_color.color = paint_color

	overlays += Overmob
	overlays += Overmob_color

// Boarding.
/obj/vehicle/car/MouseDrop_T(var/atom/movable/C, mob/user)
	if(ismob(C))
		user_buckle_mob(C, user)
	else
		..(C, user)


/obj/vehicle/car/load(mob/living/L, mob/living/user)
	if(!istype(L)) // Only mobs on boats.
		return FALSE
	..(L, user)





/obj/vehicle/car/Move(var/turf/destination)
	if(on && (!cell || cell.charge < charge_use))
		turn_off()
		visible_message("<span class='warning'>\The [src] whines, before its engines wind down.</span>")
		return 0

	//these things like space, not turf. Dragging shouldn't weigh you down.
	if(on && cell)
		cell.use(charge_use)

	if(istype(destination,/turf/space) || istype(destination, /turf/simulated/floor/water) || pulledby)
		if(!space_speed)
			return 0
		move_delay = space_speed
	else
		if(!land_speed)
			return 0
		move_delay = land_speed
	return ..()


//Load the object "inside" the trolley and add an overlay of it.
//This prevents the object from being interacted with until it has
// been unloaded. A dummy object is loaded instead so the loading
// code knows to handle it correctly.
/obj/vehicle/car/proc/load_object(var/atom/movable/C)
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	var/datum/vehicle_dummy_load/dummy_load = new()
	load = dummy_load

	if(!load)
		return
	dummy_load.actual_load = C
	C.forceMove(src)

	if(load_item_visible)
		C.pixel_x += load_offset_x
		C.pixel_y += load_offset_y
		C.layer = layer

		overlays += C

		//we can set these back now since we have already cloned the icon into the overlay
		C.pixel_x = initial(C.pixel_x)
		C.pixel_y = initial(C.pixel_y)
		C.layer = initial(C.layer)

/obj/vehicle/car/unload(var/mob/user, var/direction)
	if(istype(load, /datum/vehicle_dummy_load))
		var/datum/vehicle_dummy_load/dummy_load = load
		load = dummy_load.actual_load
		dummy_load.actual_load = null
		qdel(dummy_load)
		overlays.Cut()
	..()

/////
//EMAG FUN
//


/obj/vehicle/emag_act(var/remaining_charges, mob/user as mob)
	if(!mechanical)
		return FALSE

	if(!emagged)
		emagged = 1
		if(locked)
			locked = 0
			to_chat(user, "<span class='warning'>You swipe the [src]'s controls, deactivating [src]'s safety mechanisms.</span>")
		return TRUE

/obj/vehicle/car/proc/honk_horn()
	if(on)
		playsound(src, horn_sound,40,1)
	else
		return
