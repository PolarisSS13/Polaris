/mob/living/exosuit/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))
		return 0
	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		if(effect > 0 && effecttype == IRRADIATE)
			effect = max((1-(getarmor(null, "rad")/100))*effect/(blocked+1),0)
		var/mob/living/pilot = pick(pilots)
		return pilot.apply_effect(effect, effecttype, blocked)
	if(!(effecttype in list(AGONY, STUTTER, EYE_BLUR, DROWSY, WEAKEN)))
		. = ..()

/mob/living/exosuit/resolve_item_attack(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!I.force)
		user.visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly with \the [I]."))
		return

	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		var/mob/living/pilot = pick(pilots)
		return pilot.resolve_item_attack(I, user, def_zone)

	return def_zone //Careful with effects

/mob/living/exosuit/hitby(var/atom/movable/AM, var/speed)
	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		var/mob/living/pilot = pick(pilots)
		return pilot.hitby(AM, speed)
	. = ..()

/mob/living/exosuit/getarmor(def_zone, type)
	var/armorval = 0
	if(body)
		armorval = body.get_armor(type)
		if(isnull(armorval))
			armorval = 0

		for(var/thing in modifiers)
			var/datum/modifier/M = thing
			var/modifier_armor = LAZYACCESS(M.armor_percent, type)
			if(modifier_armor)
				armorval += modifier_armor

	return armorval

/mob/living/exosuit/getsoak(def_zone, type)
	return round(getarmor(def_zone, type) / 10)

/mob/living/exosuit/updatehealth()
	maxHealth = body.mech_health
	health = maxHealth-(getFireLoss()+getBruteLoss())

/mob/living/exosuit/adjustFireLoss(var/amount, var/obj/item/mech_component/MC = pick(list(arms, legs, body, head)))
	if(MC)
		MC.take_burn_damage(amount)
		MC.update_health()

/mob/living/exosuit/adjustBruteLoss(var/amount, var/obj/item/mech_component/MC = pick(list(arms, legs, body, head)))
	if(MC)
		MC.take_brute_damage(amount)
		MC.update_health()

/mob/living/exosuit/proc/zoneToComponent(var/zone)
	switch(zone)
		if(O_EYES , BP_HEAD)
			return head
		if(BP_L_ARM , BP_R_ARM)
			return arms
		if(BP_L_LEG , BP_R_LEG)
			return legs
		else
			return body

// Override for exosuits, since they don't take many types of damage a 'living' thing does.
/mob/living/exosuit/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/soaked = 0, var/used_weapon = null, var/sharp = 0, var/edge = 0, var/obj/used_weapon = null)
	if(Debug2)
		to_world_log("## DEBUG: apply_damage() was called on [src], with [damage] damage, and an armor value of [blocked].")
	if(!damage || (blocked >= 100))
		return 0
	if(soaked)
		if(soaked >= round(damage*0.8))
			damage -= round(damage*0.8)
		else
			damage -= soaked

	var/initial_blocked = blocked

	var/target = zoneToComponent(def_zone)

	if((damagetype == BRUTE || damagetype == BURN) && prob(25+(damage*2)))
		sparks.set_up(3,0,src)
		sparks.start()

	blocked = (100-blocked)/100
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage * blocked, target)
		if(BURN)
			adjustFireLoss(damage * blocked, target)
		if(SEARING)
			apply_damage(round(damage / 3), BURN, def_zone, initial_blocked, soaked, used_weapon, sharp, edge)
			apply_damage(round(damage / 3 * 2), BRUTE, def_zone, initial_blocked, soaked, used_weapon, sharp, edge)
		if(ELECTROCUTE)
			electrocute_act(damage, used_weapon, 1.0, def_zone)
		if(BIOACID)
			if(isSynthetic())
				apply_damage(damage, BURN, def_zone, initial_blocked, soaked, used_weapon, sharp, edge)	// Handle it as normal burn.

	flash_weak_pain()
	updatehealth()
	return 1

/mob/living/exosuit/getFireLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.burn_damage
	return total

/mob/living/exosuit/getBruteLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.brute_damage
	return total

/mob/living/exosuit/emp_act(var/severity)

	var/ratio = getarmor(null, "energy")/100

	if(ratio >= 0.5)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("Your Faraday shielding absorbed the pulse!"))
		return
	else if(ratio > 0)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("Your Faraday shielding mitigated the pulse!"))

	emp_damage += round((12 - (severity*3))*( 1 - ratio))
	if(severity <= 3)
		for(var/obj/item/thing in list(arms,legs,head,body))
			thing.emp_act(severity)
		if(!hatch_closed || !prob(body.pilot_coverage))
			for(var/thing in pilots)
				var/mob/pilot = thing
				pilot.emp_act(severity)
