// Does a melee attack.
/mob/living/simple_mob/proc/attack_target(atom/A)
	set waitfor = FALSE // For attack animations, if they're ever added. Don't want the AI processor to get held up.

	if(!A.Adjacent(src))
		return FALSE
	if(!canClick()) // Still on cooldown from a "click".
		return FALSE
	setClickCooldown(get_attack_speed())

	return do_attack(A)


// This does the actual attack.
// This is a seperate proc for the purposes of attack animations.
/mob/living/simple_mob/proc/do_attack(atom/A)
	if(!A.Adjacent(src)) // They could've moved in the meantime.
		return FALSE

	var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			damage_to_do *= M.outgoing_melee_damage_percent

	if(isliving(A)) // Check defenses.
		var/mob/living/L = A

		if(prob(melee_miss_chance))
			add_attack_logs(src, L, "Animal-attacked (miss)", admin_notify = FALSE)
			do_attack_animation(src)
			return FALSE // We missed.

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.check_shields(damage = damage_to_do, damage_source = src, attacker = src, def_zone = null, attack_text = "the attack"))
				return FALSE // We were blocked.

	if(A.attack_generic(src, damage_to_do, pick(attacktext)) && attack_sound)
		apply_melee_effects(A)
		playsound(src, attack_sound, 75, 1)

	return TRUE

// Override for special effects after a successful attack.
/mob/living/simple_mob/proc/apply_melee_effects(atom/A)

//The actual top-level ranged attack proc
/mob/living/simple_mob/proc/shoot_target(atom/A)
	if(!canClick())
		return FALSE

	setClickCooldown(get_attack_speed())

	visible_message("<span class='danger'><b>\The [src]</b> fires at \the [A]!</span>")
	shoot(A, src.loc, src)
	if(casingtype)
		new casingtype

	return TRUE


//Shoot a bullet at someone (idk why user is an argument when src would fit???)
/mob/living/simple_mob/proc/shoot(atom/A, turf/start, mob/living/user, bullet = 0)
	if(A == start)
		return

	var/obj/item/projectile/P = new projectiletype(user.loc)
	playsound(user, projectilesound, 100, 1)
	if(!P)
		return
	P.launch(A)


//Special attacks, like grenades or blinding spit or whatever
/mob/living/simple_mob/proc/special_attack_target(atom/A)
	return FALSE