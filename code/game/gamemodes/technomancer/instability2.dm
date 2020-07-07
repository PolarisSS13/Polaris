// Holds code for a GLOB accessible instability datum that handles various effects.
// This helps keep instability mechanics off of /mob/living code.

GLOBAL_DATUM_INIT(technomancer_instability, /datum/technomancer_instability, new)

/datum/technomancer_instability

/datum/technomancer_instability/proc/instability_effects(mob/living/L, amount)
	switch(amount)
		if(0 to 10)
			return
		if(10 to 30)
			minor_effects(L, amount)
		if(30 to 50)
			moderate_effects(L, amount)
		if(50 to 100)
			severe_effects(L, amount)
		if(100 to INFINITY)
			lethal_effects(L, amount)

// The various effects at different levels of instability.
/datum/technomancer_instability/proc/minor_effects(mob/living/L, amount)
	var/rng = rand(1, 2)
	switch(rng)
		if(1)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(5, 0, L)
			sparks.attach(L.loc)
			sparks.start()
			L.visible_message(span("warning", "Electrical sparks manifest from nowhere around \the [L]!"))
			qdel(sparks)

		if(2)
			return FALSE // TODO
	return TRUE


/datum/technomancer_instability/proc/moderate_effects(mob/living/L, amount)
	var/rng = rand(1, 3)
	switch(rng)
		if(1) // Forced Blink.
			if(safe_blink(L, range = 6))
				to_chat(L, span("warning", "You're teleported against your will!"))

		if(2) // Corona.
			L.add_modifier(/datum/modifier/technomancer/corona, 1 MINUTE)

		if(3) // Elemental vulnerability.
			L.add_modifier(/datum/modifier/elemental_vulnerability, 2 MINUTES)
	return TRUE

/datum/technomancer_instability/proc/severe_effects(mob/living/L, amount)
	var/rng = rand(1, 4)
	switch(rng)
		if(1) // Pick from the moderate table.
			return moderate_effects(L, amount)

		if(2) // Ball Lightning.
			var/obj/item/projectile/energy/ball_lightning/ball = new(get_turf(L))
			ball.launch_projectile(get_turf(get_step(L, NORTH)), null, null, null, angle_override = rand(0, 360))

		if(3) // Fire blast.
			for(var/i = 1 to CEILING(amount / 40, 1))
				var/list/things = shuffle(view(L))
				var/turf/T = null
				for(var/thing in things)
					if(isturf(thing))
						T = thing
						break
				if(!T)
					return FALSE

				var/obj/effect/temp_visual/fire_blast/blast = new(T)
				playsound(blast, 'sound/effects/magic/technomancer/fireball.ogg', 75, TRUE)

		if(4) // Forced blink for everyone.
			for(var/thing in viewers(L))
				var/mob/living/blinked = thing
				if(safe_blink(blinked, range = 8))
					to_chat(blinked, span("warning", "You're teleported against your will!"))
	return TRUE

/datum/technomancer_instability/proc/lethal_effects(mob/living/L, amount)
	var/rng = rand(1, 2)
	switch(rng)
		if(1) // Pick from severe effects. This can also pick moderate ones if (un?)lucky enough.
			return severe_effects(L, amount)

		if(2) // Lightning strike.
			lightning_strike(get_turf(L))