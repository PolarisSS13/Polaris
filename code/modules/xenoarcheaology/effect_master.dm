
/*
 * Here there be dragons.
 */

/atom/var/datum/artifact_master/artifact_master

/atom/Initialize()
	. = ..()

	if(ispath(artifact_master))
		artifact_master = new artifact_master(src)

/atom/Destroy()
	if(artifact_master)
		QDEL_NULL(artifact_master)

	. = ..()

/atom/attack_hand(var/mob/user as mob)
	. = ..()

	if(artifact_master)
		artifact_master.on_attack_hand(user)

/atom/attackby(obj/item/weapon/W as obj, mob/living/user as mob)
	. = ..()

	if(artifact_master)
		artifact_master.on_attackby(W, user)

/atom/Bumped(M as mob|obj)
	. = ..()

	if(artifact_master)
		artifact_master.on_bumped(M)

/atom/movable/Bump(var/atom/bumped)
	. = ..()

	if(artifact_master)
		artifact_master.on_bump(bumped)

/atom/bullet_act(var/obj/item/projectile/P)
	. = ..()

	if(artifact_master)
		artifact_master.on_bullet(P)

/atom/ex_act(severity)
	if(artifact_master)
		artifact_master.on_exact(severity)

	. = ..()

/atom/movable/Moved()
	. = ..()
	if(artifact_master)
		artifact_master.on_moved()

/datum/artifact_master
	var/atom/holder
	var/list/my_effects

	var/effect_generation_chance = 100

	var/list/make_effects

	var/artifact_id

/datum/artifact_master/proc/get_active_effects()
	var/list/active_effects = list()
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(my_effect.activated)
			active_effects |= my_effect

	return active_effects

/datum/artifact_master/proc/add_effect()
	var/effect_type = input(usr, "What type do you want?", "Effect Type") as null|anything in typesof(/datum/artifact_effect) - /datum/artifact_effect
	if(effect_type)
		var/datum/artifact_effect/my_effect = new effect_type(src)
		if(istype(holder, my_effect.req_type))
			my_effects += my_effect

		else
			to_chat(usr, "This effect can not be applied to this atom type.")
			qdel(my_effect)

/datum/artifact_master/proc/remove_effect()
	var/to_remove_effect = input(usr, "What effect do you want to remove?", "Remove Effect") as null|anything in my_effects

	if(to_remove_effect)
		var/datum/artifact_effect/AE = to_remove_effect
		my_effects.Remove(to_remove_effect)
		qdel(AE)

/datum/artifact_master/New(var/atom/newholder)
	holder = newholder

	if(!holder)
		qdel(src)
		return

	my_effects = list()

	START_PROCESSING(SSobj, src)

	do_setup()

/datum/artifact_master/Destroy()
	holder = null
	for(var/datum/artifact_effect/AE in my_effects)
		AE.master = null
		qdel(AE)

	STOP_PROCESSING(SSobj,src)

	. = ..()

/datum/artifact_master/proc/do_setup()
	if(LAZYLEN(make_effects))
		for(var/path in make_effects)
			var/datum/artifact_effect/new_effect = new path(src)
			if(istype(holder, new_effect.req_type))
				my_effects += new_effect

	else
		generate_effects()

/datum/artifact_master/proc/generate_effects()
	while(effect_generation_chance > 0)
		var/chosen_path = pick(subtypesof(/datum/artifact_effect))
		if(effect_generation_chance >= 100)	// If we're above 100 percent, just cut a flat amount and add an effect.
			var/datum/artifact_effect/AE = new chosen_path(src)
			if(istype(holder, AE.req_type))
				my_effects += AE
				effect_generation_chance -= 30
			else
				AE.master = src
				qdel(AE)
			continue

		effect_generation_chance /= 2

		if(prob(effect_generation_chance))	// Otherwise, add effects as normal, with decreasing probability.
			my_effects += new chosen_path(src)

/datum/artifact_master/proc/get_holder()	// Returns the holder.
	return holder

/datum/artifact_master/proc/get_primary()
	if(LAZYLEN(my_effects))
		return my_effects[1]
	return FALSE

/*
 * Trigger code.
 */

/datum/artifact_master/proc/on_exact(severity)
	for(var/datum/artifact_effect/my_effect in my_effects)
		switch(severity)
			if(1.0)
				if(my_effect.trigger == TRIGGER_FORCE || my_effect.trigger == TRIGGER_HEAT ||  my_effect.trigger == TRIGGER_ENERGY)
					my_effect.ToggleActivate()
			if(2.0)
				if(my_effect.trigger == TRIGGER_FORCE || my_effect.trigger == TRIGGER_HEAT)
					my_effect.ToggleActivate()
			if(3.0)
				if (my_effect.trigger == TRIGGER_FORCE)
					my_effect.ToggleActivate()
	return

/datum/artifact_master/proc/on_bullet(var/obj/item/projectile/P)
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(istype(P,/obj/item/projectile/bullet))
			if(my_effect.trigger == TRIGGER_FORCE)
				my_effect.ToggleActivate()

		else if(istype(P,/obj/item/projectile/beam) ||\
			istype(P,/obj/item/projectile/ion) ||\
			istype(P,/obj/item/projectile/energy))
			if(my_effect.trigger == TRIGGER_ENERGY)
				my_effect.ToggleActivate()

/datum/artifact_master/proc/on_bump(var/atom/bumped)
	var/warn = FALSE
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(istype(bumped,/obj))
			if(bumped:throwforce >= 10)
				if(my_effect.trigger == TRIGGER_FORCE)
					my_effect.ToggleActivate()

		else if(ishuman(bumped) && GetAnomalySusceptibility(bumped) >= 0.5)
			if (my_effect.trigger == TRIGGER_TOUCH && prob(50))
				my_effect.ToggleActivate()
				warn = 1

			if (my_effect.effect == EFFECT_TOUCH && prob(50))
				my_effect.DoEffectTouch(bumped)
				warn = 1

	if(warn && isliving(bumped))
		to_chat(bumped, "<b>You accidentally touch \the [holder] as it hits you.</b>")

/datum/artifact_master/proc/on_bumped(M as mob|obj)
	var/warn = FALSE
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(istype(M,/obj))
			if(M:throwforce >= 10)
				if(my_effect.trigger == TRIGGER_FORCE)
					my_effect.ToggleActivate()

		else if(ishuman(M) && !istype(M:gloves,/obj/item/clothing/gloves))
			if (my_effect.trigger == TRIGGER_TOUCH && prob(50))
				my_effect.ToggleActivate()
				warn = 1

			if (my_effect.effect == EFFECT_TOUCH && prob(50))
				my_effect.DoEffectTouch(M)
				warn = 1

	if(warn && isliving(M))
		to_chat(M, "<b>You accidentally touch \the [holder].</b>")

/datum/artifact_master/proc/on_attack_hand(var/mob/living/user)
	if(!istype(user))
		return

	if (get_dist(user, holder) > 1)
		to_chat(user, "<font color='red'>You can't reach [holder] from here.</font>")
		return
	if(ishuman(user) && user:gloves)
		to_chat(user, "<b>You touch [holder]</b> with your gloved hands, [pick("but nothing of note happens","but nothing happens","but nothing interesting happens","but you notice nothing different","but nothing seems to have happened")].")
		return

	var/triggered = FALSE

	for(var/datum/artifact_effect/my_effect in my_effects)

		if(my_effect.trigger == TRIGGER_TOUCH)
			triggered = TRUE
			my_effect.ToggleActivate()

		if (my_effect.effect == EFFECT_TOUCH)
			triggered = TRUE
			my_effect.DoEffectTouch(user)

	if(triggered)
		to_chat(user, "<b>You touch [holder].</b>")

	else
		to_chat(user, "<b>You touch [holder],</b> [pick("but nothing of note happens","but nothing happens","but nothing interesting happens","but you notice nothing different","but nothing seems to have happened")].")


/datum/artifact_master/proc/on_attackby(obj/item/weapon/W as obj, mob/living/user as mob)
	for(var/datum/artifact_effect/my_effect in my_effects)

		if (istype(W, /obj/item/weapon/reagent_containers))
			if(W.reagents.has_reagent("hydrogen", 1) || W.reagents.has_reagent("water", 1))
				if(my_effect.trigger == TRIGGER_WATER)
					my_effect.ToggleActivate()
			else if(W.reagents.has_reagent("sacid", 1) || W.reagents.has_reagent("pacid", 1) || W.reagents.has_reagent("diethylamine", 1))
				if(my_effect.trigger == TRIGGER_ACID)
					my_effect.ToggleActivate()
			else if(W.reagents.has_reagent("phoron", 1) || W.reagents.has_reagent("thermite", 1))
				if(my_effect.trigger == TRIGGER_VOLATILE)
					my_effect.ToggleActivate()
			else if(W.reagents.has_reagent("toxin", 1) || W.reagents.has_reagent("cyanide", 1) || W.reagents.has_reagent("amatoxin", 1) || W.reagents.has_reagent("neurotoxin", 1))
				if(my_effect.trigger == TRIGGER_TOXIN)
					my_effect.ToggleActivate()
		else if(istype(W,/obj/item/weapon/melee/baton) && W:status ||\
				istype(W,/obj/item/weapon/melee/energy) ||\
				istype(W,/obj/item/weapon/melee/cultblade) ||\
				istype(W,/obj/item/weapon/card/emag) ||\
				istype(W,/obj/item/device/multitool))
			if (my_effect.trigger == TRIGGER_ENERGY)
				my_effect.ToggleActivate()

		else if (istype(W,/obj/item/weapon/flame) && W:lit ||\
				istype(W,/obj/item/weapon/weldingtool) && W:welding)
			if(my_effect.trigger == TRIGGER_HEAT)
				my_effect.ToggleActivate()
		else
			..()
			if (my_effect.trigger == TRIGGER_FORCE && W.force >= 10)
				my_effect.ToggleActivate()

/datum/artifact_master/proc/on_moved()
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(my_effect)
			my_effect.UpdateMove()

/datum/artifact_master/process()
	var/turf/L = holder.loc
	if(!istype(L) || !isliving(L)) 	// We're inside a non-mob container or on null turf, either way stop processing effects
		return

	if(istype(holder, /atom/movable))
		var/atom/movable/HA = holder
		if(HA.pulledby)
			on_bumped(HA.pulledby)

	//if any of our effects rely on environmental factors, work that out
	var/trigger_cold = 0
	var/trigger_hot = 0
	var/trigger_phoron = 0
	var/trigger_oxy = 0
	var/trigger_co2 = 0
	var/trigger_nitro = 0

	var/turf/T = get_turf(holder)
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		if(env.temperature < 225)
			trigger_cold = 1
		else if(env.temperature > 375)
			trigger_hot = 1

		if(env.gas["phoron"] >= 10)
			trigger_phoron = 1
		if(env.gas["oxygen"] >= 10)
			trigger_oxy = 1
		if(env.gas["carbon_dioxide"] >= 10)
			trigger_co2 = 1
		if(env.gas["nitrogen"] >= 10)
			trigger_nitro = 1

	for(var/datum/artifact_effect/my_effect in my_effects)
		my_effect.artifact_id = artifact_id

		//COLD ACTIVATION
		if(trigger_cold)
			if(my_effect.trigger == TRIGGER_COLD && !my_effect.activated)
				my_effect.ToggleActivate()
		else
			if(my_effect.trigger == TRIGGER_COLD && my_effect.activated)
				my_effect.ToggleActivate()

		//HEAT ACTIVATION
		if(trigger_hot)
			if(my_effect.trigger == TRIGGER_HEAT && !my_effect.activated)
				my_effect.ToggleActivate()
		else
			if(my_effect.trigger == TRIGGER_HEAT && my_effect.activated)
				my_effect.ToggleActivate()

		//PHORON GAS ACTIVATION
		if(trigger_phoron)
			if(my_effect.trigger == TRIGGER_PHORON && !my_effect.activated)
				my_effect.ToggleActivate()
		else
			if(my_effect.trigger == TRIGGER_PHORON && my_effect.activated)
				my_effect.ToggleActivate()

		//OXYGEN GAS ACTIVATION
		if(trigger_oxy)
			if(my_effect.trigger == TRIGGER_OXY && !my_effect.activated)
				my_effect.ToggleActivate()
		else
			if(my_effect.trigger == TRIGGER_OXY && my_effect.activated)
				my_effect.ToggleActivate()

		//CO2 GAS ACTIVATION
		if(trigger_co2)
			if(my_effect.trigger == TRIGGER_CO2 && !my_effect.activated)
				my_effect.ToggleActivate()
		else
			if(my_effect.trigger == TRIGGER_CO2 && my_effect.activated)
				my_effect.ToggleActivate()

		//NITROGEN GAS ACTIVATION
		if(trigger_nitro)
			if(my_effect.trigger == TRIGGER_NITRO && !my_effect.activated)
				my_effect.ToggleActivate()
		else
			if(my_effect.trigger == TRIGGER_NITRO && my_effect.activated)
				my_effect.ToggleActivate()
