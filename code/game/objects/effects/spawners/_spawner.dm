/// Spawners that place objects with special logic and then delete themselves.
/// These are effects instead of datums so that they can be used for mapping (i.e. random loot placement and so on)
/obj/effect/spawner
	name = "object spawner"

/obj/effect/spawner/Initialize(mapload, ...)
	..()
	do_spawn(arglist(args))
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/proc/do_spawn(mapload, ...)
	return
