/datum/ai_holder
	var/hostile = FALSE					// Do we try to hurt others? Setting to false disables most combat processing.
	var/retaliate = FALSE				// Requires hostile to be true to work. If both this and hostile are true, the mob won't attack unless attacked first.
	var/cooperative = FALSE				// If true, asks allies to help when fighting something.
	var/firing_lanes = FALSE			// If ture, tries to refrain from shooting allies or the wall.
	var/conserve_ammo = FALSE			// If true, the mob will avoid shooting anything that does not have a chance to hit a mob. Requires firing_lanes to be true.

	var/atom/movable/target		// The thing (mob or object) we're trying to kill.
	var/attack_cooldown = 2				// If set, the mob will wait for the specified amount of ticks before attempting another attack.
	var/attack_cooldown_left = 0		// Actual var for tracking if attacks are off cooldown or not. Note that melee and ranged attacks share this.

	var/ranged = FALSE					// If true, attempts to shoot at the enemy instead of charging at them wildly.
	var/shoot_range = 5					// How close the mob needs to be to attempt to shoot at the enemy.
	var/pointblank = FALSE				// If ranged is true, and this is true, people adjacent to the mob will suffer the ranged instead of using a melee attack.

	var/vision_range = 7				// How far the targeting system will look for things to kill. Note that values higher than 7 are 'offscreen' and might be unsporting.

/**************
* Strategical *
**************/

// Step 1, find out what we can see.
/datum/ai_holder/proc/list_targets()
	. = hearers(vision_range, holder) - src // Remove ourselves to prevent suicidal decisions.

	var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha))

	for(var/HM in typecache_filter_list(range(vision_range, holder), hostile_machines))
		if(can_see(holder, HM, vision_range))
			. += HM

// Step 2, filter down possible targets to things we actually care about.
/datum/ai_holder/proc/find_target(var/list/possible_targets, var/has_targets_list = FALSE)
	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	for(var/possible_target in possible_targets)
		var/atom/A = possible_target
//		if(Found(A)) // In case people want to override this.
//			. = list(A)
//			break
		if(can_attack(A)) // Can we attack it?
			. += A
			continue

	var/new_target = pick_target(.)
	give_target(new_target)
	return new_target

// Step 3, pick among the possible, attackable targets.
/datum/ai_holder/proc/pick_target(list/targets)
	if(target != null) // If we already have a target, but are told to pick again, calculate the lowest distance between all possible, and pick from the lowest distance targets.
		for(var/possible_target in targets)
			var/atom/A = possible_target
			var/target_dist = get_dist(holder, target)
			var/possible_target_distance = get_dist(holder, A)
			if(target_dist < possible_target_distance)
				targets -= A
	if(!targets.len) // We found nothing.
		return
	var/chosen_target = pick(targets)
	return chosen_target

// Step 4, give us our selected target.
/datum/ai_holder/proc/give_target(new_target)
	target = new_target
	//LosePatience()
	if(target != null)
		//GainPatience()
		//Aggro()
		if(should_threaten())
			set_stance(STANCE_ALERT)
		else
			set_stance(STANCE_ATTACK)
		return TRUE

/datum/ai_holder/proc/can_attack(atom/movable/the_target)
	if(!the_target) // Nothing to attack.
		return FALSE

	if(holder.see_invisible < the_target.invisibility) // Invisible, can't see it, oh well.
		return FALSE

	if(isliving(the_target))
		var/mob/living/L = the_target
		if(L.stat)
			return FALSE
		if(holder.IIsAlly(L))
			return FALSE
		return TRUE

	if(istype(the_target, /obj/mecha))
		var/obj/mecha/M = the_target
		if(M.occupant)
			return can_attack(M.occupant)

	if(istype(the_target, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/P = the_target
		if(P.stat & BROKEN)
			return FALSE // Already dead.
		if(P.faction == holder.faction)
			return FALSE // Don't shoot allied turrets.
		if(!P.raised && !P.raising)
			return FALSE // Turrets won't get hurt if they're still in their cover.
		return TRUE

	return FALSE

/***********
* Tactical *
***********/

// This does the actual attacking.
/datum/ai_holder/proc/engage_target()
	if(!target || !can_attack(target) || (!(target in list_targets())) )
		lose_target()
		return

	var/distance = get_dist(holder, target)
	holder.face_atom(target)
	last_conflict_time = world.time

	// Stab them.
	if(distance <= 1 && !pointblank)
		on_engagement(target)
		if(attack_cooldown_left <= 0)

			pre_melee_attack(target)

			if(melee_attack(target))
				post_melee_attack(target)
				if(attack_cooldown)
					attack_cooldown_left = attack_cooldown

	// Shoot them.
	else if(ranged && (distance <= shoot_range) )
		on_engagement(target)
		if(attack_cooldown_left <= 0)

			if(firing_lanes && !test_projectile_safety(target))
				// Nudge them a bit, maybe they can shoot next time.
				step_rand(holder)
				holder.face_atom(target)
				return

			pre_ranged_attack(target)

			if(ranged_attack(target))
				post_ranged_attack(target)
				if(attack_cooldown)
					attack_cooldown_left = attack_cooldown

	// Run after them.
	else
		set_stance(STANCE_ATTACK)

// We're not entirely sure how holder will do melee attacks since any /mob/living could be holder, but we don't have to care because Interfaces.
/datum/ai_holder/proc/melee_attack(atom/movable/AM)
	return holder.IAttack(AM)

// Ditto.
/datum/ai_holder/proc/ranged_attack(atom/movable/AM)
	return holder.IRangedAttack(AM)

// Called when within striking distance, however cooldown is not considered.
/datum/ai_holder/proc/on_engagement(atom/movable/AM)

// These two are called before an attack attempt.
/datum/ai_holder/proc/pre_melee_attack(atom/movable/AM)

/datum/ai_holder/proc/pre_ranged_attack(atom/movable/AM)

// These two are called after a successful(ish) attack.
/datum/ai_holder/proc/post_melee_attack(atom/movable/AM)

/datum/ai_holder/proc/post_ranged_attack(atom/movable/AM)

// Used to make sure projectiles will probably hit the target and not the wall or a friend.
/datum/ai_holder/proc/test_projectile_safety(atom/movable/AM)
	var/mob/living/L = check_trajectory(AM, holder) // This isn't always reliable but its better than the previous method.
//	world << "Checked trajectory, would hit [L]."

	if(istype(L)) // Did we hit a mob?
//		world << "Hit [L]."
		if(holder.IIsAlly(L))
//			world << "Would hit ally, canceling."
			return FALSE // We would hit a friend!
//		world << "Won't threaten ally, firing."
		return TRUE // Otherwise we don't care, even if its not the intended target.
	else
		if(!isliving(AM)) // If the original target was an object, then let it happen if it doesn't threaten an ally.
//			world << "Targeting object, ignoring and firing."
			return TRUE
//	world << "Not sure."

	return !conserve_ammo // If we have infinite ammo than shooting the wall isn't so bad, but otherwise lets not.

//We can't see the target
/datum/ai_holder/proc/lose_target()
	target = null
	set_stance(STANCE_IDLE)
	give_up_movement()

//Target is no longer valid (?)
/datum/ai_holder/proc/lost_target()
	set_stance(STANCE_IDLE)
	give_up_movement()

// Can be used to conditionally do a ranged or melee attack.
/datum/ai_holder/proc/closest_distance()
	return ranged ? shoot_range - 1 : 1 // Shoot range -1 just because we don't want to constantly get kited
