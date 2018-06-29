/obj/vehicle/car/sportscar/mayorcar
	name = "mayor's speedwagon"
	desc = "A very luxurious vehicle."
	icon = 'icons/vehicles/mayorcar.dmi'
	icon_state = "mayorcar"

/obj/vehicle/car/sportscar/mayorcar/update_dir_car_overlays()
	var/atom/movable/C = src.load
	var/atom/movable/D = src.passenger
	src.overlays = null
	if(src.dir == NORTH||SOUTH||WEST)
		if(src.dir == NORTH)	//|| place car sprite over mobs

			var/image/I = new(icon = 'icons/vehicles/mayorcar.dmi', icon_state = "mayorcar_north", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 66
			src.passenger_offset_y = 43
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 35
			src.mob_offset_y = 43

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/mayorcar.dmi', icon_state = "mayorcar_north", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == SOUTH)

			var/image/I = new(icon = 'icons/vehicles/mayorcar.dmi', icon_state = "mayorcar_south", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 35
			src.passenger_offset_y = 60
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 66
			src.mob_offset_y = 60

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/mayorcar.dmi', icon_state = "mayorcar_south", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == WEST)

			var/image/I = new(icon = 'icons/vehicles/mayorcar.dmi', icon_state = "mayorcar_west", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 56
			src.passenger_offset_y = 45
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 60
			src.mob_offset_y = 75

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/mayorcar.dmi', icon_state = "mayorcar_west", layer = MOB_LAYER + 0.3)
				src.overlays += S

		else if(src.dir == EAST)

			var/image/I = new(icon = 'icons/vehicles/mayorcar.dmi', icon_state = "mayorcar_east", layer = MOB_LAYER + 0.3)

			src.passenger_offset_x = 40
			src.passenger_offset_y = 45
				//||move the driver back to the original layer & passenger up one layer to prevent overlap
			if(passenger && load)
				C.layer = default_layer
				D.layer = default_layer + 0.1
			src.mob_offset_x = 40
			src.mob_offset_y = 74

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/mayorcar.dmi', icon_state = "mayorcar_east", layer = MOB_LAYER + 0.3)
				src.overlays += S

	if(ismob(C))
		C.pixel_y = src.mob_offset_y
		C.pixel_x = src.mob_offset_x
	if(ismob(D))
		D.pixel_y = src.passenger_offset_y
		D.pixel_x = src.passenger_offset_x