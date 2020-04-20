/obj/item/weapon/spell/technomancer
	var/obj/item/weapon/technomancer_core/core = null
//	var/cooldown = 0
	var/spell_metadata_path = null
	var/cooldown_visual_timerid = null

/obj/item/weapon/spell/technomancer/Initialize()
	. = ..()
	if(owner)
		core = owner.get_technomancer_core()
		if(!core)
			to_chat(owner, span("warning", "You need a Core to do that."))
			qdel(src)

/obj/item/weapon/spell/technomancer/Destroy()
	core = null
	if(cooldown_visual_timerid)
		deltimer(cooldown_visual_timerid)
	return ..()

/obj/item/weapon/spell/technomancer/new_spell_icon_visuals()
	// TODO: Add spinny overlay if the spell is toggled/passive/etc.
	handle_cooldown_visuals() // If the player gets a spell that's still on cooldown, it should be shown.

/obj/item/weapon/spell/technomancer/pay_energy(var/amount)
	if(!core)
		return FALSE
	return core.pay_energy(amount)

/obj/item/weapon/spell/technomancer/give_energy(var/amount)
	if(!core)
		return FALSE
	return core.give_energy(amount)

/obj/item/weapon/spell/technomancer/after_cast(mob/user)
	apply_cooldown()
	handle_cooldown_visuals()

/obj/item/weapon/spell/technomancer/proc/get_meta()
	if(!core)
		return null
	return core.spell_metas[spell_metadata_path]

/obj/item/weapon/spell/technomancer/proc/apply_cooldown()
	var/datum/spell_metadata/meta = get_meta()
	if(!meta)
		return FALSE
	meta.last_cast_time = world.time
	return TRUE

// Returns the number of seconds a spell is on cooldown for, or 0 if it isn't on cooldown.
/obj/item/weapon/spell/technomancer/proc/get_cooldown()
	var/datum/spell_metadata/meta = get_meta()
	if(!meta)
		return 0 // It's free real estate.
	return max(0, (meta.last_cast_time + meta.cooldown) - world.time)

// Adjusts the owner's instability, scaled with the core's instability modifier.
/obj/item/weapon/spell/technomancer/proc/adjust_instability(var/amount)
	if(!owner || !core)
		return FALSE
	amount = round(amount * core.instability_modifier, 0.1)
	owner.adjust_instability(amount)

/obj/item/weapon/spell/technomancer/run_checks()
	if(!..())
		return FALSE

	if(!core)
		core = owner.get_technomancer_core()
		if(!core)
			to_chat(owner, span("warning", "You need to be wearing a core on your back!"))
			return FALSE
	if(core.loc != owner || owner.back != core) //Make sure the core's being worn.
		to_chat(owner, span("warning", "You need to be wearing a core on your back!"))
		core = null
		return FALSE
	if(!technomancers.is_antagonist(owner.mind)) //Now make sure the person using this is the actual antag.
		to_chat(owner, span("warning", "You can't seem to figure out how to make the machine work properly."))
		return FALSE
	if(get_cooldown())
		to_chat(owner, span("warning", "It's too soon to invoke this function again. \
		You have to wait for at least [DisplayTimeText(get_cooldown())]."))
		return FALSE
	return TRUE

// Helper proc to check if there's a scepter being used.
/obj/item/weapon/spell/proc/check_for_scepter()
	if(!owner)
		return FALSE
	return owner.is_holding_item_of_type(/obj/item/weapon/scepter)

// Override this for spell casts which have additional functionality when a Scepter is held in the offhand, and the
// scepter is being clicked by the technomancer in their hand.
/obj/item/weapon/spell/technomancer/proc/on_scepter_use_cast(mob/user)
	return

// Similar to the above proc, however this is for when someone with a Scepter clicks something far away with the scepter
// while holding a spell in the offhand that reacts to that.
/obj/item/weapon/spell/technomancer/proc/on_scepter_ranged_cast(atom/hit_atom, mob/user)
	return

// Returns the technomancer's core, assuming it is being worn properly.
/mob/living/proc/get_technomancer_core()
	return null

/mob/living/carbon/human/get_technomancer_core()
	var/obj/item/weapon/technomancer_core/core = back
	if(istype(core))
		return core
	return null


/obj/item/weapon/spell/technomancer/proc/calculate_spell_power(var/amount)
	if(core)
		return round(amount * core.spell_power_modifier, 1)
	return 0

#define COOLDOWN_ICON_STATES 9

/obj/item/weapon/spell/technomancer/proc/handle_cooldown_visuals()
	cooldown_loop()

/obj/item/weapon/spell/technomancer/proc/cooldown_loop()
	if(cooldown_visual_timerid)
		deltimer(cooldown_visual_timerid)
		cooldown_visual_timerid = null

	if(!get_cooldown())
		icon_state = initial(icon_state)
		update_icon()
		return

	var/datum/spell_metadata/meta = get_meta()
	var/icon_state_to_use = (1 - (get_cooldown() / meta.cooldown)) * COOLDOWN_ICON_STATES
	icon_state_to_use = CEILING(between(1, icon_state_to_use, COOLDOWN_ICON_STATES), 1)
	icon_state = "cooldown[icon_state_to_use]"

	if(!cooldown_visual_timerid)
		var/shortest_period = meta.cooldown / COOLDOWN_ICON_STATES
		var/next_period = max(FLOOR(shortest_period, 1), 1)
		// This is deliberately not using TIMER_LOOP because they tend to have `deltimer()` do nothing and loop forever.
		cooldown_visual_timerid = addtimer(CALLBACK(src, .proc/cooldown_loop), next_period, TIMER_STOPPABLE)


#undef COOLDOWN_ICON_STATES