/obj/vehicle/car/sportscar/jeep
	name = "jeep"
	desc = "A very luxurious vehicle."
	icon = 'icons/vehicles/jeep.dmi'
	icon_state = "jeep"

/obj/vehicle/car/sportscar/jeep/update_dir_car_overlays()
	var/atom/movable/C = src.load
	var/atom/movable/D = src.passenger
	src.overlays = null
	if(src.dir == NORTH||SOUTH||WEST)
		if(src.dir == NORTH)	//|| place car sprite over mobs

			var/image/I = new(icon = 'icons/vehicles/jeep.dmi', icon_state = "jeep_north", layer = MOB_LAYER + 0.3)

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
				var/image/S = new(icon = 'icons/vehicles/jeep.dmi', icon_state = "jeep_north", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == SOUTH)

			var/image/I = new(icon = 'icons/vehicles/jeep.dmi', icon_state = "jeep_south", layer = MOB_LAYER + 0.3)

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
				var/image/S = new(icon = 'icons/vehicles/jeep.dmi', icon_state = "jeep_south", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == WEST)

			var/image/I = new(icon = 'icons/vehicles/jeep.dmi', icon_state = "jeep_west", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 35
			src.passenger_offset_y = 10
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 35
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/jeep.dmi', icon_state = "jeep_west", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == EAST)

			var/image/I = new(icon = 'icons/vehicles/jeep.dmi', icon_state = "jeep_east", layer = MOB_LAYER + 0.3)

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
				var/image/S = new(icon = 'icons/vehicles/jeep.dmi', icon_state = "jeep_east", layer = MOB_LAYER + 0.3)
				src.overlays += S

	if(ismob(C))
		C.pixel_y = src.mob_offset_y
		C.pixel_x = src.mob_offset_x
	if(ismob(D))
		D.pixel_y = src.passenger_offset_y
		D.pixel_x = src.passenger_offset_x