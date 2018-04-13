// Specialized AI for slime simplemobs.
// Unlike the parent AI code, this will probably break a lot of things if you put it on something that isn't /mob/living/simple_animal/slime

/datum/ai_holder/normal/slime

/datum/ai_holder/normal/slime/New()
	..()
	ASSERT(istype(holder, /mob/living/simple_animal/slime))

/datum/ai_holder/normal/slime/find_target(var/list/possible_targets, var/has_targets_list = FALSE)
	var/mob/living/simple_animal/slime/me = holder
	if(me.victim) // Don't worry about finding another target if we're eatting someone.
		return
	if(leader && me.can_command(leader)) // If following someone, don't attack until the leader says so, something hits you, or the leader is no longer worthy.
		return
	..()

/datum/ai_holder/normal/slime/found(mob/living/L)
	var/mob/living/simple_animal/slime/me = holder
	if(isliving(L))
		if(can_attack(L))
			if(L.faction == me.faction && !attack_same_faction)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
						return H // Monkeys are always food.
					else
						return

	//		if(L in friends)
	//			return

			if(istype(L, /mob/living/simple_animal/slime))
				var/mob/living/simple_animal/slime/buddy = L
				if(buddy.slime_color == me.slime_color || me.discipline || me.unity || buddy.unity)
					return // Don't hurt same colored slimes.
				else
					return buddy	//do hurt others

			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
					return H // Monkeys are always food.

			if(issilicon(L) || isbot(L))
				if(me.discipline && !me.rabid)
					return // We're a good slime.  For now at least.
			return
	return

/datum/ai_holder/normal/slime/closest_distance()
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat)
			return 1 // Melee (eat) the target if dying, don't shoot it.
	return ..()


/datum/ai_holder/normal/slime/help_requested(var/mob/living/simple_animal/slime/buddy)
	var/mob/living/simple_animal/slime/me = holder
	if(istype(buddy))
		if(buddy.slime_color != me.slime_color && (!me.unity || !buddy.unity)) // We only help slimes of the same color, if it's another slime calling for help.
		//	ai_log("HelpRequested() by [buddy] but they are a [buddy.slime_color] while we are a [src.slime_color].",2)
			ai_log("help_requested() : Help was requested by [buddy] but they are a [buddy.slime_color] while we are a [me.slime_color].", AI_LOG_INFO)
			return
	..()


/datum/ai_holder/normal/slime/handle_resist()
	var/mob/living/simple_animal/slime/me = holder
	if(me.buckled && me.victim && isliving(me.buckled) && me.victim == me.buckled) // If it's buckled to a living thing it's probably eating it.
		return
	else
		..()


/datum/ai_holder/normal/slime/melee_attack(atom/A)
	var/mob/living/simple_animal/slime/me = holder
	if(isliving(A))
		var/mob/living/L = A
		if( (!L.lying && prob(60 + (me.power_charge * 4) ) || (!L.lying && me.optimal_combat) )) // "Smart" slimes always stun first.
			me.a_intent = I_DISARM // Stun them first.
		else if(me.can_consume(L) && L.lying)
			me.a_intent = I_GRAB // Then eat them.
		else
			me.a_intent = I_HURT // Otherwise robust them.
	..(A)

/*
/mob/living/simple_animal/slime/PunchTarget()
	if(victim)
		return // Already eatting someone.
	if(!client) // AI controlled.
		if( (!target_mob.lying && prob(60 + (power_charge * 4) ) || (!target_mob.lying && optimal_combat) )) // "Smart" slimes always stun first.
			a_intent = I_DISARM // Stun them first.
		else if(can_consume(target_mob) && target_mob.lying)
			a_intent = I_GRAB // Then eat them.
		else
			a_intent = I_HURT // Otherwise robust them.
	ai_log("PunchTarget() will [a_intent] [target_mob]",2)
	..()
*/