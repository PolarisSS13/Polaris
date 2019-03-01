/obj/vehicle/scooter
	name = "scooter"
	desc = "A fun way to get around."
	icon_state = "scooter"
	var/riding_datum_type = /datum/riding/scooter
	move_delay = 0


/obj/vehicle/scooter/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		to_chat(user, "<span class='notice'>You begin to remove the handlebars...</span>")
		playsound(get_turf(user), 'sound/items/ratchet.ogg', 50, 1)
		if(do_after(user, 40*I.toolspeed, target = src))
			var/obj/vehicle/scooter/skateboard/S = new /obj/vehicle/scooter/skateboard(get_turf(src))
			new /obj/item/stack/rods(get_turf(src),2)
			to_chat(user, "<span class='notice'>You remove the handlebars from [src].</span>")
			if(has_buckled_mobs())
				var/mob/living/carbon/H = buckled_mobs[1]
				unbuckle_mob(H)
				S.buckle_mob(H)
			qdel(src)


/obj/vehicle/scooter/buckle_mob(mob/living/carbon/human/M, force = 0, check_loc = 1)
	riding_datum = new/datum/riding/scooter
	if(!istype(M))
		return 0
	. = ..()

/obj/vehicle/scooter/skateboard
	name = "skateboard"
	desc = "An unfinished scooter which can only barely be called a skateboard. It's still rideable, but probably unsafe. Looks like you'll need to add a few rods to make handlebars."
	icon_state = "skateboard"
	riding_datum_type = /datum/riding/scooter/skateboard
	density = 0
	var/adjusted_speed = TRUE

/obj/vehicle/scooter/skateboard/New()
	. = ..()
	riding_datum = new riding_datum_type(src)

/obj/vehicle/scooter/skateboard/Bump(atom/A)
	..()
	if(A.density && has_buckled_mobs())
		var/mob/living/carbon/H = buckled_mobs[1]
		var/atom/throw_target = get_edge_target_turf(H, pick(NORTH, SOUTH, EAST, WEST))
		unbuckle_mob(H)
		to_chat(H, "<span class='warning'>You crash into the [A] and hit your head!</span>")
		H.throw_at(throw_target, 4, 3)
		H.Paralyse(3)
		visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
		playsound(src, 'sound/effects/bang.ogg', 50, 1)

/obj/vehicle/scooter/skateboard/MouseDrop(atom/over_object)
	var/mob/living/carbon/M = usr
	if(!istype(M) || M.incapacitated() || !Adjacent(M))
		return
	if(has_buckled_mobs() && over_object == M)
		to_chat(M, "<span class='warning'>You can't lift this up when somebody's on it.</span>")
		return
	if(over_object == M)
		var/obj/item/melee/skateboard/board = new /obj/item/melee/skateboard()
		M.put_in_hands(board)
		qdel(src)

/obj/vehicle/scooter/skateboard/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/carbon/M = usr
	if(!istype(M) || M.incapacitated() || !Adjacent(M))
		return
	if(has_buckled_mobs() && over_object == M)
		to_chat(M, "<span class='warning'>You can't lift this up when somebody's on it.</span>")
		return
	if(over_object == M)
		var/obj/item/melee/skateboard/board = new /obj/item/melee/skateboard()
		M.put_in_hands(board)
		qdel(src)

/obj/vehicle/scooter/skateboard/AltClick(mob/user)
	if (!adjusted_speed)
		riding_datum.vehicle_move_delay = 0
		to_chat(user, "<span class='notice'>You adjust the wheels on [src] to make it go faster.</span>")
		adjusted_speed = TRUE
	else
		riding_datum.vehicle_move_delay = 1
		to_chat(user, "<span class='notice'>You adjust the wheels on [src] to make it go slower.</span>")
		adjusted_speed = FALSE

//CONSTRUCTION
/obj/item/scooter_frame
	name = "scooter frame"
	desc = "A metal frame for building a scooter. Looks like you'll need to add some metal to make wheels."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "scooter_frame"

/obj/item/scooter_frame/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		to_chat(user, "<span class='notice'>You deconstruct [src].</span>")
		new /obj/item/stack/rods(get_turf(src),10)
		playsound(get_turf(user), 'sound/items/ratchet.ogg', 50, 1)
		qdel(src)
		return

	else if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/steel/M = I
		if(M.get_amount() < 5)
			to_chat(user, "<span class='warning'>You need at least five steel sheets to make proper wheels!</span>")
			return
		to_chat(user, "<span class='notice'>You begin to add wheels to [src].</span>")
		if(do_after(user, 80, target = src))
			if(!M || M.get_amount() < 5)
				return
			M.use(5)
			to_chat(user, "<span class='notice'>You finish making wheels for [src].</span>")
			new /obj/vehicle/scooter/skateboard(user.loc)
			qdel(src)

/obj/vehicle/scooter/skateboard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		to_chat(user, "<span class='notice'>You begin to deconstruct and remove the wheels on [src]...</span>")
		playsound(get_turf(user), I.usesound, 50, 1)
		if(do_after(user, 20, target = src))
			to_chat(user, "<span class='notice'>You deconstruct the wheels on [src].</span>")
			new /obj/item/stack/material/steel(get_turf(src),5)
			new /obj/item/scooter_frame(get_turf(src))
			if(has_buckled_mobs())
				var/mob/living/carbon/H = buckled_mobs[1]
				unbuckle_mob(H)
			qdel(src)

	else if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/C = I
		if(C.get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two rods to make proper handlebars!</span>")
			return
		to_chat(user, "<span class='notice'>You begin making handlebars for [src].</span>")
		if(do_after(user, 25, target = src))
			if(!C || C.get_amount() < 2)
				return
			to_chat(user, "<span class='notice'>You add the rods to [src], creating handlebars.</span>")
			C.use(2)
			var/obj/vehicle/scooter/S = new/obj/vehicle/scooter(get_turf(src))
			if(has_buckled_mobs())
				var/mob/living/carbon/H = buckled_mobs[1]
				unbuckle_mob(H)
				S.buckle_mob(H)
			qdel(src)

/obj/item/melee/skateboard
	name = "skateboard"
	desc = "A skateboard. It can be placed on its wheels and ridden, or used as a strong weapon."
	icon_state = "skateboard"
	item_state = "skateboard"
	force = 12
	throwforce = 4
	w_class = ITEMSIZE_LARGE
	attack_verb = list("smacked", "whacked", "slammed", "smashed")

/obj/item/melee/skateboard/attack_self(mob/user)
	new /obj/vehicle/scooter/skateboard(get_turf(user))
	qdel(src)


//scooter
/datum/riding/scooter/handle_vehicle_layer()
	if(ridden.dir == SOUTH)
		ridden.layer = ABOVE_MOB_LAYER
	else
		ridden.layer = OBJ_LAYER

/datum/riding/scooter/get_offsets(pass_index) // list(dir = x, y, layer)
	return list("[NORTH]" = list(0), "[SOUTH]" = list(-2), "[EAST]" = list(0), "[WEST]" = list( 2))


/datum/riding/scooter
	vehicle_move_delay = -3//fast

/datum/riding/scooter/skateboard
	vehicle_move_delay = -5//very fast

/datum/riding/scooter/skateboard/get_offsets(pass_index) // list(dir = x, y, layer)
	return list("[NORTH]" = list(0), "[SOUTH]" = list(-2), "[EAST]" = list(0), "[WEST]" = list( 2))
