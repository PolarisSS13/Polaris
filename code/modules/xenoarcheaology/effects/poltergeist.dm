
/datum/artifact_effect/poltergeist
	name = "poltergeist"
	effect_type = EFFECT_ENERGY

/datum/artifact_effect/poltergeist/proc/throw_at_mob(var/mob/living/target, var/damage = 20)
	var/list/valid_targets = list()

	for(var/obj/O in view(world.view, target))
		if(!O.anchored)
			valid_targets |= O

	if(valid_targets.len)
		var/obj/obj_to_throw = pick(valid_targets)
		obj_to_throw.visible_message("<span class='alien'>\The [obj_to_throw] levitates, befure hurtling toward [target]!</span>")
		obj_to_throw.throw_at(target, world.view, damage * GetAnomalySusceptibility(target))

/datum/artifact_effect/poltergeist/DoEffectTouch(var/mob/user)
	throw_at_mob(user, rand(10, 30))

/datum/artifact_effect/poltergeist/DoEffectAura()
	var/mob/living/target = null
	for(var/mob/living/L in view(holder, effectrange))
		if(L.stat || !L.mind)
			continue

		if(target && get_dist(holder, L) > get_dist(holder, target))
			continue

		target = L

	if(target)
		throw_at_mob(target, rand(15, 30))

/datum/artifact_effect/poltergeist/DoEffectPulse()
	var/mob/living/target = null
	for(var/mob/living/L in view(holder, effectrange))
		if(L.stat || !L.mind)
			continue

		if(target && get_dist(holder, L) > get_dist(holder, target))
			continue

		target = L

	if(target)
		throw_at_mob(target, chargelevelmax)
