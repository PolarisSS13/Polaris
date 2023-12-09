
/datum/artifact_effect/uncommon/disarmament
	name = "disarmament"
	effect_type = EFFECT_PSIONIC
	effect_state = "impact_laser_monochrome"
	effect_color = "#e17ceb"

/datum/artifact_effect/uncommon/disarmament/proc/disarm(var/mob/living/L)
	if(istype(L) && L.is_sentient())
		var/obj/item/Item = L.get_active_hand()
		if(istype(Item))
			to_chat(L, SPAN_WARNING("Something forces you to drop \the [Item]."))
			L.drop_item()

/datum/artifact_effect/uncommon/disarmament/DoEffectTouch(mob/living/user)
	var/weakness = GetAnomalySusceptibility(user)
	if(prob(weakness * 100))
		disarm(user)

/datum/artifact_effect/uncommon/disarmament/DoEffectPulse()
	var/turf/T = get_turf(get_master_holder())
	for(var/mob/living/L in oview(src.effectrange, T))
		var/weakness = GetAnomalySusceptibility(L)
		if(prob(weakness * 100))
			disarm(L)

/datum/artifact_effect/uncommon/disarmament/DoEffectAura()
	var/turf/T = get_turf(get_master_holder())
	for(var/mob/living/L in oview(src.effectrange, T))
		var/weakness = GetAnomalySusceptibility(L)
		if(prob(10) && prob(weakness * 100))
			disarm(L)
