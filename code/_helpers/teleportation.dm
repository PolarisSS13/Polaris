// Holds various procs for teleporting and checking if teleporting should be allowed.
/proc/safe_blink(atom/movable/AM, var/range = 3)
	if(AM.anchored || !AM.can_teleport())
		return
//	var/turf/starting = get_turf(AM)
	var/list/targets = list()

	valid_turfs:
		for(var/turf/simulated/T in range(AM, range))
			if(T.density)
				continue
			if(T.block_tele)
				continue
			if(isliving(AM))
				if(!T.is_safe_to_enter(AM)) // So they don't teleport into lava or an open tile.
					continue

			for(var/atom/movable/stuff in T.contents)
				if(stuff.density)
					continue valid_turfs
			targets.Add(T)

	if(!targets.len)
		return
	var/turf/simulated/destination = null

	destination = pick(targets)

	if(destination)
		var/datum/teleportation/blink/tele = new(AM, destination)
		tele.teleport()
		/*
		if(ismob(AM))
			var/mob/living/L = AM
			if(L.buckled)
				L.buckled.unbuckle_mob()
		teleport_effects(AM, outgoing = TRUE, teleport_sound = 'sound/effects/magic/technomancer/blink.ogg', teleport_effect = /obj/effect/temp_visual/phase_out)

//		AM.visible_message("<span class='notice'>\The [AM] vanishes!</span>")
//		playsound(AM, 'sound/effects/magic/technomancer/blink.ogg', 75, 1)
//		new /obj/effect/temp_visual/phase_out(starting)

		AM.forceMove(destination)

		teleport_effects(AM, outgoing = FALSE, teleport_sound = 'sound/effects/magic/technomancer/blink.ogg', teleport_effect = /obj/effect/temp_visual/phase_in)
//		destination.visible_message(span("notice", "\The [AM] suddenly appears!"))
//		playsound(destination, 'sound/effects/magic/technomancer/blink.ogg', 75, 1)
//		new /obj/effect/temp_visual/phase_in(destination)

		to_chat(AM, "<span class='notice'>You suddenly appear somewhere else!</span>")
		*/
	return

