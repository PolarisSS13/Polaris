/datum/spell_metadata/spawner/get_spell_info()
	var/obj/item/weapon/spell/technomancer/spawner/spell = spell_path
	. = list()
	.["Energy Cost"] = initial(spell.energy_cost)
	.["Instability Cost"] = initial(spell.instability_cost)

/obj/item/weapon/spell/technomancer/spawner
	name = "spawner template"
	desc = "If you see me, someone messed up."
	cast_methods = CAST_RANGED
	var/obj/effect/spawner_type = null
	var/spawn_sound = 'sound/effects/magic/technomancer/magic.ogg'
	var/cast_sound = 'sound/effects/magic/technomancer/generic_cast.ogg'
	var/energy_cost = 0
	var/instability_cost = 0

/obj/item/weapon/spell/technomancer/spawner/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(!istype(T))
		return FALSE

	if(!within_range(hit_atom))
		to_chat(user, span("warning", "You're too far away to do that!"))
		return FALSE

	if(!pay_energy(energy_cost))
		to_chat(user, span("warning", "You don't have enough energy to invoke this!"))
		return FALSE

	var/obj/effect/E = new spawner_type(T)
	playsound(get_turf(src), cast_sound, 75, TRUE)
	if(spawn_sound)
		playsound(T, spawn_sound, 100, TRUE)
	to_chat(user, span("notice", "You create \a [E] onto \the [T]."))
	log_and_message_admins("has casted [src] at [T.x],[T.y],[T.z].")
	adjust_instability(instability_cost)
	delete_after_cast = TRUE
	return TRUE