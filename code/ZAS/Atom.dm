

/atom/var/pressure_resistance = ONE_ATMOSPHERE
/atom/var/can_atmos_pass = ATMOS_PASS_YES

// Used to determine if airflow/zones can pass this atom.
/atom/proc/CanZASPass(turf/T, is_zone)
	switch(can_atmos_pass)
		if(ATMOS_PASS_PROC)
			return ATMOS_PASS_YES
		if(ATMOS_PASS_DENSITY)
			return !density
		else
			return can_atmos_pass
//	return (!density || is_zone)

/*
/atom/proc/CanAtmosPass(turf/T)
	switch (CanAtmosPass)
		if (ATMOS_PASS_PROC)
			return ATMOS_PASS_YES
		if (ATMOS_PASS_DENSITY)
			return !density
		else
			return CanAtmosPass

/atom/proc/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	//Purpose: Determines if the object (or airflow) can pass this atom.
	//Called by: Movement, airflow.
	//Inputs: The moving atom (optional), target turf, "height" and air group
	//Outputs: Boolean if can pass.

	return (!density || !height || air_group)
*/
// Used to see if objects can freely move past this atom.
// Airflow and ZAS zones now uses CanZASPass() instead.
/atom/proc/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	return !density

/turf/can_atmos_pass = ATMOS_PASS_NO

/turf/CanPass(atom/movable/mover, turf/target, height=1.5,air_group=0)
	if(!target) return FALSE

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	/*
	else // Now, doing more detailed checks for air movement and air group formation
		if(target.blocks_air||blocks_air)
			return 0

		for(var/obj/obstacle in src)
			if(!obstacle.CanPass(mover, target, height, air_group))
				return 0
		if(target != src)
			for(var/obj/obstacle in target)
				if(!obstacle.CanPass(mover, src, height, air_group))
					return 0

		return 1
	*/

/turf/CanZASPass(turf/T, is_zone)
	if(T.blocks_air || src.blocks_air)
		return FALSE
	for(var/obj/obstacle in src)
		if(!obstacle.CanZASPass(T, is_zone))
			return FALSE
	if(T != src)
		for(var/obj/obstacle in T)
			if(!obstacle.CanZASPass(src, is_zone))
				return FALSE
	return TRUE

//Convenience function for atoms to update turfs they occupy
/atom/movable/proc/update_nearby_tiles(need_rebuild)
	if(!air_master)
		return 0

	for(var/turf/simulated/turf in locs)
		air_master.mark_for_update(turf)

	return 1

//Basically another way of calling CanPass(null, other, 0, 0) and CanPass(null, other, 1.5, 1).
//Returns:
// 0 - Not blocked
// AIR_BLOCKED - Blocked
// ZONE_BLOCKED - Not blocked, but zone boundaries will not cross.
// BLOCKED - Blocked, zone boundaries will not cross even if opened.
/*
atom/proc/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	return (AIR_BLOCKED*!CanPass(null, other, 0, 0))|(ZONE_BLOCKED*!CanPass(null, other, 1.5, 1))
*/
atom/proc/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	return (AIR_BLOCKED*!CanZASPass(other, FALSE))|(ZONE_BLOCKED*!CanZASPass(other, TRUE))

turf/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	if(((blocks_air & AIR_BLOCKED) || (other.blocks_air & AIR_BLOCKED)))
		return BLOCKED

	//Z-level handling code. Always block if there isn't an open space.
	#ifdef MULTIZAS
	if(other.z != src.z)
		if(other.z < src.z)
			if(!istype(src, /turf/simulated/open)) return BLOCKED
		else
			if(!istype(other, /turf/simulated/open)) return BLOCKED
	#endif

	if(((blocks_air & ZONE_BLOCKED) || (other.blocks_air & ZONE_BLOCKED)))
		if(z == other.z)
			return ZONE_BLOCKED
		else
			return AIR_BLOCKED

	var/result = 0
	for(var/mm in contents)
		var/atom/movable/M = mm
		result |= M.c_airblock(other)
		if(result == BLOCKED) return BLOCKED
	return result
