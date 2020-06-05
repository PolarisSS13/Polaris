// Generic projectile spell type.

/obj/item/weapon/spell/technomancer/projectile
	name = "projectile template"
	desc = "This is a generic template that shoots projectiles.  If you can read this, the game broke!"
	cast_methods = CAST_RANGED
	var/obj/item/projectile/spell_projectile = null
	var/energy_cost_per_shot = 0
	var/instability_per_shot = 0
	var/pre_shot_delay = 0
	var/fire_sound = null
	var/can_hit_shooter = FALSE // Most of the time you don't want this TRUE, except for certain risky spells like Ball Lightning.

/obj/item/weapon/spell/technomancer/projectile/on_ranged_cast(atom/hit_atom, mob/living/user, list/params)
	if(set_up(hit_atom, user))
		var/obj/item/projectile/new_projectile = make_projectile(spell_projectile, hit_atom, user)
		new_projectile.launch_projectile(hit_atom, user.zone_sel?.selecting, user, params, angle_override = null, forced_spread = 0)
		log_and_message_admins("has casted \the [src] at \the [hit_atom].")
		if(fire_sound)
			playsound(src, fire_sound, 75, 1)
		adjust_instability(instability_per_shot)
		return TRUE
	return FALSE

/obj/item/weapon/spell/technomancer/projectile/proc/make_projectile(obj/item/projectile/projectile_type, atom/target, mob/living/user)
	var/obj/item/projectile/P = new projectile_type(get_turf(user))
	if(!can_hit_shooter)
		P.firer = user
	tweak_projectile(P, target, user)
	return P

// Override to set vars on the projectile or something.
/obj/item/weapon/spell/technomancer/projectile/proc/tweak_projectile(obj/item/projectile/P, atom/target, mob/living/user)

/obj/item/weapon/spell/technomancer/projectile/proc/set_up(atom/hit_atom, mob/living/user)
	if(!spell_projectile)
		to_chat(user, span("warning", "The function you're trying to invoke appears to not have a projectile. \
		This is a bug and you should report it."))
		return FALSE

	if(pre_shot_delay)
	//	var/image/target_image = image(icon = 'icons/obj/spells.dmi', loc = get_turf(hit_atom), icon_state = "target")
	//	user << target_image
		user.do_windup_animation(hit_atom, pre_shot_delay)
		if(!do_after(user, pre_shot_delay, get_turf(user)))
			to_chat(user, span("warning", "You need to stand still to fire!"))
	//		qdel(target_image)
			return FALSE
	//	qdel(target_image)

	if(!pay_energy(energy_cost_per_shot))
		to_chat(user, span("warning", "You don't have enough energy to fire!"))
		return FALSE

	if(!owner || QDELETED(src)) // Make sure we didn't get dropped or something.
		return FALSE

	return TRUE