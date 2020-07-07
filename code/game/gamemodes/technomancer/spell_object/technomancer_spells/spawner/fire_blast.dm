/datum/technomancer_catalog/spell/fire_blast
	name = "Fire Blast"
	cost = 200
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/spawner/fire_blast)

/datum/spell_metadata/spawner/fire_blast
	name = "Fire Blast"
	desc = "Creates a surge of explosive potential at a targeted tile. After a short delay, it will explosive, \
	harming everything within a small radius around it. Be sure to keep your distance from it."
	enhancement_desc = "After the fire blast explosion, more fire blasts are created on all non-allied entities that the \
	first fire blast could see upon exploding, at no additional cost. The fire blasts created from that cannot \
	create further fire blasts."
	icon_state = "tech_fire_blast"
	aspect = ASPECT_FIRE
	spell_path = /obj/item/weapon/spell/technomancer/spawner/fire_blast
	cooldown = 3 SECONDS

/obj/item/weapon/spell/technomancer/spawner/fire_blast
	name = "fire blast"
	desc = "Leading your booms might be needed."
	icon_state = "fire_blast"
	spawn_sound = 'sound/effects/magic/technomancer/fireball.ogg'
	spawner_type = /obj/effect/temp_visual/fire_blast
	energy_cost = 2000
	instability_cost = 12

/obj/item/weapon/spell/technomancer/spawner/fire_blast/on_spell_given(mob/user)
	if(check_for_scepter())
		spawner_type = /obj/effect/temp_visual/fire_blast/echo_blast


/obj/effect/temp_visual/fire_blast
	name = "fire blast"
	desc = "Run!"
	icon_state = "fire_blast"
	duration = 2.5 SECONDS // After which we go boom.
	plane = ABOVE_PLANE
	light_range = 4
	light_power = 5
	light_color = "#FF6A00"

/obj/effect/temp_visual/fire_blast/Initialize()
	animate(src, transform = transform.Scale(0), time = duration - 0.1)
	return ..()

/obj/effect/temp_visual/fire_blast/Destroy()
	var/turf/T = get_turf(src)
	explosion(T, -1, -1, 2, 5, adminlog = 1)
	new /obj/effect/temp_visual/explosion(T)
	return ..()

// This one makes regular fire blasts at people when it explodes.
/obj/effect/temp_visual/fire_blast/echo_blast/Destroy()
	var/list/things = view(src)
	for(var/thing in things)
		var/mob/living/L = thing
		if(!istype(L)) // Don't try to explode ghosts.
			continue
		if(is_technomancer_ally(L)) // or allies.
			continue
		playsound(get_turf(L), 'sound/effects/magic/technomancer/fireball.ogg', 100, TRUE)
		new /obj/effect/temp_visual/fire_blast(get_turf(L))
	return ..()

/*
/datum/technomancer/spell/fire_blast
	name = "Fire Blast"
	desc = "Causes a disturbance on a targeted tile.  After two and a half seconds, it will explode in a small radius around it.  Be \
	sure to not be close to the disturbance yourself."
	cost = 175
	obj_path = /obj/item/weapon/spell/spawner/fire_blast
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/spawner/fire_blast
	name = "fire blast"
	desc = "Leading your booms might be needed."
	icon_state = "fire_blast"
	cast_methods = CAST_RANGED
	aspect = ASPECT_FIRE
	spawner_type = /obj/effect/temporary_effect/fire_blast
	spawn_sound = 'sound/effects/magic/technomancer/fireball.ogg'

/obj/item/weapon/spell/spawner/fire_blast/on_ranged_cast(atom/hit_atom, mob/user)
	if(within_range(hit_atom) && pay_energy(2000))
		adjust_instability(12)
		..() // Makes the booms happen.

/obj/effect/temporary_effect/fire_blast
	name = "fire blast"
	desc = "Run!"
	icon_state = "fire_blast"
	time_to_die = 2.5 SECONDS // After which we go boom.
	light_range = 4
	light_power = 5
	light_color = "#FF6A00"

/obj/effect/temporary_effect/fire_blast/Destroy()
	explosion(get_turf(src), -1, 1, 2, 5, adminlog = 1)
	..()
*/