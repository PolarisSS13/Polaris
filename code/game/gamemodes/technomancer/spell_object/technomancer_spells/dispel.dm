/datum/technomancer_catalog/spell/dispel
	name = "Dispel"
	desc = "Unravels the energy behind various on-going effects associated with Technomancer Functions, \
	causing them to end early. Useful if you're worried about hitting an ally with a deterimental effect, \
	if your opponent has similar capabilities to you, or if you want to protect yourself from what sometimes \
	happens when having high amounts of instability. \
	Removes on-going effects from both entities and in the world, in a 3x3 area."
	cost = 25
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/dispel)

/datum/spell_metadata/dispel
	name = "Dispel"
	icon_state = "tech_dispel"
	spell_path = /obj/item/weapon/spell/technomancer/dispel
	cooldown = 1 SECOND


/obj/item/weapon/spell/technomancer/dispel
	name = "dispel"
	desc = "Useful if you're tired of glowing because of a miscast."
	icon_state = "dispel"
	cast_methods = CAST_RANGED
	aspect = ASPECT_BIOMED

/obj/item/weapon/spell/technomancer/dispel/on_ranged_cast(atom/hit_atom, mob/living/user)
	var/turf/T = get_turf(hit_atom)
	if(!istype(T))
		return FALSE

	if(!within_range(T) || !pay_energy(500))
		return FALSE

	var/list/things = range(1, T) // 3x3 area of effect.
	for(var/thing in things)
		if(isliving(thing))
			var/mob/living/L = thing
			for(var/datum/modifier/M in L.modifiers)
				if(M.technomancer_dispellable)
					L.remove_specific_modifier(M)

		// If dispel deleting things like microsingulos and angonizing spheres ends up being too strong,
		// feel free to repath the technomancer ones and target those.
		else if(istype(thing, /obj/effect/temp_visual/pulse))
			qdel(thing)

	user.adjust_instability(5)
	playsound(owner, 'sound/effects/magic/technomancer/healing_cast.ogg', 75, 1)
	playsound(T, 'sound/effects/magic/technomancer/magic.ogg', 75, 1)