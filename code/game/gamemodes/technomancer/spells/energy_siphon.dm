/datum/technomancer/spell/energy_siphon
	name = "Energy Siphon"
	desc = "This creates a link to a target that drains electricity, converts it to energy that the Core can use, then absorbs it. \
	Every few seconds, electricity is stolen until the link is broken by the target moving too far away, or having no more energy left. \
	Can drain from powercells, FPB microbatteries, and other Cores. The beam created by the siphoning is harmful to touch."
	enhancement_desc = "Range of siphoning is increased to seven meters, and you receive a small speed boost while the siphon beam \
	is draining something."
	spell_power_desc = "Rate of siphoning is scaled up based on spell power."
	cost = 100
	obj_path = /obj/item/weapon/spell/energy_siphon
	ability_icon_state = "tech_energysiphon"
	category = UTILITY_SPELLS

/obj/item/weapon/spell/energy_siphon
	name = "energy siphon"
	desc = "Now you are an energy vampire."
	icon_state = "energy_siphon"
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	var/atom/movable/siphoning = null // What the spell is currently draining.  Does nothing if null.
	var/list/things_to_siphon = list() //Things which are actually drained as a result of the above not being null.
	var/flow_rate = 1000 // Limits how much electricity can be drained per second.  Measured by default in god knows what.
	var/range = 4 // Measured in tiles.
	var/datum/beam/the_beam = null
	var/datum/looping_sound/generator/soundloop

/obj/item/weapon/spell/energy_siphon/Initialize()
	START_PROCESSING(SSobj, src)
	soundloop = new(list(src), FALSE)
	return ..()

/obj/item/weapon/spell/energy_siphon/Destroy()
	stop_siphoning()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(soundloop)
	QDEL_NULL(the_beam)
	return ..()

// Because Initialize() happens before the spell is put in hand.
/obj/item/weapon/spell/energy_siphon/on_spell_given(mob/living/user)
	if(check_for_scepter())
		range = 7

/obj/item/weapon/spell/energy_siphon/process()
	if(!siphoning)
		return
	if(!pay_energy(100))
		to_chat(owner, "<span class='warning'>You can't afford to maintain the siphon link!</span>")
		stop_siphoning()
		return
	if(get_dist(siphoning, get_turf(src)) > range)
		to_chat(owner, "<span class='warning'>\The [siphoning] is too far to drain from!</span>")
		stop_siphoning()
		return
	if(!(siphoning in view(owner)))
		to_chat(owner, "<span class='warning'>\The [siphoning] cannot be seen!</span>")
		stop_siphoning()
		return
	siphon(siphoning, owner)



/obj/item/weapon/spell/energy_siphon/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable) && within_range(hit_atom, range))
		var/atom/movable/AM = hit_atom
		populate_siphon_list(AM)
		if(!things_to_siphon.len)
			to_chat(user, "<span class='warning'>You cannot steal energy from \a [AM].</span>")
			return 0
		siphoning = AM
		update_icon()
		log_and_message_admins("is siphoning energy from \a [AM].")
		soundloop.start()
		soundloop.volume = 80
		the_beam = owner.Beam(AM, icon_state = "nzcrentrs_power", maxdistance = range+1, time = INFINITY, beam_type = /obj/effect/ebeam/reactive/electric/weak)
	else
		stop_siphoning()

/obj/item/weapon/spell/energy_siphon/proc/populate_siphon_list(atom/movable/target)
	things_to_siphon.Cut()
	things_to_siphon |= target // The recursive check below does not add the object being checked to its list.
	things_to_siphon |= recursive_content_check(target, things_to_siphon, recursion_limit = 3, client_check = 0, sight_check = 0, include_mobs = 1, include_objects = 1, ignore_show_messages = 1)
	for(var/atom/movable/AM in things_to_siphon)
		if(ishuman(AM)) // We can drain FBPs, so we can skip the test below.
			var/mob/living/carbon/human/H = AM
			if(H.isSynthetic())
				continue
		if(AM.drain_power(1) <= 0) // This checks if whatever's in the list can be drained from.
			things_to_siphon.Remove(AM)

/obj/item/weapon/spell/energy_siphon/proc/stop_siphoning()
	siphoning = null
	soundloop.stop()
	QDEL_NULL(the_beam)
	things_to_siphon.Cut()
	update_icon()
	owner.remove_modifiers_of_type(/datum/modifier/technomancer/siphon_speed_boost)

#define SIPHON_CELL_TO_ENERGY	0.5
#define SIPHON_FBP_TO_ENERGY	5.0
#define SIPHON_CORE_TO_ENERGY	0.5

// This is called every tick, so long as a link exists between the target and the Technomancer.
/obj/item/weapon/spell/energy_siphon/proc/siphon(atom/movable/siphoning, mob/user)
	var/list/things_to_drain = things_to_siphon // Temporary list copy of what we're gonna steal from.
	var/charge_to_give = 0 // How much energy to give to the Technomancer at the end.
	var/flow_remaining = calculate_spell_power(flow_rate)

	if(!siphoning)
		return 0

	update_icon()

	if(check_for_scepter())
		owner.add_modifier(/datum/modifier/technomancer/siphon_speed_boost)

	// First, we drain normal batteries.
	if(things_to_drain.len)
		// Don't bother with empty stuff.
		for(var/atom/movable/AM in things_to_drain)
			if(AM.drain_power(1) <= 0)
				things_to_drain.Remove(AM)
		if(!things_to_drain.len)
			return
		var/charge_to_steal = round(flow_remaining / things_to_drain.len) // This is to drain all the cells evenly.
		for(var/atom/movable/AM in things_to_drain)
			var/big_number = AM.drain_power(0,0,charge_to_steal / CELLRATE) // This drains the cell, and leaves us with a big number.
			flow_remaining = flow_remaining - (big_number * CELLRATE) // Which we reduce to our needed number by multiplying.
			AM.update_icon() // So guns and batteries will display correctly.
		charge_to_give = charge_to_give + (flow_rate - flow_remaining) * SIPHON_CELL_TO_ENERGY
	// If we have 'leftover' flow, let's try to do more.
	if(round(flow_remaining))
		if(ishuman(siphoning))
			var/mob/living/carbon/human/H = siphoning
			// Let's drain from FBPs.  Note that it is possible for the caster to drain themselves if they are an FBP and desperate.
			if(H.isSynthetic())
				var/nutrition_to_steal = flow_remaining * 0.025 // Should steal about 25 nutrition per second by default.
				var/old_nutrition = H.nutrition
				H.nutrition = max(H.nutrition - nutrition_to_steal, 0)
				var/nutrition_delta = old_nutrition - H.nutrition
				charge_to_give += nutrition_delta * SIPHON_FBP_TO_ENERGY
				flow_remaining = flow_remaining - nutrition_to_steal / 0.025
			// Let's steal some energy from another Technomancer.
			if(istype(H.back, /obj/item/weapon/technomancer_core) && H != user)
				var/obj/item/weapon/technomancer_core/their_core = H.back
				if(their_core.pay_energy(flow_remaining / 2)) // Don't give energy from nothing.
					charge_to_give += flow_remaining * SIPHON_CORE_TO_ENERGY
					flow_remaining = 0



	// Now we can actually fill up the core.
	if(core.energy < core.max_energy)
		give_energy(charge_to_give)
		to_chat(user, "<span class='notice'>Stolen [charge_to_give * CELLRATE] kJ and converted to [charge_to_give] Core energy.</span>")
		if( (core.max_energy - core.energy) < charge_to_give ) // We have some overflow, if this is true.
			if(user.isSynthetic()) // Let's do something with it, if we're a robot.
				charge_to_give = charge_to_give - (core.max_energy - core.energy)
				user.nutrition =  min(user.nutrition + (charge_to_give / SIPHON_FBP_TO_ENERGY), 400)
				to_chat(user, "<span class='notice'>Redirected energy to internal microcell.</span>")
	else
		to_chat(user, "<span class='notice'>Stolen [charge_to_give * CELLRATE] kJ.</span>")
	playsound(get_turf(siphoning), 'sound/effects/magic/technomancer/zap_hit.ogg', 75, 1)
	adjust_instability(2)

	if(flow_remaining == flow_rate) // We didn't drain anything.
		to_chat(user, "<span class='warning'>\The [siphoning] cannot be drained any further.</span>")
		stop_siphoning()

/obj/item/weapon/spell/energy_siphon/update_icon()
	..()
	if(siphoning)
		icon_state = "energy_siphon_drain"
	else
		icon_state = "energy_siphon"


/datum/modifier/technomancer/siphon_speed_boost
	name = "energized"
	desc = "Your Core is helping you move quickly while it's receiving energy."
	mob_overlay_state = "electricity_constant"

	on_created_text = "<span class='notice'>Your Core seems to be helping you move as you siphon energy.</span>"
	on_expired_text = "<span class='warning'>You feel your speed return to normal.</span>"

	slowdown = -0.5

#undef SIPHON_CELL_TO_ENERGY
#undef SIPHON_FBP_TO_ENERGY
#undef SIPHON_CORE_TO_ENERGY