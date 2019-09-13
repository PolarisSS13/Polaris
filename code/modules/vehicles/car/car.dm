/obj/vehicle/car //vroom vroom.
	name = "motor car"
	desc = "A motor car that runs off sustainable electricity. This is a generic model that can be spraypainted onto with a spraycan."
	icon = 'icons/vehicles/car.dmi'
	icon_state = "sportscar"
	on = 1
	powered = 1
	locked = 0
	var/obj/item/weapon/key/car/key
	var/riding_datum_type = /datum/riding/car
	pixel_x = -16
	move_delay = 0.2
	move_speed = 0.1

	max_buckled_mobs = 2
	mechanical = 1
	maxhealth = 200
	health = 200


	var/cooldowntime
	var/spam_flag = 0
	var/horn_sound = 'sound/vehicles/car_horn.ogg'
	var/engine_start = 'sound/vehicles/ignition.ogg'
	var/engine_fail = 'sound/vehicles/wontstart.ogg'

	var/drive_sound = 'sound/vehicles/cardrive.ogg'
	var/land_speed = ""
	var/space_speed = 0 //if 0 it can't go in space

//For customization (Custom whitelisting, you get me?)
	var/custom_frame = FALSE
	var/frame_state = "sportscar" //Custom-item proofing!
	var/key_type = /obj/item/weapon/key/car
	var/cell_type = /obj/item/weapon/cell/car
	paint_color = "#ffffff"

//license is generated via "[license code] - [license number]"
	var/license_code = "GEM"
	var/license_number = 100
	var/license_plate_no
	var/has_license = 1


/obj/vehicle/car/New()
	. = ..()
	riding_datum = new riding_datum_type(src)
	cell = new cell_type(src)
	key = new key_type(src)
	turn_off()
	generate_license()
	update_icon()

/obj/vehicle/car/initialize() // Time for some science!
	..()
	land_speed = 0.5

/obj/vehicle/car/remove_cell(var/mob/living/carbon/human/H)
	to_chat(H, "You try to remove [cell] but it appears to be welded firmly inside.")


/obj/vehicle/car/turn_on()
	if(!mechanical || stat)
		return FALSE
	if(powered && cell.charge < charge_use)
		return FALSE
	on = 1
	set_light(initial(light_range))
	return TRUE

/obj/vehicle/car/turn_off()
	if(!mechanical)
		return FALSE
	on = 0
	set_light(0)

/obj/vehicle/car/proc/generate_license()

	license_number = rand(100, 999)
	license_plate_no = "[license_code]-[license_number]"

/obj/vehicle/car/examine(mob/user)
	..()
	if(has_license)
		user << "The license plate reads <b>[license_plate_no]</b> in bold black letters."
	user << "The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition."
	user << "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%"
	user << "Car integrity is [health]/[maxhealth]."

/obj/vehicle/car/attackby(obj/item/weapon/pen/crayon/spraycan/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen/crayon/spraycan))
		if(W.capped)
			user << "The spraycan is still capped! Uncap it first."
		else
			var/car_color = W.colour
			user << "You start painting the [src]."
			playsound(loc, 'sound/effects/spraycan_shake.ogg', 5, 1, 5)
			do_after(user, 50)
			add_fingerprint(user)
			paint_color = car_color
			if(W.uses)
				W.uses--
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


/obj/vehicle/car/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, key_type))
		if(!key)
			user.drop_item()
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/car/verb/remove_key
		return
	..()

/obj/vehicle/car/proc/has_key()
	if(key)
		return 1
	else
		return 0





/////
//EMAG FUN
//


/obj/vehicle/car/emag_act(var/remaining_charges, mob/user as mob)
	if(!mechanical)
		return FALSE

	if(!emagged)
		emagged = 1
		if(locked)
			locked = 0
			to_chat(user, "<span class='warning'>You swipe the [src]'s controls, deactivating [src]'s safety mechanisms.</span>")
		return TRUE
// ////
//Damage related

/obj/vehicle/car/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/vehicle/car/proc/honk_horn()
	playsound(src, horn_sound,40,1)
