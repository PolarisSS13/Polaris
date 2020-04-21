/datum/technomancer_catalog/spell/flame_tongue
	name = "Flame Tongue"
	desc = "Using a miniturized flamethrower in your gloves, \
	you can emit a flame strong enough immolate anyone close by. \
	When used on an entity up close, it will ignite them for a period of time. \
	If this is repeated while they are on fire, they will explode in \
	a burst of fire, igniting nearby entities. You and your allies are protected \
	from the blast."
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/flame_tongue)

/datum/spell_metadata/flame_tongue
	name = "Flame Tongue"
	icon_state = "tech_flame_tongue"
	spell_path = /obj/item/weapon/spell/technomancer/flame_tongue
	cooldown = 1 SECOND

/obj/item/weapon/spell/technomancer/flame_tongue
	name = "flame tongue"
	icon_state = "flame_tongue"
	desc = "Burn!"
	cast_methods = CAST_MELEE
	aspect = ASPECT_FIRE
	var/ignite_energy_cost = 1000
	var/ignite_instability_cost = 10
	var/burst_radius = 3

/obj/item/weapon/spell/technomancer/flame_tongue/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(isliving(hit_atom) && !is_technomancer_ally(hit_atom))
		var/mob/living/L = hit_atom
		if(pay_energy(ignite_energy_cost))
			if(L.has_modifier_of_type(/datum/modifier/fire) || L.on_fire)
				visible_message(span("danger", "\The [L] explodes in a burst of fire, spreading the flames everywhere!"))
				flame_burst(L)
			else
				visible_message(span("danger", "\The [user] reaches out towards \the [L] with a flaming hand, and they ignite!"))
				ignite_target(L)
			playsound(user, 'sound/effects/magic/technomancer/fireball.ogg', 75, 1)
			adjust_instability(ignite_instability_cost)
			return TRUE
	return FALSE

/obj/item/weapon/spell/technomancer/flame_tongue/proc/ignite_target(mob/living/L)
	L.add_modifier(/datum/modifier/fire, 10 SECONDS) // Approximately 25 burn per stack.
	playsound(L, 'sound/effects/magic/technomancer/charge.ogg', 75, 1)
	log_and_message_admins("has ignited \the [L] with \the [src].")


/obj/item/weapon/spell/technomancer/flame_tongue/proc/flame_burst(mob/living/L)
	// Make a fake explosion, since a real explosion would be rather suicidal.
	new /obj/effect/explosion(get_turf(L))
	playsound(L, "explosion", 75, 1, 10)

	for(var/mob/living/victim in view(burst_radius, L))
		if(is_technomancer_ally(victim))
			continue // It's science, I don't have to explain.
		ignite_target(victim)

/*

/obj/item/weapon/spell/flame_tongue/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(isliving(hit_atom) && user.a_intent != I_HELP)
		var/mob/living/L = hit_atom
		if(pay_energy(1000))
			visible_message("<span class='danger'>\The [user] reaches out towards \the [L] with the flaming hand, and they ignite!</span>")
			to_chat(L, "<span class='danger'>You ignite!</span>")
			L.fire_act()
			log_and_message_admins("has ignited [L] with [src].")
			adjust_instability(12)
	else
		//This is needed in order for the welder to work, and works similarly to grippers.
		welder.loc = user
		var/resolved = hit_atom.attackby(welder, user)
		if(!resolved && welder && hit_atom)
			if(pay_energy(500))
				welder.attack(hit_atom, user, def_zone)
				adjust_instability(4)
		if(welder && user && (welder.loc == user))
			welder.loc = src
		else
			welder = null
			qdel(src)
			return

*/