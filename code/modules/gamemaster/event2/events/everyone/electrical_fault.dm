// Makes a spooky electrical thing happen, that can blow the lights or make the APCs turn off for a short period of time.
// Doesn't do any permanent damage beyond the small chance to emag an APC, which just unlocks it forever. As such, this is free to occur even with no engineers.

/datum/event2/meta/electrical_fault
	name = "electrical fault"
	departments = list(DEPARTMENT_EVERYONE)
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	event_type = /datum/event2/event/electrical_fault

/datum/event2/meta/electrical_fault/get_weight()
	return 10 + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5)


/datum/event2/event/electrical_fault
	start_delay_lower_bound = 30 SECONDS
	start_delay_upper_bound = 1 MINUTE
	length_lower_bound = 20 SECONDS
	length_upper_bound = 40 SECONDS
	var/max_apcs_per_tick = 2

	var/list/valid_apcs = null
	var/list/valid_z_levels = null

/datum/event2/event/electrical_fault/announce()
	// Trying to be vague to avoid 'space lightning storms'.
	// This could be re-flavored to be a solar flare or something and have robots outside be sad.
	command_announce.Announce("External conditions near \the [location_name()] are likely \
	to cause voltage spikes and other electrical issues very soon. Please secure sensitive electrical equipment until conditions improve.", "[location_name()] Sensor Array")

/datum/event2/event/electrical_fault/set_up()
	valid_z_levels = get_location_z_levels()
	valid_z_levels -= using_map.sealed_levels // Space levels only please!

	valid_apcs = list()
	for(var/obj/machinery/power/apc/A in global.machines)
		if(A.z in valid_z_levels)
			valid_apcs += A

/datum/event2/event/electrical_fault/event_tick()
	if(!valid_apcs.len)
		log_debug("No valid APCs found for electrical fault event.")
		return

	var/list/picked_apcs = list()
	for(var/i = 1 to max_apcs_per_tick)
		picked_apcs |= pick(valid_apcs)

	for(var/A in picked_apcs)
		affect_apc(A)

/datum/event2/event/electrical_fault/end()
	command_announce.Announce("External conditions have returned to normal around \the [location_name()].")

/datum/event2/event/electrical_fault/proc/affect_apc(obj/machinery/power/apc/A)
	// Main breaker is turned off or is Special(tm). Consider it protected.
	if((!A.operating || failure_timer > 0) || A.is_critical)
		return

	playsound(

	// Decent chance to overload lighting circuit.
	if(prob(6))
		A.overload_lighting()

	// Small chance to make the APC turn off for awhile.
	// This will actually protect it from further damage.
	if(prob(3))
		A.energy_fail(rand(20, 40))

	// Relatively small chance to emag the apc as apc_damage event does.
	if(prob(1))
		A.emagged = TRUE
		A.update_icon()

/*
/datum/event/electrical_storm/start()
	..()
	valid_apcs = list()
	for(var/obj/machinery/power/apc/A in global.machines)
		if(A.z in affecting_z)
			valid_apcs.Add(A)
	endWhen = (severity * 60) + startWhen

/datum/event/electrical_storm/tick()
	..()
	// See if shields can stop it first (It would be nice to port baystation's cooler shield gens perhaps)
	// TODO - We need a better shield generator system to handle this properly.
	if(!valid_apcs.len)
		log_debug("No valid APCs found for electrical storm event ship=[victim]!")
		return
	var/list/picked_apcs = list()
	for(var/i=0, i< severity * 2, i++) // up to 2/4/6 APCs per tick depending on severity
		picked_apcs |= pick(valid_apcs)
	for(var/obj/machinery/power/apc/T in picked_apcs)
		affect_apc(T)

/datum/event/electrical_storm/proc/affect_apc(var/obj/machinery/power/apc/T)
	// Main breaker is turned off. Consider this APC protected.
	if(!T.operating)
		return

	// Decent chance to overload lighting circuit.
	if(prob(3 * severity))
		T.overload_lighting()

	// Relatively small chance to emag the apc as apc_damage event does.
	if(prob(0.2 * severity))
		T.emagged = 1
		T.update_icon()
*/
