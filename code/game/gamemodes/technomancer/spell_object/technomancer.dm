/obj/item/weapon/spell/technomancer
	var/obj/item/weapon/technomancer_core/core = null

/obj/item/weapon/spell/technomancer/Initialize(newloc)
	. = ..()
	if(owner)
		core = owner.get_technomancer_core()
		if(!core)
			to_chat(owner, span("warning", "You need a Core to do that."))
			qdel(src)

/obj/item/weapon/spell/technomancer/Destroy()
	core = null
	meta = null
	if(cooldown_visual_timerid)
		deltimer(cooldown_visual_timerid)
	return ..()

/obj/item/weapon/spell/technomancer/pay_energy(var/amount)
	if(!core)
		return FALSE
	return core.pay_energy(amount)

/obj/item/weapon/spell/technomancer/give_energy(var/amount)
	if(!core)
		return FALSE
	return core.give_energy(amount)


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
