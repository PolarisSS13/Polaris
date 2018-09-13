// Specialized AI for slime simplemobs.
// Unlike the parent AI code, this will probably break a lot of things if you put it on something that isn't /mob/living/simple_animal/slime/xenobio

/datum/ai_holder/simple_mob/xenobio_slime
	hostile = TRUE
	cooperative = TRUE
	firing_lanes = TRUE
	var/rabid = FALSE	// Will attack regardless of discipline.
	var/discipline = 0	// Beating slimes makes them less likely to lash out.  In theory.
	var/resentment = 0	// 'Unjustified' beatings make this go up, and makes it more likely for abused slimes to go rabid.
	var/obedience = 0	// Conversely, 'justified' beatings make this go up, and makes discipline decay slowly, potentially making it not decay at all.

	var/always_stun = FALSE // If true, the slime will elect to attempt to permastun the target.

/datum/ai_holder/simple_mob/xenobio_slime/sapphire
	always_stun = TRUE // They know that stuns are godly.


/datum/ai_holder/simple_mob/xenobio_slime/New()
	..()
	ASSERT(istype(holder, /mob/living/simple_mob/slime/xenobio))

// Checks if disciplining the slime would be 'justified' right now.
/datum/ai_holder/simple_mob/xenobio_slime/proc/is_justified_to_discipline()
	if(rabid)
		return TRUE
	if(target)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(istype(H.species, /datum/species/monkey))
				return FALSE // Attacking monkeys is okay.
		return TRUE // Otherwise attacking other things is bad.
	return FALSE // Not attacking anything.

/datum/ai_holder/simple_mob/xenobio_slime/proc/can_command(mob/living/commander)
	if(rabid)
		return FALSE
	if(!hostile)
		return SLIME_COMMAND_OBEY
//	if(commander in friends)
//		return SLIME_COMMAND_FRIEND
	if(holder.IIsAlly(commander))
		return SLIME_COMMAND_FACTION
	if(discipline > resentment && obedience >= 5)
		return SLIME_COMMAND_OBEY
	return FALSE

/datum/ai_holder/simple_mob/xenobio_slime/proc/adjust_discipline(amount, silent)
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	if(amount > 0)
		if(rabid)
			return
		var/justified = is_justified_to_discipline()
		lost_target() // Stop attacking.

		if(justified)
			obedience++
			if(!silent)
				holder.say(pick("Fine...", "Okay...", "Sorry...", "I yield...", "Mercy..."))
		else
			if(prob(resentment * 20))
				enrage()
				holder.say(pick("Evil...", "Kill...", "Tyrant..."))
			else
				if(!silent)
					holder.say(pick("Why...?", "I don't understand...?", "Cruel...", "Stop...", "Nooo..."))
			resentment++ // Done after check so first time will never enrage.

	discipline = between(0, discipline + amount, 10)
	my_slime.update_mood()

/datum/ai_holder/simple_mob/xenobio_slime/handle_special_strategical()
	discipline_decay()

// Handles decay of discipline.
/datum/ai_holder/simple_mob/xenobio_slime/proc/discipline_decay()
	if(discipline > 0)
		if(!prob(75 + (obedience * 5)))
			adjust_discipline(-1)

/datum/ai_holder/simple_mob/xenobio_slime/handle_special_tactic()
	evolve_and_reproduce()

// Hit the correct verbs to keep the slime species going.
/datum/ai_holder/simple_mob/xenobio_slime/proc/evolve_and_reproduce()
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	if(my_slime.amount_grown >= 10)
		// Press the correct verb when we can.
		if(my_slime.is_adult)
			my_slime.reproduce() // Splits into four new baby slimes.
		else
			my_slime.evolve() // Turns our holder into an adult slime.


// Called when pushed too far (or a red slime core was used).
/datum/ai_holder/simple_mob/xenobio_slime/proc/enrage()
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	if(my_slime.harmless)
		return
	rabid = TRUE
	my_slime.update_mood()
	my_slime.visible_message(span("danger", "\The [src] enrages!"))

// Called when using a pacification agent (or it's Kendrick being initalized).
/datum/ai_holder/simple_mob/xenobio_slime/proc/pacify()
	lost_target() // So it stops trying to kill them.
	rabid = FALSE
	hostile = FALSE
	retaliate = FALSE
	cooperative = FALSE

// The holder's attack changes based on intent. This lets the AI choose what effect is desired.
/datum/ai_holder/simple_mob/xenobio_slime/pre_melee_attack(atom/A)
	if(istype(A, /mob/living))
		var/mob/living/L = A
		var/mob/living/simple_mob/slime/xenobio/my_slime = holder

		if( (!L.lying && prob(30 + (my_slime.power_charge * 7) ) || (!L.lying && always_stun) ))
			my_slime.a_intent = I_DISARM // Stun them first.
		else if(my_slime.can_consume(L) && L.lying)
			my_slime.a_intent = I_GRAB // Then eat them.
		else
			my_slime.a_intent = I_HURT // Otherwise robust them.

/datum/ai_holder/simple_mob/xenobio_slime/closest_distance(atom/movable/AM)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(istype(H.species, /datum/species/monkey))
				return 1 // Otherwise ranged slimes will eat a lot less often.
		if(L.stat >= UNCONSCIOUS)
			return 1 // Melee (eat) the target if dead/dying, don't shoot it.
	return ..()

/datum/ai_holder/simple_mob/xenobio_slime/can_attack(atom/movable/AM)
	. = ..()
	if(.) // Do some additional checks because we have Special Code(tm).
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
				return TRUE // Monkeys are always food (sorry Pun Pun).
			else if(H.species && H.species.name == SPECIES_PROMETHEAN)
				return FALSE // Prometheans are always our friends.
		if(discipline && !rabid)
			return FALSE // We're a good slime.

/*

/mob/living/simple_animal/slime/special_target_check(mob/living/L)
	if(L.faction == faction && !attack_same && !istype(L, /mob/living/simple_animal/slime))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
				return TRUE // Monkeys are always food.
			else
				return FALSE
	if(L in friends)
		return FALSE

	if(istype(L, /mob/living/simple_animal/slime))
		var/mob/living/simple_animal/slime/buddy = L
		if(buddy.slime_color == src.slime_color || discipline || unity || buddy.unity)
			return FALSE // Don't hurt same colored slimes.

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.species && H.species.name == "Promethean")
			return FALSE // Prometheans are always our friends.
		else if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
			return TRUE // Monkeys are always food.
		if(discipline && !rabid)
			return FALSE // We're a good slime.  For now at least

	if(issilicon(L) || isbot(L) )
		if(discipline && !rabid)
			return FALSE // We're a good slime.  For now at least.
	return ..() // Other colors and nonslimes are jerks however.
*/