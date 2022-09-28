/datum/artifact_effect/rare/feysight
	name = "feysight"
	effect_type = EFFECT_PSIONIC
	effect_state = "pulsing"
	effect_color = "#00c763"


/datum/artifact_effect/rare/feysight/DoEffectTouch(mob/living/user)
	if (user && isliving(user))
		apply_modifier(user)


/datum/artifact_effect/rare/feysight/DoEffectAura()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			if (prob(10))
				apply_modifier(L)


/datum/artifact_effect/rare/feysight/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			apply_modifier(L)


/datum/artifact_effect/rare/feysight/proc/apply_modifier(mob/living/L)
	if (!istype(L))
		return
	if (!L.is_sentient())
		return
	if (L.add_modifier(/datum/modifier/feysight, 30 SECONDS))
		to_chat(L, "<span class='alien'>An otherworldly feeling seems to enter your mind, and you feel at peace.</span>")
		L.adjustHalLoss(10)
		to_chat(L, "<span class='danger'>The inside of your head hurts...</span>")
		return
	else
		if (L.has_modifier_of_type(/datum/modifier/feysight))
			to_chat(L, "<span class='warning'>An otherworldly feeling seems to enter your mind again, and it holds the visions in place.</span>")
		else
			to_chat(L, "<span class='warning'>An otherworldly feeling seems to enter your mind, and you briefly feel peace, but \
			it quickly passes.</span>")
		return
