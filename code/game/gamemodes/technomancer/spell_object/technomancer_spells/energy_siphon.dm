/datum/technomancer_catalog/spell/energy_siphon
	name = "Energy Siphon"
	desc = "Creates a link between two points, the caster and the target. By default, the target will have its energy drained, \
	and transferred to the caster over time. Using the function in-hand will allow you to toggle reversing the flow of energy. \
	Can drain from powercells, FPB microbatteries, and other Cores."
	cost = 100
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/energy_siphon)

/datum/spell_metadata/energy_siphon
	name = "Energy Siphon"
	icon_state = "tech_energy_siphon"
	spell_path = /obj/item/weapon/spell/technomancer/energy_siphon
	cooldown = 1 SECOND
	var/give_energy = FALSE // If TRUE, the spell gives energy to the target instead of taking it.

/obj/item/weapon/spell/technomancer/energy_siphon
	name = "energy siphon"
	desc = "Now you are an energy vampire."
	icon_state = "energy_siphon"
	cast_methods = CAST_RANGED | CAST_USE
	aspect = ASPECT_SHOCK
	var/atom/movable/source = null // The thing being drained.
	var/atom/movable/destination = null // The thing getting the energy from the above var.
	var/flow_rate = 500 // Limits how much electricity can be drained per second.  Measured in technomancer core energy.
	var/beam_cost = 50 // How much energy is lost per tick.
	var/instability_per_tick = 1 // How much instability to give every tick.
	var/range = 7 // Measured in tiles.
	var/datum/beam/the_beam = null
	var/datum/looping_sound/generator/soundloop

/obj/item/weapon/spell/technomancer/energy_siphon/Initialize()
	soundloop = new(list(src), FALSE)
	return ..()

/obj/item/weapon/spell/technomancer/energy_siphon/Destroy()
	stop_siphoning()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(soundloop)
	QDEL_NULL(the_beam)
	return ..()

/obj/item/weapon/spell/technomancer/energy_siphon/on_use_cast(mob/user)
	stop_siphoning()

	var/datum/spell_metadata/energy_siphon/meta = get_meta()
	meta.give_energy = !meta.give_energy

	to_chat(user, span("notice", "You configure the function so that it will now <b>[meta.give_energy ? "give to" : "take from"]</b> its target."))
	playsound(owner, 'sound/effects/magic/technomancer/charge.ogg', 75, 1)
	return TRUE

/obj/item/weapon/spell/technomancer/energy_siphon/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable) && within_range(hit_atom, range))
		var/atom/movable/AM = hit_atom
		if(AM == owner)
			to_chat(span("warning", "Using this on yourself would be kind of pointless."))
			return FALSE

		var/datum/spell_metadata/energy_siphon/meta = get_meta()

		if(meta.give_energy)
			start_siphoning(owner, AM)
		else
			start_siphoning(AM, owner)
		playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
		return TRUE

	else if(source)
		stop_siphoning()
		return TRUE
	return FALSE

/obj/item/weapon/spell/technomancer/energy_siphon/proc/stop_siphoning()
	source = null
	destination = null
	soundloop.stop()
	QDEL_NULL(the_beam)
	update_icon()

/obj/item/weapon/spell/technomancer/energy_siphon/proc/start_siphoning(atom/movable/new_source, atom/movable/new_destination)
	stop_siphoning()
	if(!check_siphon(new_source, new_destination))
		return FALSE
	source = new_source
	destination = new_destination
	START_PROCESSING(SSobj, src)

	log_and_message_admins("is siphoning energy from \the [source] and into \the [destination].")

	soundloop.start()
	soundloop.volume = 50
	the_beam = source.Beam(destination, icon_state = "medbeam", maxdistance = range+1, time = INFINITY, beam_type = /obj/effect/ebeam/reactive/electric/weak)

	return TRUE

/obj/item/weapon/spell/technomancer/energy_siphon/proc/check_siphon(atom/movable/the_source, atom/movable/the_destination)
	if(!the_source || !the_destination)
		return FALSE
	if(get_dist(get_turf(the_source), get_turf(the_destination)) > range)
		to_chat(owner, span("warning", "\The [the_source] and \the [the_destination] are too far apart transfer energy!"))
		stop_siphoning()
		return FALSE
	if(!(the_source in view(owner)) || !(the_destination in view(owner)))
		to_chat(owner, span("warning", "The link breaks due to a lack of vision!"))
		stop_siphoning()
		return FALSE
	return TRUE

/obj/item/weapon/spell/technomancer/energy_siphon/proc/siphon(atom/movable/the_source, atom/movable/the_destination)
	var/amount_drained = transfer_energy(the_source, -flow_rate)

	var/amount_given = transfer_energy(the_destination, amount_drained)

	var/surplus = between(0, amount_drained - amount_given, amount_drained)

	if(surplus > 0)
		transfer_energy(the_source, surplus)

	var/text = "You've drained <b>[amount_drained]</b> Core Energy from \the [the_source], \
	and transferred <b>[amount_given]</b> of it to \the [the_destination]\
	[surplus > 0 ? ", leaving a surplus of <b>[surplus]</b>" : ""]."
	to_chat(owner, span("notice", text))

	if(amount_given > 0 && surplus <= 0)
		playsound(the_source, 'sound/effects/magic/technomancer/zap_hit.ogg', 25, 1)
		playsound(the_destination, 'sound/effects/magic/technomancer/zap_hit.ogg', 25, 1)
		adjust_instability(instability_per_tick)
	else
		stop_siphoning()

// Moves various types of energy in and out of things.
// Positive amounts give energy, while negatives drain.
/obj/item/weapon/spell/technomancer/energy_siphon/proc/transfer_energy(atom/movable/target, amount)
	var/flow_remaining = abs(amount)
	var/sign = SIGN(amount)
	if(isobj(target))
		. = transfer_battery_energy(target, flow_remaining * sign)
		flow_remaining -= .

	// Energy is removed (or added) in a specific priority. Cores first, then cells inside them (like borgs), and finally FBP hunger.
	else if(isliving(target))
		// Cores.
		var/core_taken = transfer_core_energy(target, flow_remaining * sign)
		. += core_taken
		flow_remaining -= core_taken

		if(flow_remaining <= 0)
			return

		var/battery_taken = transfer_battery_energy(target, flow_remaining * sign)
		. += battery_taken
		flow_remaining -= battery_taken

		if(flow_remaining <= 0)
			return

		var/mob/living/L = target
		if(L.isSynthetic())
			var/FBP_taken = transfer_FBP_energy(L, flow_remaining * sign)
			. += FBP_taken

/obj/item/weapon/spell/technomancer/energy_siphon/proc/transfer_core_energy(mob/living/L, amount)
	var/obj/item/weapon/technomancer_core/their_core = L.get_technomancer_core()
	if(!istype(their_core))
		return 0
	if(amount < 0)
		return their_core.drain_energy(-amount)
	return their_core.give_energy(amount)

/obj/item/weapon/spell/technomancer/energy_siphon/proc/transfer_battery_energy(atom/movable/AM, amount)
	var/obj/item/weapon/cell/cell = null
	if(isobj(AM))
		var/obj/O = AM
		cell = O.get_cell()

	if(cell) // If possible, act on the cell directly.
		AM = cell

	if(!cell && AM.drain_power(1) <= 0)
		return 0

	if(amount < 0) // Draining.
		if(cell)
			return cell.use(-amount)
		return (AM.drain_power(FALSE, FALSE, -amount / CELLRATE) * CELLRATE)

	// Giving.
	if(!cell) // There's no giving equivalent for `drain_power()`, so this only works on things with batteries.
		return 0
	return (cell.give(amount))

/obj/item/weapon/spell/technomancer/energy_siphon/proc/transfer_FBP_energy(mob/living/L, amount)
	var/energy_to_nutrition = 0.05
	var/converted_amount = amount * energy_to_nutrition // Will steal 25 nutrition every tick at 500 amount.
	if(amount < 0) // Draining.
		converted_amount = -converted_amount
		. = min(L.nutrition, converted_amount) / energy_to_nutrition
		L.nutrition = max(L.nutrition - converted_amount, 0)
	else
		var/max_nutrition = 500
		. = min(max_nutrition - L.nutrition, converted_amount) / energy_to_nutrition
		L.nutrition = min(L.nutrition + converted_amount, max_nutrition)

/obj/item/weapon/spell/technomancer/energy_siphon/process()
	if(!check_siphon(source, destination))
		return PROCESS_KILL
	if(!pay_energy(beam_cost))
		to_chat(owner, span("warning", "You can't afford to maintain the siphon link!"))
		stop_siphoning()
		return PROCESS_KILL
	siphon(source, destination)

/obj/item/weapon/spell/technomancer/energy_siphon/update_icon()
	..()
	if(get_cooldown() <= 0)
		if(source)
			icon_state = "energy_siphon_drain"
		else
			icon_state = "energy_siphon"
