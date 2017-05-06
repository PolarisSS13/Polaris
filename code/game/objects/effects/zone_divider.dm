// This artificially splits a ZAS zone, useful if you wish to prevent massive super-zones which can cause lag.
/obj/effect/zone_divider
	name = "zone divider"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	invisibility = 101 		//nope, can't see this
	anchored = 1
	density = 0
	opacity = 0

/obj/effect/zone_divider/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
 	// Special case to prevent us from being part of a zone during the first air master tick.
 	// We must merge ourselves into a zone on next tick.  This will cause a bit of lag on
 	// startup, but it can't really be helped you know?
	if(air_master && air_master.current_cycle == 0)
		spawn(1)
			air_master.mark_for_update(get_turf(src))
		return 0
	return !air_group // Anything except zones can pass

