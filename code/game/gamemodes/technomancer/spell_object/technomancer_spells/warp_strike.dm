/datum/technomancer_catalog/spell/warp_strike
	name = "Warp Strike"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/warp_strike)

/datum/spell_metadata/warp_strike
	name = "Warp Strike"
	desc = "Teleports you next to your target, and attacks them with whatever is in your off-hand, \
	automatically invoking a function, or hitting them with an object. \
	Targeting an allied entity will instead teleport you next to them without hitting them."
	enhancement_desc = "You will repeatively warp strike the same target three times, before switching \
	to another target, hitting them three times as well. Repeats until no more targets are available."
	aspect = ASPECT_TELE
	icon_state = "tech_warp_strike"
	spell_path = /obj/item/weapon/spell/technomancer/warp_strike
	cooldown = 5 SECONDS

/datum/spell_metadata/warp_strike/get_spell_info()
	var/obj/item/weapon/spell/technomancer/warp_strike/spell = spell_path
	. = list()
	.["Energy Cost"] = initial(spell.warp_strike_energy_cost)
	.["Instability Cost"] = initial(spell.warp_strike_instability_cost)
	.["Auto Target Radius"] = initial(spell.auto_target_radius)
	.["Scepter Strike Limit"] = "[initial(spell.scepter_per_mob_strike_limit)] times per entity"
	.["Scepter Strike Delay"] = DisplayTimeText(initial(spell.scepter_strike_delay))


/obj/item/weapon/spell/technomancer/warp_strike
	name = "warp strike"
	desc = "The answer to the problem of bringing a knife to a gun fight."
	icon_state = "warp_strike"
	cast_methods = CAST_RANGED
	var/warp_strike_energy_cost = 2000
	var/warp_strike_instability_cost = 12
	var/auto_target_radius = 5
	var/scepter_per_mob_strike_limit = 3
	var/scepter_strike_delay = 0.25 SECONDS

/obj/item/weapon/spell/technomancer/warp_strike/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(!T || !within_range(T))
		return FALSE

	// First, handle who to teleport to.
	var/mob/living/target = targeting_assist(T, auto_target_radius, TRUE)
	if(!target)
		to_chat(user, span("warning", "There's nobody near \the [T] you targeted."))
		return FALSE

	if(check_for_scepter())
		return scepter_strike(target, user)

	return warp_strike(target, user)

/obj/item/weapon/spell/technomancer/warp_strike/proc/scepter_strike(mob/living/first_target, mob/living/user)
	var/mob/living/current_target = first_target
	var/list/targets_struck = list(first_target)
	var/struck_at_least_once = FALSE
	var/i = 1

	while(current_target)
		// Check if needing to swap to a new target.
		if(i > scepter_per_mob_strike_limit)
			var/list/possible_targets = potential_targets(current_target, auto_target_radius) - targets_struck
			if(!possible_targets.len)
				world << "Out of targets."
				return struck_at_least_once

			current_target = pick(possible_targets)
			targets_struck += current_target
			i = 1

		// Hit them and stop if the last strike failed for some reason.
		var/success = warp_strike(current_target, user, struck_at_least_once)
		if(success && !struck_at_least_once)
			struck_at_least_once = TRUE

		if(!success)
			world << "Failed"
			return struck_at_least_once

		sleep(scepter_strike_delay)
		i++

/obj/item/weapon/spell/technomancer/warp_strike/proc/warp_strike(mob/living/target, mob/living/user, free_strike = FALSE)
	// Pay for the teleport.
	if(!free_strike && !pay_energy(warp_strike_energy_cost))
		to_chat(user, span("warning", "You can't afford to warp strike!"))
		return FALSE

	var/datum/teleportation/warp_strike/tele = new(user, get_turf(target))
	if(!tele.teleport())
		to_chat(user, span("warning", "Something interfered with the warp strike!"))
		return FALSE

	// At this point, the user teleported and is hopefully next to the target.
	if(!free_strike)
		adjust_instability(warp_strike_instability_cost)

	// Now it's time to hit the target (if appropiate).
	if(is_technomancer_ally(target)) // Don't hit our friends, tho.
		to_chat(user, span("notice", "\The [src] function refrains from hitting your ally."))
		return TRUE

	var/obj/item/I = user.get_inactive_hand()

	// List of items we don't want used, for balance reasons or to avoid infinite loops.
	var/list/blacklisted_items = list(
		/obj/item/weapon/gun,
		/obj/item/weapon/spell/technomancer/warp_strike,
		/obj/item/weapon/spell/technomancer/targeting_matrix
		)

	user.set_dir(get_dir(user, target))

	if(!I)
		to_chat(user, span("warning", "Your offhand is empty, so you use your hand instead."))
		target.attack_hand(user)
		return TRUE

	if(is_path_in_list(I.type, blacklisted_items))
		to_chat(user, span("warning", "You can't use \the [I] with this function!"))
		return TRUE // The user teleported, so the spell mostly succeeded and so should go on cooldown.

	I.resolve_attackby(target, user, attack_modifier = 1)
	I.afterattack(target, user, TRUE)
	return TRUE

/*
		if(!within_range(T))
			return
		//First, we handle who to teleport to.
		user.setClickCooldown(5)
		var/mob/living/chosen_target = targeting_assist(T,5)		//The person who's about to get attacked.

		if(!chosen_target)
			return 0

		//Now we handle picking a place for the user to teleport to.
		var/list/tele_target_candidates = view(get_turf(chosen_target), 1)
		var/list/valid_tele_targets = list()
		var/turf/tele_target = null
		for(var/turf/checked_turf in tele_target_candidates)
			if(!checked_turf.check_density())
				valid_tele_targets.Add(checked_turf)

		tele_target = pick(valid_tele_targets)

		//Pay for our teleport.
		if(!pay_energy(2000) || !tele_target)
			return 0

		//Teleporting time.
		user.forceMove(tele_target)
		var/new_dir = get_dir(user, chosen_target)
		user.dir = new_dir
		sparks.start()
		adjust_instability(12)

		//Finally, we handle striking the victim with whatever's in the user's offhand.
		var/obj/item/I = user.get_inactive_hand()
		// List of items we don't want used, for balance reasons or to avoid infinite loops.
		var/list/blacklisted_items = list(
			/obj/item/weapon/gun,
			/obj/item/weapon/spell/warp_strike,
			/obj/item/weapon/spell/targeting_matrix
			)
		if(I)

			if(is_path_in_list(I.type, blacklisted_items))
				to_chat(user, "<span class='danger'>You can't use \the [I] while warping!</span>")
				return

			if(istype(I, /obj/item/weapon))
				var/obj/item/weapon/W = I
				W.attack(chosen_target, user)
				W.afterattack(chosen_target, user)
			else
				I.attack(chosen_target, user)
				I.afterattack(chosen_target, user)
		else
			chosen_target.attack_hand(user)
		log_and_message_admins("has warp striked [chosen_target].")


*/