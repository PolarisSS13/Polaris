/mob/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(air_group || (height == 0))
		return TRUE

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	return (!mover.density || !density || lying)

/*
/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if((mover.pass_flags & PASSMOB))
		return TRUE
	if(istype(mover, /obj/item/projectile) || mover.throwing)
		return (!density || !(mobility_flags & MOBILITY_STAND))
	if(buckled == mover)
		return TRUE
	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
		if (mover in buckled_mobs)
			return TRUE
	return (!mover.density || !density || !(mobility_flags & MOBILITY_STAND))
*/
