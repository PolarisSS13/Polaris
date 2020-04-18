/datum/technomancer_catalog/spell/condensation
	name = "Condensation"
	desc = "This causes rapid formation of liquid at the target, causing floors to become wet, \
	entities to be soaked, and fires to be extinguished. \
	You can also fill contains with water if they are targeted directly."
	enhancement_desc = "Clouds of mist that spread outward will also be created."
	cost = 50
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/condensation)

/datum/spell_metadata/condensation
	name = "Condensation"
	icon_state = "tech_condensation"
	spell_path = /obj/item/weapon/spell/technomancer/condensation
	cooldown = 2 SECONDS


/obj/item/weapon/spell/technomancer/condensation
	name = "Condensation"
	icon_state = "condensation"
	desc = "Stronger than it appears."
	cast_methods = CAST_RANGED
	aspect = ASPECT_AIR
	var/scepter_cloud_amount = 10

// /datum/effect/effect/system/smoke_spread/mist

/obj/item/weapon/spell/technomancer/condensation/on_ranged_cast(atom/hit_atom, mob/user)
	. = FALSE
	if(within_range(hit_atom))
		if(istype(hit_atom, /turf/simulated) && pay_energy(200))
			var/turf/simulated/T = hit_atom
			make_water_splash(T)
			if(check_for_scepter())
				make_mist_clouds(T)


			log_and_message_admins("has wetted the floor with [src] at [T.x],[T.y],[T.z].")
			playsound(T, 'sound/effects/magic/technomancer/ethereal_enter.ogg', 75, 1)
			. = TRUE

		else if(hit_atom.reagents && !ismob(hit_atom) && pay_energy(200))
			hit_atom.reagents.add_reagent(id = "water", amount = 60, data = null, safety = 0)
			. = TRUE
		if(.)
			adjust_instability(5)
			playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)

/obj/item/weapon/spell/technomancer/condensation/proc/make_water_splash(turf/simulated/T)
	for(var/direction in alldirs + null) // null is for the center tile.
		spawn(1)
			var/turf/desired_turf = get_step(T,direction)
			if(desired_turf) // This shouldn't fail but...
				var/obj/effect/effect/water/W = new /obj/effect/effect/water(get_turf(T))
				W.create_reagents(60)
				W.reagents.add_reagent(id = "water", amount = 60, data = null, safety = 0)
				W.set_color()
				W.set_up(desired_turf)
				flick(initial(icon_state),W) // Otherwise pooling causes the animation to stay stuck at the end.

/obj/item/weapon/spell/technomancer/condensation/proc/make_mist_clouds(turf/simulated/T)
	var/datum/effect/effect/system/smoke_spread/mist/smoke_system = new()
	smoke_system.set_up(scepter_cloud_amount, FALSE, T, FALSE)
	smoke_system.attach(T)
	smoke_system.start()
	qdel(smoke_system)
	playsound(T, 'sound/effects/magic/technomancer/smoke.ogg', 75, 1)