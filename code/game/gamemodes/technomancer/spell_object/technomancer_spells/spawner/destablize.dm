/datum/technomancer_catalog/spell/destablize
	name = "Destablize"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/spawner/destablize)


/datum/spell_metadata/spawner/destablize
	name = "Destablize"
	desc = "Creates an unstable disturbance at the targeted tile, which will afflict anyone nearby \
	with instability who remains nearby. This can affect you and your allies as well."
	icon_state = "tech_destablize"
	aspect = ASPECT_UNSTABLE
	spell_path = /obj/item/weapon/spell/technomancer/spawner/destablize
	cooldown = 30 SECONDS


/obj/item/weapon/spell/technomancer/spawner/destablize
	name = "destablize"
	desc = "Now your enemies can feel what you go through when you have too much fun."
	icon_state = "destablize"
	spawn_sound = 'sound/effects/magic/technomancer/death.ogg'
	spawner_type = /obj/effect/temp_visual/pulse/destablize
	energy_cost = 2000
	instability_cost = 15

/obj/effect/temp_visual/pulse/destablize
	name = "destablizing disturbance"
	desc = "This can't be good..."
	icon_state = "rift"
	light_range = 6
	light_power = 10
	light_color = "#C26DDE"
	pulses_remaining = 40 // Twenty seconds total.
	pulse_delay = 0.5 SECONDS
	var/instability_power = 5
	var/instability_range = 6

/obj/effect/temp_visual/pulse/destablize/on_pulse()
	for(var/mob/living/L in range(src, instability_range) )
		var/distance = max(get_dist(L, src), 1)
		// Being farther away lessens the amount of instabity received.
		var/outgoing_instability = instability_power * ( 1 / (distance ** 2) )
		L.receive_radiated_instability(outgoing_instability)