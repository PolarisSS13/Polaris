/datum/spell_metadata/modifier
	aspect = ASPECT_BIOMED

/datum/spell_metadata/modifier/get_spell_info()
	var/obj/item/weapon/spell/technomancer/modifier/spell = spell_path
	. = list()
	var/modifier_duration = initial(spell.modifier_duration)
	.["Effect Duration"] = modifier_duration ? DisplayTimeText(modifier_duration) : "Forever"
	.["Energy Cost"] = initial(spell.modifier_energy_cost)
	.["Instability Cost"] = initial(spell.modifier_instability_cost)

/obj/item/weapon/spell/technomancer/modifier
	name = "modifier template"
	desc = "Tell a coder if you can read this in-game."
	icon_state = "purify"
	cast_methods = CAST_MELEE
	var/modifier_type = null
	var/modifier_duration = null // Will last forever by default.
	var/modifier_energy_cost = 0
	var/modifier_instability_cost = 0
	var/split_instability_cost = FALSE // If true, half of the instability goes to the target.
	var/cast_sound_target = 'sound/effects/magic/technomancer/magic.ogg'
	var/cast_sound_user = 'sound/effects/magic/technomancer/generic_cast.ogg'


/obj/item/weapon/spell/technomancer/modifier/on_melee_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /mob/living) && within_range(hit_atom) && pay_energy(modifier_energy_cost))
		return give_modifier(hit_atom)
	return FALSE

/obj/item/weapon/spell/technomancer/modifier/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /mob/living) && within_range(hit_atom) && pay_energy(modifier_energy_cost))
		return give_modifier(hit_atom)
	return FALSE

/obj/item/weapon/spell/technomancer/modifier/proc/give_modifier(mob/living/L)
	if(cast_sound_user)
		playsound(owner, cast_sound_user, 75, TRUE)

	if(cast_sound_target)
		playsound(L, cast_sound_target, 75, TRUE)

	L.add_modifier(modifier_type, modifier_duration, owner)
	if(split_instability_cost)
		adjust_instability(modifier_instability_cost / 2)
		L.adjust_instability(modifier_instability_cost / 2)
	else
		adjust_instability(modifier_instability_cost)
	log_and_message_admins("has casted [src] on \the [L].")
	return TRUE


// Technomancer specific subtype which keeps track of spell power and gets targeted specificially by Dispel.
/datum/modifier/technomancer
	var/spell_power = null // Set by on_add_modifier.
	technomancer_dispellable = TRUE
