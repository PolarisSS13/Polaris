// 'Summon Slots' act as a limitation on Technomancers, allowing only a specific number of entities to be summoned at once,
// with some entities costing more 'slots' than others.
// They are designed to be self cleaning, and will react to the summoned mob being killed or deleted.

/datum/technomancer_summon_slot
	var/mob/living/summoned = null // Instance of the thing summoned.
	var/obj/item/weapon/technomancer_core/core = null // Instance of the core that is holding this datum.
	var/cost = 1 // How many slots this thing takes up.

/datum/technomancer_summon_slot/New(mob/living/new_summoned_mob, obj/item/weapon/technomancer_core/new_core, new_cost)
	summoned = new_summoned_mob
	core = new_core
	cost = new_cost

	GLOB.destroyed_event.register(summoned, src, /datum/technomancer_summon_slot/proc/on_summoned_mob_deleted)
	GLOB.stat_set_event.register(summoned, src, /datum/technomancer_summon_slot/proc/on_summoned_mob_stat_changed)

/datum/technomancer_summon_slot/Destroy()
	summoned = null
	core.summon_slots -= src

	// Just in case.
	GLOB.destroyed_event.unregister(summoned, src, /datum/technomancer_summon_slot/proc/on_summoned_mob_deleted)
	GLOB.stat_set_event.unregister(summoned, src, /datum/technomancer_summon_slot/proc/on_summoned_mob_stat_changed)

	return ..()

// Called when the summon mob has its stat var changed.
/datum/technomancer_summon_slot/proc/on_summoned_mob_stat_changed(mob/living/L, old_stat, new_stat)
	if(new_stat == DEAD) // Don't do this if they only went UNCONSCIOUS.
		summon_died(FALSE)

// Called when the summoned mob is being deleted.
/datum/technomancer_summon_slot/proc/on_summoned_mob_deleted(mob/living/L)
	summon_died(TRUE)

// Called when the summoned mob is dead or got deleted.
/datum/technomancer_summon_slot/proc/summon_died(summon_deleted = FALSE)
	GLOB.destroyed_event.unregister(summoned, src, /datum/technomancer_summon_slot/proc/on_summoned_mob_deleted)
	GLOB.stat_set_event.unregister(summoned, src, /datum/technomancer_summon_slot/proc/on_summoned_mob_stat_changed)

	// If the mob wasn't deleted, some special effects can be done.
	if(!summon_deleted)
		summoned.visible_message(span("notice", "\The [summoned] begins to fade away..."))
		animate(summoned, alpha = 0, time = 3 SECONDS) // Makes them fade into nothingness.
		QDEL_IN(summoned, 3 SECONDS)
	qdel(src)


/obj/item/weapon/technomancer_core
	var/list/summon_slots = list()
	var/max_summon_slots = 10 // Each summon takes up one or more 'slots'. Some cores will have different caps.
	var/energy_cost_per_slot = 3 // How much energy to take away every tick, per slot. Multiply max slots by this to determine the max potential cost per tick.

/obj/item/weapon/technomancer_core/Destroy()
	for(var/thing in summon_slots)
		var/datum/technomancer_summon_slot/slot = thing
		qdel(slot.summoned)
		qdel(slot)
	return ..()

// Use this to add summon slots.
/obj/item/weapon/technomancer_core/proc/add_summon_slot(mob/living/L, cost)
	if(!can_afford_summon_slot(cost))
		return FALSE
	summon_slots += new /datum/technomancer_summon_slot(L, src, cost)
	return TRUE

/obj/item/weapon/technomancer_core/proc/get_used_summon_slots()
	. = 0
	for(var/thing in summon_slots)
		var/datum/technomancer_summon_slot/slot = thing
		. += slot.cost

/obj/item/weapon/technomancer_core/proc/can_afford_summon_slot(amount)
	return get_used_summon_slots() + amount <= max_summon_slots
