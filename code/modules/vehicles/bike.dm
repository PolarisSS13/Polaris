/obj/vehicle/train/cargo/engine/motorcycle/moped
	name = "electic moped"
	desc = "For the biker in all of us."
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	dir = SOUTH

	load_item_visible = 1
	mob_offset_y = 5
	health = 100
	maxhealth = 100

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/protection_percent = 60





/obj/vehicle/train/cargo/engine/motorcycle/moped/New()
	..()
	turn_off()
	overlays += image('icons/obj/bike.dmi', "[icon_state]_off_overlay", MOB_LAYER + 1)
	icon_state = "[bike_icon]_off"

/obj/vehicle/train/cargo/engine/motorcycle/moped/verb/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	if(usr.incapacitated()) return

	if(!on)
		turn_on()
		src.visible_message("\The [src] rumbles to life.", "You hear something rumble deeply.")
	else
		turn_off()
		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")



/obj/vehicle/train/cargo/engine/motorcycle/moped/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/train/cargo/engine/motorcycle/moped/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		user << "<span class='warning'> You were unable to load \the [C] onto \the [src].</span>"
		return
/*
/obj/vehicle/train/cargo/engine/motorcycle/moped/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		user << "You unbuckle yourself from \the [src]"
*/
/obj/vehicle/train/cargo/engine/motorcycle/moped/relaymove(mob/user, direction)
	if(user != load || !on)
		return
	return Move(get_step(src, direction))
/*
/obj/vehicle/train/cargo/engine/motorcycle/moped/Move(var/turf/destination)
	if(kickstand) return


	//these things like space, not turf. Dragging shouldn't weigh you down.
	if(istype(destination,/turf/space) || pulledby)
		if(!space_speed)
			return 0
		move_delay = space_speed
	else
		if(!land_speed)
			return 0
		move_delay = land_speed
	return ..()
*/
/obj/vehicle/train/cargo/engine/motorcycle/moped/turn_on()
	anchored = 1

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()
	..()
/obj/vehicle/train/cargo/engine/motorcycle/moped/turn_off()

	anchored = kickstand

	update_icon()

	..()

/obj/vehicle/train/cargo/engine/motorcycle/moped/bullet_act(var/obj/item/projectile/Proj)
	if(has_buckled_mobs() && prob(protection_percent))
		var/mob/living/L = pick(buckled_mobs)
		L.bullet_act(Proj)
		return
	..()

/obj/vehicle/train/cargo/engine/motorcycle/moped/update_icon()
	overlays.Cut()

	if(on)
		overlays += image('icons/obj/bike.dmi', "[bike_icon]_on_overlay", MOB_LAYER + 1)
		icon_state = "[bike_icon]_on"
	else
		overlays += image('icons/obj/bike.dmi', "[bike_icon]_off_overlay", MOB_LAYER + 1)
		icon_state = "[bike_icon]_off"

	..()


