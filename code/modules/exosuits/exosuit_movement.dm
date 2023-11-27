
/mob/living/exosuit/can_ztravel()
	if(Allow_Spacemove()) //Handle here
		return 1

	for(var/turf/simulated/T in trange(1,src))
		if(T.density)
			return 1

/mob/living/exosuit/can_fall()	// Ignore anchored.
	if(is_incorporeal())
		return FALSE
	if(hovering)
		return FALSE
	return !(can_overcome_gravity())

/mob/living/exosuit/relaymove(var/mob/user, var/direction)
	. = FALSE
	if(length(pilots) && (user in pilots) && world.time > next_step)
		. = Move(get_step(src, direction), direction)

/mob/living/exosuit/Move(atom/newloc, direct, movetime)
	. = FALSE

	if(incapacitated())
		return FALSE

	if(!legs)
		to_chat(src, SPAN_WARNING("\The [src] has no means of propulsion!"))
		next_step = world.time + 3 // Just to stop them from getting spammed with messages.
		return FALSE

	if(!legs.motivator || !legs.motivator.is_functional())
		to_chat(src, SPAN_WARNING("Your motivators are damaged! You can't move!"))
		next_step = world.time + 15
		return FALSE

	if(maintenance_protocols)
		to_chat(src, SPAN_WARNING("Maintenance protocols are in effect."))
		next_step = world.time + 3 // Just to stop them from getting spammed with messages.
		return FALSE

	var/obj/item/cell/C = get_cell()
	if(!C || !C.check_charge(legs.power_use * CELLRATE))
		to_chat(src, SPAN_WARNING("The power indicator flashes briefly."))
		next_step = world.time + 3 //On fast exosuits this got annoying fast
		return FALSE

	if(emp_damage >= EMP_MOVE_DISRUPT && prob(30))
		direct = pick(GLOB.alldirs - dir)	// We have diagonal movement, we're gonna use it damnit.

	C.use(legs.power_use * CELLRATE)

	if(!direct)
		direct = get_dir(src, newloc)

	if(dir != direct)
		playsound(loc, mech_turn_sound, 40,1)
		set_dir(direct)
		next_step = world.time + legs.turn_delay
		return FALSE
	. = FALSE
	if(!newloc)
		newloc = get_step(src, direct)
	if(newloc && legs && legs.can_move_on(loc, newloc))
		. = ..(newloc, direct)
		next_step = world.time + legs.move_delay
		if(. && !istype(loc, /turf/space))
			playsound(src.loc, mech_step_sound, 40, 1)
	return .
