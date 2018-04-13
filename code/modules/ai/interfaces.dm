// 'Interfaces' are procs that the ai_holder datum uses to communicate its will to the mob its attached.
// The reason for using this proc in the middle is to ensure the AI has some form of compatibility with most mob types,
// since some actions work very differently between mob types (e.g. executing an attack as a simple animal compared to a human).
// The AI can just call holder.IAttack(target) and the mob is responsible for determining how to actually attack the target.

/mob/living/proc/IAttack(atom/A)
	return FALSE

/mob/living/simple_mob/IAttack(atom/A)
	return attack_target(A)

/mob/living/proc/IRangedAttack(atom/A)
	return FALSE

/mob/living/simple_mob/IRangedAttack(atom/A)
	return shoot_target(A)

/mob/living/proc/ISpecialAttack(atom/A)
	return FALSE

/mob/living/simple_mob/ISpecialAttack(atom/A)
	return special_attack_target(A)

/mob/living/proc/ISay(message)

/mob/living/proc/IIsAlly(mob/living/L)
	return src.faction == L.faction

/mob/living/simple_animal/IIsAlly(mob/living/L)
	. = ..()
	if(!.) // Outside the faction, try to see if they're friends.
		return L in friends

/mob/living/simple_mob/IIsAlly(mob/living/L)
	. = ..()
	if(!.) // Outside the faction, try to see if they're friends.
		return L in friends

/mob/living/proc/IGetID()

/mob/living/simple_animal/IGetID()
	if(myid)
		return myid.GetID()

// Respects move cooldowns as if it had a client.
/mob/living/proc/IMove(newloc)
	if(check_move_cooldown())
//		if(!newdir)
//			newdir = get_dir(get_turf(src), newloc)

		// Move()ing to another tile successfully returns 32 because BYOND. Would rather deal with TRUE/FALSE-esque terms.
		// Note that moving to the same tile will be 'successful'.
		var/turf/old_T = get_turf(src)
		. = SelfMove(newloc) ? MOVEMENT_SUCCESSFUL : MOVEMENT_FAILED
		if(. == MOVEMENT_SUCCESSFUL)
			set_dir(get_dir(old_T, newloc))
			// Apply movement delay.
			// Player movement has more factors but its all in the client and fixing that would be its own project.
			setMoveCooldown(movement_delay())
		return

	. = MOVEMENT_ON_COOLDOWN // To avoid superfast mobs that aren't meant to be superfast. Is actually -1.
