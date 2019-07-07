// Basically see-through walls. Used for windows
// If nothing has been built on the low wall, you can climb on it

/obj/structure/wall_frame
	name = "low wall"
	desc = "A low wall section which serves as the base of windows, amongst other things."
	icon = 'icons/obj/wall_frame.dmi'
	icon_state = "frame"

	climbable = 1
	anchored = 1
	density = 1
	throwpass = 1
	layer = TABLE_LAYER
	color = COLOR_GUNMETAL
	var/stripe_color
	var/maxhealth = 10
	var/health = 10

	blend_objects = list(/obj/structure/window/framed, /obj/machinery/door) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window, /obj/structure/window/framed)

/obj/structure/wall_frame/New(var/new_loc)
	..(new_loc)

	update_connections(1)
	update_icon()

/obj/structure/wall_frame/initialize()
	. = ..()

/obj/structure/wall_frame/attackby(var/obj/item/weapon/W, var/mob/user)
	src.add_fingerprint(user)

	//grille placing begin
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/ST = W
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == get_dir(src, user))
				to_chat(user, "<span class='notice'>There is a window in the way.</span>")
				return
		if(!in_use)
			if(ST.get_amount() < 2)
				to_chat(user, "<span class='warning'>You need at least two rods to do this.</span>")
				return
			to_chat(usr, "<span class='notice'>Assembling grille...</span>")
			ST.in_use = 1
			if (!do_after(user, 10))
				ST.in_use = 0
				return
			var/obj/structure/grille/F = new /obj/structure/grille(loc)
			to_chat(usr, "<span class='notice'>You assemble a grille</span>")
			ST.in_use = 0
			F.add_fingerprint(usr)
			ST.use(2)
		return
	//grille placing end

	//window placing begin
	else if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(!ST.material.created_window)
			return 0

		var/dir_to_set = 1
		if(loc == user.loc)
			dir_to_set = user.dir
		else
			if( ( x == user.x ) || (y == user.y) ) //Only supposed to work for cardinal directions.
				if( x == user.x )
					if( y > user.y )
						dir_to_set = 2
					else
						dir_to_set = 1
				else if( y == user.y )
					if( x > user.x )
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				to_chat(user, "<span class='notice'>You can't reach.</span>")
				return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)
				to_chat(user, "<span class='notice'>There is already a window facing this way there.</span>")
				return
		to_chat(user, "<span class='notice'>You start placing the window.</span>")
		if(do_after(user,20,src))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
					to_chat(user, "<span class='notice'>There is already a window facing this way there.</span>")
					return

			var/wtype = ST.material.created_window
			if (ST.use(1))
				var/obj/structure/window/WD = new wtype(loc, dir_to_set, 1)
				to_chat(user, "<span class='notice'>You place the [WD] on [src].</span>")
				WD.update_icon()
		return
	//window placing end

	..()
	return

/obj/structure/wall_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return 1
	if(istype(mover) && climbable)
		return 1

// icon related

// icon related

/obj/structure/wall_frame/update_icon()
	overlays.Cut()
	var/image/I


	for(var/i = 1 to 4)
		if(other_connections[i] != "0")
			I = image('icons/obj/wall_frame.dmi', "frame_other[connections[i]]", dir = 1<<(i-1))
		else
			I = image('icons/obj/wall_frame.dmi', "frame[connections[i]]", dir = 1<<(i-1))
		overlays += I

	if(stripe_color)
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image('icons/obj/wall_frame.dmi', "stripe_other[connections[i]]", dir = 1<<(i-1))
			else
				I = image('icons/obj/wall_frame.dmi', "stripe[connections[i]]", dir = 1<<(i-1))
			I.color = stripe_color
			overlays += I

/obj/structure/wall_frame/titanium
	color = COLOR_TITANIUM

/obj/structure/wall_frame/hull
	color = COLOR_HULL

/obj/structure/wall_frame/blue
	color = COLOR_BLUE_GRAY

/*
/obj/structure/wall_frame/hull/initialize()
	. = ..()
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			color = adjust_brightness(color, bleach_factor)
	update_icon()
*/