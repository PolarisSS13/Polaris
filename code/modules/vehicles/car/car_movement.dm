/obj/vehicle/car/Move(var/turf/destination, mob/user as mob)

	if(!on)
		to_chat(user, "<span class='warning'>The car seems to be turned off.</span>")
		return 0
	else
		if(world.time > l_move_time + move_delay)
			var/old_loc = get_turf(src)
			if(mechanical && on && powered && cell.charge < charge_use)
				turn_off()

			var/init_anc = anchored
			anchored = 0
			if(!..())
				anchored = init_anc
				return 0

			set_dir(get_dir(old_loc, loc))
			anchored = init_anc

			if(mechanical && on && powered)
				cell.use(charge_use)

			//Dummy loads do not have to be moved as they are just an overlay
			//See load_object() proc in cargo_trains.dm for an example
			if(load && !istype(load, /datum/vehicle_dummy_load))
				load.forceMove(loc)
				load.set_dir(dir)
			return 1
		else
			return 0
