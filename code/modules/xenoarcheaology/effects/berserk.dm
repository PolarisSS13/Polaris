/datum/artifact_effect/uncommon/berserk
	name = "berserk"
	effect_type = EFFECT_PSIONIC
	effect_state = "summoning"
	effect_color = "#5f0000"


/datum/artifact_effect/uncommon/berserk/DoEffectTouch(mob/living/user)
	if (user && isliving(user))
		apply_berserk(user)


/datum/artifact_effect/uncommon/berserk/DoEffectAura()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			if (prob(10))
				apply_berserk(L)


/datum/artifact_effect/uncommon/berserk/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			apply_berserk(L)


/datum/artifact_effect/uncommon/berserk/proc/apply_berserk(mob/living/L)
	if (!istype(L))
		return FALSE
	if (!L.is_sentient())
		return FALSE // Drons are presumably deaf to any psionic things.
	if (L.add_modifier(/datum/modifier/berserk, 30 SECONDS))
		to_chat(L, "<span class='danger'>An otherworldly feeling seems to enter your mind, and it ignites your mind in fury!</span>")
		L.adjustBrainLoss(3) // Playing with berserking alien psychic artifacts isn't good for the mind.
		to_chat(L, "<span class='danger'>The inside of your head hurts...</span>")
		return TRUE
	else
		if (L.has_modifier_of_type(/datum/modifier/berserk)) // Already angry.
			to_chat(L, "<span class='warning'>An otherworldly feeling seems to enter your mind again, and it fans your inner flame, extending your rage.</span>")
		else // Exhausted or something.
			to_chat(L, "<span class='warning'>An otherworldly feeling seems to enter your mind, and you briefly feel an intense anger, but \
			it quickly passes.</span>")
		return FALSE
