//rename to sportscar if you need
//mostly, my changes just update the C.pixel_ y and x on every iteration of the overlay update proc, since default vehicle code //only does that upon entering. Watch the weird formatting pastebin introduces.

/obj/vehicle/car/sportscar
	name = "retro sports car"
	desc = "A very luxurious vehicle."
	icon = 'icons/vehicles/sportscar.dmi'
	icon_state = "sportscar"
	plane = -25
	bound_width = 64
	bound_height = 64

	fits_passenger = 1
	passenger_item_visible = 1
	load_item_visible = 1
	load_offset_x = 0


		//||pixel_y offset for mob overlay
	mob_offset_y = 7
	passenger_offset_y = 20

	speed = 2 //2 is Fastest

//-------------------------------------------
// Standard procs
//-------------------------------------------

/obj/vehicle/car/sportscar/New()
	..()
	update_dir_car_overlays()

/obj/vehicle/car/sportscar/Move()
	if(usr.incapacitated()) return
	..()
	update_dir_car_overlays()

/obj/vehicle/car/sportscar/RunOver(var/mob/living/carbon/human/H)
	var/list/parts = list(BP_HEAD, BP_TORSO, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

	H.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,3), i++)
		H.apply_damage(rand(1,5), BRUTE, pick(parts))

/obj/vehicle/car/sportscar/attackby(var/obj/item/W, var/mob/user)
	var/obj/item/weapon/grab/G = W
	if(!istype(G))
		return ..()

	if(G.state < 1)
		user << "<span class='danger'>You need a better grip to do that!</span>"
		return

	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || (!user.canmove))
		return

		//||trunk is open and has room
	if(trunk_open && !trunk)
			//||car is empty
		if(!load && !passenger)
			var/choice = alert("Which seat do you want them to take?",,"Driver's", "Passenger's", "The trunk", "Cancel")
			switch(choice)
				if("Driver's")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "driver")
						update_dir_car_overlays()
				if("Passenger's")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "passenger")
						update_dir_car_overlays()
				if("The trunk")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "trunk")
				if("Cancel")
					return
			return
			//||passenger's seat is taken
		if(!load)
			var/choice = alert("Which seat do you want them to take?",,"Driver's", "The trunk", "Cancel")
			switch(choice)
				if("Driver's")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "driver")
						update_dir_car_overlays()
				if("The trunk")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "trunk")
				if("Cancel")
					return
			return
			//||driver's seat is taken
		if(!passenger)
			var/choice = alert("Which seat do you want them to take?",, "Passenger's", "The trunk", "Cancel")
			switch(choice)
				if("Passenger's")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "passenger")
						update_dir_car_overlays()
				if("The trunk")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "trunk")
				if("Cancel")
					return
			return
			//||trunk is closed
	if(!trunk_open || trunk)
			//||car is empty
		if(!load && !passenger)
			var/choice = alert("Which seat do you want them to take?",,"Driver's", "Passenger's", "Cancel")
			switch(choice)
				if("Driver's")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "driver")
						update_dir_car_overlays()
				if("Passenger's")
					if(G.affecting)
						if(!canInteract(user, G.affecting))	return
						var/mob/M = G.affecting
						qdel(G)
						load(M, "passenger")
						update_dir_car_overlays()
				if("Cancel")
					return
			return
			//||passenger's seat is taken
		if(!load)
			if(G.affecting)
				if(!canInteract(user, G.affecting))	return
				var/mob/M = G.affecting
				qdel(G)
				load(M, "driver")
				update_dir_car_overlays()
			return
			//||driver's seat is taken
		if(!passenger)
			if(G.affecting)
				if(!canInteract(user, G.affecting))	return
				var/mob/M = G.affecting
				qdel(G)
				load(M, "passenger")
				update_dir_car_overlays()
			return
	if(!trunk_open)
		usr << "<span class='warning'>Open the trunk first!</span>"
	else if(trunk)
		usr << "<span class='warning'>There is already something in the trunk. Remove [trunk] first before loading [G.affecting] into the trunk.</span>"
	else if(trunk_open && !trunk)
		if(G.affecting)
			var/mob/M = G.affecting
			qdel(G)
			load(M, "trunk")


//| Mousedrop
/obj/vehicle/car/sportscar/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || (!user.canmove) || !user.Adjacent(C) || !istype(C))
		return
	if(istype(C,/obj/vehicle/train))
		return
	if(ismob(C))
			//||trunk is open and has room
		if(trunk_open && !trunk)
				//||car is empty
			if(!load && !passenger)
				var/choice = alert("Which seat do you want them to take?",,"Driver's", "Passenger's", "The trunk", "Cancel")
				switch(choice)
					if("Driver's")
						if(!canInteract(user, C))	return
						if(istype(C,/mob/living/silicon)) return
						load(C, "driver")
						update_dir_car_overlays()
					if("Passenger's")
						if(!canInteract(user, C))	return
						load(C, "passenger")
						update_dir_car_overlays()
					if("The trunk")
						if(!canInteract(user, C))	return
						load(C, "trunk")
					if("Cancel")
						return
				return
				//||passenger's seat is taken
			if(!load)
				var/choice = alert("Which seat do you want them to take?",,"Driver's", "The trunk", "Cancel")
				switch(choice)
					if("Driver's")
						if(!canInteract(user, C))	return
						if(istype(C,/mob/living/silicon)) return
						load(C, "driver")
						update_dir_car_overlays()
					if("The trunk")
						if(!canInteract(user, C))	return
						load(C, "trunk")
					if("Cancel")
						return
				return
				//||driver's seat is taken
			if(!passenger)
				var/choice = alert("Which seat do you want them to take?",, "Passenger's", "The trunk", "Cancel")
				switch(choice)

					if("Passenger's")
						if(!canInteract(user, C))	return
						load(C, "passenger")
						update_dir_car_overlays()
					if("The trunk")
						if(!canInteract(user, C))	return
						load(C, "trunk")
					if("Cancel")
						return
				return
				//||trunk is closed or full
		if(!trunk_open || trunk)
				//||car is empty
			if(!load && !passenger)
				var/choice = alert("Which seat do you want them to take?",,"Driver's", "Passenger's", "Cancel")
				switch(choice)
					if("Driver's")
						if(!canInteract(user, C))	return
						if(istype(C,/mob/living/silicon)) return
						load(C, "driver")
						update_dir_car_overlays()
					if("Passenger's")
						if(!canInteract(user, C))	return
						load(C, "passenger")
						update_dir_car_overlays()
					if("Cancel")
						return
				return
				//||passenger's seat is taken
			if(!load)
				if(!canInteract(user, C))	return
				if(istype(C,/mob/living/silicon)) return
				load(C, "driver")
				update_dir_car_overlays()
				return
				//||driver's seat is taken
			if(!passenger)
				if(!canInteract(user, C))	return
				load(C, "passenger")
				update_dir_car_overlays()
				return
	if(!trunk_open)
		usr << "<span class='warning'>Open the trunk first!</span>"
	else if(trunk)
		usr << "<span class='warning'>There is already something in the trunk. Remove [trunk] first before loading [C] into the trunk.</span>"
	else if(trunk_open && !trunk)
		if(!canInteract(user, C))	return
		load(C, "trunk")

/obj/vehicle/car/sportscar/proc/canInteract(mob/user, atom/movable/C)
	if(user.stat || user.restrained() || !Adjacent(user) || (!user.canmove) || (C && !user.Adjacent(C)) || (C && !istype(C)))
		return 0
	else
		return 1

/obj/vehicle/car/sportscar/attack_hand(mob/living/user as mob)
	if(user.stat || user.restrained() || !Adjacent(user))
		return 0
	if(user != trunk && (user in src)) //||for handling players stuck in src
		user.forceMove(loc)

	src.add_fingerprint(user)
		//|the trunk is open & empty
	if(trunk_open && !trunk)
			//||user is already in the driver's seat; click vehicle to exit
		if(load == user)
			unload(user, "driver")
			if(passenger)
				update_dir_car_overlays()
			return
			//||user is already in the passenger's seat; click vehicle to exit
		if(passenger == user)
			unload(user, "passenger")
			update_dir_car_overlays()
			return
			//||user is already in the trunk; click vehicle to exit
		if(trunk == user)
			unload(user, "trunk")
			return
			//||what happens when there is already a passenger in the car
		if(!load && passenger && passenger != user)
			var/choice = alert("What would you like to do?",,"Enter driver's seat", "Remove passenger", "Climb into trunk","Cancel")
			switch(choice)
				if("Enter driver's seat")
					if(!canInteract(user))	return
					if(istype(user,/mob/living/silicon)) return
					load(user, "driver")
					update_dir_car_overlays()
				if("Remove passenger")
					if(!canInteract(user))	return
					remove_occupant(user, passenger, "passenger")
				if("Climb into trunk")
					if(!canInteract(user))	return
					load(user, "trunk")
				if("Cancel")
					return
			return
			//||what happens when there is already a driver in the car
		if(load && !passenger && load != user)
			var/choice = alert("What would you like to do?",,"Enter passenger's seat", "Remove driver", "Climb into trunk", "Cancel")
			switch(choice)
				if("Enter passenger's seat")
					if(!canInteract(user))	return
					load(user, "passenger")
					update_dir_car_overlays()
				if("Remove driver")
					if(!canInteract(user))	return
					remove_occupant(user, load, "driver")
				if("Climb into trunk")
					if(!canInteract(user))	return
					load(user, "trunk")
				if("Cancel")
					return
			return
			//||what happens when there are two people in the car
		if(load && passenger && load != user && passenger != user)
			var/choice = alert("What would you like to do?",,"Remove driver", "Remove passenger", "Climb into trunk", "Cancel")
			switch(choice)
				if("Remove driver")
					if(!canInteract(user))	return
					remove_occupant(user, load, "driver")
				if("Remove passenger")
					if(!canInteract(user))	return
					remove_occupant(user, passenger, "passenger")
				if("Climb into trunk")
					if(!canInteract(user))	return
					load(user, "trunk")
				if("Cancel")
					return
			return
			//||car is empty
		if(!load && !user.buckled && !passenger)
			var/choice = alert("How will you ride?",,"Drive", "Passenger", "In the trunk", "Cancel")
			switch(choice)
				if("Drive")
					if(!canInteract(user))	return
					if(istype(user,/mob/living/silicon)) return
					load(user, "driver")
					update_dir_car_overlays()
				if("Passenger")
					if(!canInteract(user))	return
					load(user, "passenger")
					update_dir_car_overlays()
				if("In the trunk")
					if(!canInteract(user))	return
					load(user, "trunk")
				if("Cancel")
					return
			return
			//|the trunk is open & full
	if(trunk_open && trunk)
			//||user is already in the driver's seat; click vehicle to exit
		if(load == user)
			unload(user, "driver")
			if(passenger)
				update_dir_car_overlays()
			return
			//||user is already in the passenger's seat; click vehicle to exit
		if(passenger == user)
			unload(user, "passenger")
			update_dir_car_overlays()
			return
			//||user is already in the trunk; click vehicle to exit
		if(trunk == user)
			unload(user, "trunk")
			return
			//||what happens when there is already a passenger in the car
		if(!load && passenger && passenger != user)
			var/choice = alert("What would you like to do?",,"Enter driver's seat", "Remove passenger", "Remove from trunk", "Cancel")
			switch(choice)
				if("Enter driver's seat")
					if(!canInteract(user))	return
					if(istype(user,/mob/living/silicon)) return
					load(user, "driver")
					update_dir_car_overlays()
				if("Remove passenger")
					if(!canInteract(user))	return
					remove_occupant(user, passenger, "passenger")
				if("Remove from trunk")
					if(!canInteract(user))	return
					unload(trunk, "trunk")
				if("Cancel")
					return
			return
			//||what happens when there is already a driver in the car
		if(load && !passenger && load != user)
			var/choice = alert("What would you like to do?",,"Enter passenger's seat", "Remove driver", "Remove from trunk", "Cancel")
			switch(choice)
				if("Enter passenger's seat")
					if(!canInteract(user))	return
					load(user, "passenger")
					update_dir_car_overlays()
				if("Remove driver")
					if(!canInteract(user))	return
					remove_occupant(user, load, "driver")
				if("Remove from trunk")
					if(!canInteract(user))	return
					unload(trunk, "trunk")
				if("Cancel")
					return
			return
			//||what happens when there are two people in the car
		if(load && passenger && load != user && passenger != user)
			var/choice = alert("What would you like to do?",,"Remove driver", "Remove passenger", "Remove from trunk", "Cancel")
			switch(choice)
				if("Remove driver")
					if(!canInteract(user))	return
					remove_occupant(user, load, "driver")
				if("Remove passenger")
					if(!canInteract(user))	return
					remove_occupant(user, passenger, "passenger")
				if("Remove from trunk")
					if(!canInteract(user))	return
					unload(trunk, "trunk")
				if("Cancel")
					return
			return
			//||car is empty
		if(!load && !user.buckled && !passenger)
			var/choice = alert("What will you do?",,"Drive", "Be passenger", "Remove from trunk", "Cancel")
			switch(choice)
				if("Drive")
					if(!canInteract(user))	return
					if(istype(user,/mob/living/silicon)) return
					load(user, "driver")
					update_dir_car_overlays()
				if("Be passenger")
					if(!canInteract(user))	return
					load(user, "passenger")
					update_dir_car_overlays()
				if("Remove from trunk")
					if(!canInteract(user))	return
					unload(trunk, "trunk")
				if("Cancel")
					return
			return
		//|the trunk is closed
	if(!trunk_open)
			//||user is already in the driver's seat; click vehicle to exit
		if(load == user)
			unload(user, "driver")
			if(passenger)
				update_dir_car_overlays()
			return
			//||user is already in the passenger's seat; click vehicle to exit
		if(passenger == user)
			unload(user, "passenger")
			update_dir_car_overlays()
			return
			//||user is already in the trunk; click vehicle to exit
		if(trunk == user)
			user << "<span class='warning'>The trunk is closed! You have to force it open.</span>"
			return
			//||what happens when there is already a passenger in the car
		if(!load && passenger && passenger != user)
			var/choice = alert("What would you like to do?",,"Enter driver's seat", "Remove passenger", "Cancel")
			switch(choice)
				if("Enter driver's seat")
					if(!canInteract(user))	return
					if(istype(user,/mob/living/silicon)) return
					load(user, "driver")
					update_dir_car_overlays()
				if("Remove passenger")
					if(!canInteract(user))	return
					remove_occupant(user, passenger, "passenger")
				if("Cancel")
					return
			return
			//||what happens when there is already a driver in the car
		if(load && !passenger && load != user)
			var/choice = alert("What would you like to do?",,"Enter passenger's seat", "Remove driver", "Cancel")
			switch(choice)
				if("Enter passenger's seat")
					if(!canInteract(user))	return
					load(user, "passenger")
					update_dir_car_overlays()
				if("Remove driver")
					if(!canInteract(user))	return
					remove_occupant(user, load, "driver")
				if("Cancel")
					return
			return
			//||what happens when there are two people in the car
		if(load && passenger && load != user && passenger != user)
			var/choice = alert("What would you like to do?",,"Remove driver", "Remove passenger", "Cancel")
			switch(choice)
				if("Remove driver")
					if(!canInteract(user))	return
					remove_occupant(user, load, "driver")
				if("Remove passenger")
					if(!canInteract(user))	return
					remove_occupant(user, passenger, "passenger")
				if("Cancel")
					return
			return
			//||car is empty
		if(!load && !user.buckled && !passenger)
			var/choice = alert("How will you ride?",,"Drive", "Passenger", "Cancel")
			switch(choice)
				if("Drive")
					if(!canInteract(user))	return
					if(istype(user,/mob/living/silicon)) return
					load(user, "driver")
					update_dir_car_overlays()
				if("Passenger")
					if(!canInteract(user))	return
					load(user, "passenger")
					update_dir_car_overlays()
				if("Cancel")
					return
			return

	return 0

/obj/vehicle/car/sportscar/proc/remove_occupant(user, occupant, who)
	var/mob/living/M	= user
	if(M.canmove && (M.last_special <= world.time))
		M.changeNext_move(CLICK_CD_BREAKOUT)
		M.last_special = world.time + CLICK_CD_BREAKOUT

		M << "<span class='warning'>You attempt to pull [occupant] out of the vehicle. (This will take around 5 seconds and you need to stand still)</span>"
		for(var/mob/O in viewers(M))
			O.show_message( "<span class='danger'>[M] attempts to pull [occupant] out of the vehicle!</span>", 1)

		if(do_after(user, 50, 10, needhand = 1, target = src))
			if(M.restrained() || M.buckled)
				return
			for(var/mob/O in viewers(M))
				O.show_message("<span class='danger'>[M] pulls [occupant] out of their seat!</span>", 1)
			user << "<span class='notice'>You successfully remove [occupant] from the vehicle.</span>"
			switch (who)
				if("driver")
					unload(occupant, who)
				if("passenger")
					unload(occupant, who)
			update_dir_car_overlays()
			return
		else
			user << "<span class='notice'>You fail to remove [occupant] from the vehicle.</span>"
			return

/obj/vehicle/car/sportscar/update_dir_car_overlays()
	var/atom/movable/C = src.load
	var/atom/movable/D = src.passenger
	src.overlays = null
	if(src.dir == NORTH||SOUTH||WEST)
		if(src.dir == NORTH)	//|| place car sprite over mobs
			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_north", layer = MOB_LAYER + 0.3)
			src.overlays += I

			src.mob_offset_x = 2
			src.mob_offset_y = 20
				//||move the driver & passenger back to the original layer
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer
			src.passenger_offset_x = 22
			src.passenger_offset_y = 20

		else if(src.dir == SOUTH)

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_south", layer = MOB_LAYER + 0.3)
			overlays += I
				//||move the driver & passenger back to the original layer
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer
			src.mob_offset_x = 20
			src.mob_offset_y = 27

			src.passenger_offset_x = 3
			src.passenger_offset_y = 27

		else if(src.dir == WEST)

			src.mob_offset_x = 34
			src.mob_offset_y = 10
				//||move the driver the one layer above the passenger, so he is displayed properly when they overlap
			if(passenger && load)
				C.layer = default_layer + 0.1
				D.layer = default_layer
			src.passenger_offset_x = 34
			src.passenger_offset_y = 23

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_west", layer = MOB_LAYER + 0.3)
			src.overlays += I
			if(passenger && !load)
				var/image/S = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_west_passenger", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == EAST)

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_east_passenger", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 20
			src.passenger_offset_y = 10
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 20
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_east", layer = MOB_LAYER + 0.3)
				src.overlays += S

	if(ismob(C))
		C.pixel_y = src.mob_offset_y
		C.pixel_x = src.mob_offset_x
	if(ismob(D))
		D.pixel_y = src.passenger_offset_y
		D.pixel_x = src.passenger_offset_x

//New vehicle additions

/obj/vehicle/car/sportscar/policecar
	name = "police car"
	desc = "A vehicle designed for the defenders of the law."
	icon = 'icons/vehicles/policecar.dmi'
	icon_state = "policecar"
	horn_sound = 'sound/vehicles/police_siren.ogg'

/obj/vehicle/car/sportscar/policecar/update_dir_car_overlays()
	var/atom/movable/C = src.load
	var/atom/movable/D = src.passenger
	src.overlays = null
	if(src.dir == NORTH||SOUTH||WEST)
		if(src.dir == NORTH)	//|| place car sprite over mobs
			var/image/I = new(icon = 'icons/vehicles/policecar.dmi', icon_state = "policecar_north", layer = MOB_LAYER + 0.3)
			src.overlays += I

			src.mob_offset_x = 2
			src.mob_offset_y = 20
				//||move the driver & passenger back to the original layer
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer
			src.passenger_offset_x = 22
			src.passenger_offset_y = 20

		else if(src.dir == SOUTH)

			var/image/I = new(icon = 'icons/vehicles/policecar.dmi', icon_state = "policecar_south", layer = MOB_LAYER + 0.3)
			overlays += I
				//||move the driver & passenger back to the original layer
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer
			src.mob_offset_x = 20
			src.mob_offset_y = 27

			src.passenger_offset_x = 3
			src.passenger_offset_y = 27

		else if(src.dir == WEST)

			src.mob_offset_x = 34
			src.mob_offset_y = 10
				//||move the driver the one layer above the passenger, so he is displayed properly when they overlap
			if(passenger && load)
				C.layer = default_layer + 0.1
				D.layer = default_layer
			src.passenger_offset_x = 34
			src.passenger_offset_y = 23

			var/image/I = new(icon = 'icons/vehicles/policecar.dmi', icon_state = "policecar_west", layer = MOB_LAYER + 0.3)
			src.overlays += I
			if(passenger && !load)
				var/image/S = new(icon = 'icons/vehicles/policecar.dmi', icon_state = "policecar_west_passenger", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == EAST)

			var/image/I = new(icon = 'icons/vehicles/policecar.dmi', icon_state = "policecar_east_passenger", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 20
			src.passenger_offset_y = 10
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 20
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/policecar.dmi', icon_state = "policecar_east", layer = MOB_LAYER + 0.3)
				src.overlays += S

	if(ismob(C))
		C.pixel_y = src.mob_offset_y
		C.pixel_x = src.mob_offset_x
	if(ismob(D))
		D.pixel_y = src.passenger_offset_y
		D.pixel_x = src.passenger_offset_x

/obj/vehicle/car/sportscar/policecar/closed
	name = "police car"
	desc = "A vehicle designed for the defenders of the law."
	icon = 'icons/vehicles/policecarrier.dmi'
	icon_state = "policecar"
	fits_passenger = 3
	passenger_item_visible = 0
	load_item_visible = 0

/obj/vehicle/car/sportscar/policecar/closed/update_dir_car_overlays()
	var/atom/movable/C = src.load
	var/atom/movable/D = src.passenger
	src.overlays = null
	if(src.dir == NORTH||SOUTH||WEST)
		if(src.dir == NORTH)	//|| place car sprite over mobs

			var/image/I = new(icon = 'icons/vehicles/policecarrier.dmi', icon_state = "policecar_north", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 20
			src.passenger_offset_y = 10
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 20
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/policecarrier.dmi', icon_state = "policecar_north", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == SOUTH)

			var/image/I = new(icon = 'icons/vehicles/policecarrier.dmi', icon_state = "policecar_south", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 20
			src.passenger_offset_y = 10
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 20
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/policecarrier.dmi', icon_state = "policecar_south", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == WEST)

			var/image/I = new(icon = 'icons/vehicles/policecarrier.dmi', icon_state = "policecar_west", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 20
			src.passenger_offset_y = 10
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 20
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/policecarrier.dmi', icon_state = "policecar_west", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == EAST)

			var/image/I = new(icon = 'icons/vehicles/policecarrier.dmi', icon_state = "policecar_east", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 20
			src.passenger_offset_y = 10
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 20
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/policecarrier.dmi', icon_state = "policecar_east", layer = MOB_LAYER + 0.3)
				src.overlays += S

	if(ismob(C))
		C.pixel_y = src.mob_offset_y
		C.pixel_x = src.mob_offset_x
	if(ismob(D))
		D.pixel_y = src.passenger_offset_y
		D.pixel_x = src.passenger_offset_x