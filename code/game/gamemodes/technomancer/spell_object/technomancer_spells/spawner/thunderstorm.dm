/datum/technomancer_catalog/spell/thunderstorm
	name = "Thunderstorm"
	cost = 200
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/spawner/thunderstorm)

/datum/spell_metadata/spawner/thunderstorm
	name = "Thunderstorm"
	desc = "Makes a very energetic ball come into existance at the targeted tile, which will cause \
	localized lightning strikes to hit the closest enemy within vision, every few seconds."
	enhancement_desc = "The energy ball will strike all valid targets instead of just the closest one."
	icon_state = "tech_thunderstorm"
	aspect = ASPECT_SHOCK
	spell_path = /obj/item/weapon/spell/technomancer/spawner/thunderstorm
	cooldown = 30 SECONDS

/obj/item/weapon/spell/technomancer/spawner/thunderstorm
	name = "thunderstorm"
	desc = "Rain sold seperately." // Condensation spell, to be exact.
	icon_state = "thunderstorm"
	spawn_sound = 'sound/effects/magic/technomancer/death.ogg'
	spawner_type = /obj/effect/temp_visual/pulse/thunderstorm
	energy_cost = 3000
	instability_cost = 20

/obj/item/weapon/spell/technomancer/spawner/thunderstorm/on_spell_given(mob/user)
	if(check_for_scepter())
		spawner_type = /obj/effect/temp_visual/pulse/thunderstorm/intense


/obj/effect/temp_visual/pulse/thunderstorm
	name = "energy ball"
	desc = "You should probably keep your distance from that."
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball_fast"
	pulses_remaining = 10
	pulse_delay = 2 SECONDS
	pixel_x = -32
	pixel_y = -32
	var/strike_all = FALSE
	var/strike_damage = 20

/obj/effect/temp_visual/pulse/thunderstorm/intense
	strike_all = TRUE

/obj/effect/temp_visual/pulse/thunderstorm/on_pulse()
	var/mob/living/L = null
	var/closest_distance = INFINITY

	for(var/thing in viewers(src))
		if(!isliving(thing)) // Don't zap ghosts please.
			continue
		var/mob/living/living_thing = thing

		if(living_thing.stat == DEAD) // Don't waste zaps on corpses.
			continue

		if(is_technomancer_ally(living_thing)) // Also don't hurt on pals.
			continue

		if(strike_all)
			strike(living_thing)
			continue

		var/dist = get_dist(living_thing, src)

		if(!L || dist < closest_distance)
			L = thing
			closest_distance = dist

	if(L)
		strike(L)

/obj/effect/temp_visual/pulse/thunderstorm/proc/strike(mob/living/L)
	var/turf/T = lightning_strike(get_turf(L), cosmetic = TRUE) // Real lightning would be waaaaay too strong.
	if(get_turf(L) != T) // Got redirected by something.
		return FALSE

	L.inflict_shock_damage(strike_damage)
	visible_message(span("danger", "\The [src] strikes \the [L] with lightning!"))
	return TRUE