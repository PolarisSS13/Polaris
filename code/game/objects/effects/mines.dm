/obj/effect/mine
	name = "Mine"
	desc = "I Better stay away from that thing."
	density = 1
	anchored = 1
	layer = 3
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	var/triggered = 0

/obj/effect/mine/New()
	icon_state = "uglyminearmed"

/obj/effect/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/effect/mine/Bumped(mob/M as mob|obj)

	if(triggered) return

	if(isliving(M))
		for(var/mob/O in viewers(world.view, src.loc))
			O << "<font color='red'>[M] triggered the \icon[src] [src]</font>"
		triggered = 1
		Detonate(M)

/obj/effect/mine/proc/Detonate(var/mob/living/M)
	explosion(loc, 0, 1, 2, 3)
	spawn(0)
		qdel(src)


/obj/effect/mine/dnascramble
	name = "Radiation Mine"

/obj/effect/mine/dnascramble/Detonate(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	M.radiation += 50
	randmutb(M)
	domutcheck(M,null)
	spawn(0)
		qdel(src)


/obj/effect/mine/stun
	name = "Stun Mine"

/obj/effect/mine/stun/Detonate(var/mob/living/M)
	M.Stun(30)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	spawn(0)
		qdel(src)


/obj/effect/mine/n2o
	name = "N2O Mine"

/obj/effect/mine/n20/Detonate(var/mob/living/M)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)

	spawn(0)
		qdel(src)


/obj/effect/mine/phoron
	name = "Phoron Mine"

/obj/effect/mine/phoron/Detonate(var/mob/living/M)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("phoron", 30)

			target.hotspot_expose(1000, CELL_VOLUME)

	spawn(0)
		qdel(src)


/obj/effect/mine/kick
	name = "Kick Mine"

/obj/effect/mine/kick/Detonate(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	qdel(M.client)
	spawn(0)
		qdel(src)

/obj/effect/mine/emp
	name = "EMP Mine"

/obj/effect/mine/emp/Detonate(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	empulse(loc, 2, 4, 7, 10, 1) // As strong as an EMP grenade
	spawn(0)
		qdel(src)