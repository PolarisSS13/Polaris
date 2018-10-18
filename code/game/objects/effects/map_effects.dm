// These are objects you can use inside special maps (like PoIs), or for adminbuse.
// Players cannot see or interact with these.
/obj/effect/map_effect
	anchored = TRUE
	invisibility = 99 // So a badmin can go view these by changing their see_invisible.
	icon = 'icons/effects/effects.dmi'


// Emits light forever with magic. Useful for mood lighting in Points of Interest.
// Be sure to check how it looks ingame, and fiddle with the settings until it looks right.
/obj/effect/map_effect/perma_light
	name = "permanent light"
	icon_state = "permalight"

	light_range = 3
	light_power = 1
	light_color = "#FFFFFF"

// Constantly emites radiation from the tile it's placed on.
/obj/effect/map_effect/radiation_emitter
	name = "radiation emitter"
	icon_state = "radiation_emitter"
	var/radiation_power = 30 // Bigger numbers means more radiation.

/obj/effect/map_effect/radiation_emitter/initialize()
	processing_objects += src
	return ..()

/obj/effect/map_effect/radiation_emitter/Destroy()
	processing_objects -= src
	return ..()

/obj/effect/map_effect/radiation_emitter/process()
	radiation_repository.radiate(src, radiation_power)

/obj/effect/map_effect/radiation_emitter/strong
	radiation_power = 100

// Creates smoke clouds every so often.
/obj/effect/map_effect/effect_emitter
	var/datum/effect/effect/system/effect_system = null
	var/effect_system_type = null // Which smoke system to attach.

	var/effect_interval = 5 SECONDS		// How often to spawn smoke.
	var/effect_interval_variance = 0	// If set, the interval will randomly be shorter or longer by this amount.
	// 1 SECOND on default settings will make the effect appear every 4 to 6 seconds, for example.

	var/effect_amount = 10				// How many effect objects to create on each interval.  Note that there's a hard cap on certain effect emitters.
	var/effect_cardinals_only = FALSE	// If true, effects only move in cardinal directions.
	var/effect_forced_dir = null		// If set, effects emitted will always move in this direction.

	var/always_run = FALSE				// If true, the game will not try to suppress this from firing if nobody is around to see it.
	var/proximity_needed = 12			// How many tiles a mob with a client must be for this to run.
	var/ignore_ghosts = FALSE			// If true, ghosts won't satisfy the above requirement.
	var/retry_delay = 3 SECONDS			// How long until we check for players again.


/obj/effect/map_effect/effect_emitter/initialize()
	effect_system = new effect_system_type()
	effect_system.attach(src)
	configure_effects()
	emit_effects()
	return ..()

/obj/effect/map_effect/effect_emitter/Destroy()
	QDEL_NULL(effect_system)
	return ..()

/obj/effect/map_effect/effect_emitter/proc/configure_effects()
	effect_system.set_up(effect_amount, effect_cardinals_only, usr.loc, effect_forced_dir)

/obj/effect/map_effect/effect_emitter/proc/emit_effects()
	if(QDELETED(src))
		return

	if(!always_run && !check_for_players())
		spawn(retry_delay) // Maybe someday we'll have fancy TG timers/schedulers.
			if(!QDELETED(src))
				.()

	configure_effects() // We do this every interval in case it changes.
	effect_system.start()
	var/next_effect = effect_interval
	if(effect_interval_variance)
		var/lower_bound = max(1, effect_interval - effect_interval_variance) // Don't go below 1.
		var/upper_bound = effect_interval + effect_interval_variance
		next_effect = rand(lower_bound, upper_bound)

	spawn(next_effect)
		if(!QDELETED(src))
			.()

// It is wasteful to have these continiously spewing out objects if nobody is around to appreciate it.
/obj/effect/map_effect/effect_emitter/proc/check_for_players()
	var/has_proximity = FALSE
	for(var/mob/M in player_list)
		if(ignore_ghosts && isobserver(M))
			continue
		if(get_dist(M, src) <= proximity_needed)
			has_proximity = TRUE
			break
	return has_proximity

// Creates smoke clouds every so often.
/obj/effect/map_effect/effect_emitter/smoke
	name = "smoke emitter"
	icon_state = "smoke_emitter"
	effect_system_type = /datum/effect/effect/system/smoke_spread

/obj/effect/map_effect/effect_emitter/smoke/bad
	name = "bad smoke emitter"
	effect_system_type = /datum/effect/effect/system/smoke_spread/bad


// Makes sparks.
/obj/effect/map_effect/effect_emitter/sparks
	name = "spark emitter"
	icon_state = "spark_emitter"
	effect_system_type = /datum/effect/effect/system/spark_spread

	effect_interval_variance = 2 SECONDS // Will run every 3 to 7 seconds.

/obj/effect/map_effect/effect_emitter/sparks/frequent
	effect_amount = 4			// Otherwise it caps out fast.
	effect_interval = 1 SECOND	// Will run every .1 to 3 seconds.



