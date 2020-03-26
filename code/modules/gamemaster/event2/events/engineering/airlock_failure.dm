/datum/event2/meta/airlock_failure
	event_class = "airlock failure"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL)
	chaos = 15
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/airlock_failure

/datum/event2/meta/airlock_failure/emag
	name = "airlock failure - emag"
	event_type = /datum/event2/event/airlock_failure/emag

/datum/event2/meta/airlock_failure/door_crush
	name = "airlock failure - crushing"
	event_type = /datum/event2/event/airlock_failure/door_crush

/datum/event2/meta/airlock_failure/shock
	name = "airlock failure - shock"
	chaos = 30
	event_type = /datum/event2/event/airlock_failure/shock


/datum/event2/meta/airlock_failure/get_weight()
	var/engineering = metric.count_people_in_department(DEPARTMENT_ENGINEERING)

	// Synths are good both for fixing the doors and getting blamed for the doors zapping people.
	var/synths = metric.count_people_in_department(DEPARTMENT_SYNTHETIC)
	if(!engineering && !synths) // Nobody's around to fix the door.
		return 0

	// Medical might be needed for some of the more violent airlock failures.
	var/medical = metric.count_people_in_department(DEPARTMENT_MEDICAL)

	return (engineering * 20) + (medical * 20) + (synths * 20)



/datum/event2/event/airlock_failure
	announce_delay_lower_bound = 20 SECONDS
	announce_delay_upper_bound = 40 SECONDS
	var/announce_odds = 0
	var/doors_to_break = 1
	var/list/affected_areas = list()

/datum/event2/event/airlock_failure/emag
	announce_odds = 10 // To make people wonder if the emagged door was from a baddie or from this event.
	doors_to_break = 2 // Replacing emagged doors really sucks for engineering so don't overdo it.

/datum/event2/event/airlock_failure/door_crush
	announce_odds = 30
	doors_to_break = 5

/datum/event2/event/airlock_failure/shock
	announce_odds = 70

/datum/event2/event/airlock_failure/start()
	var/list/areas = find_random_areas()
	if(!LAZYLEN(areas))
		log_debug("Airlock Failure event could not find any areas. Aborting.")
		abort()
		return

	while(areas.len)
		var/area/area = pick(areas)
		areas -= area

		for(var/obj/machinery/door/airlock/door in area.contents)
			if(can_break_door(door))
				addtimer(CALLBACK(src, .proc/break_door, door), 1) // Emagging proc is actually a blocking proc and that's bad for the ticker.
				door.visible_message(span("danger", "\The [door]'s panel sparks!"))
				playsound(door, "sparks", 50, 1)
				log_debug("Airlock Failure event has broken \the [door] airlock in [area].")
				affected_areas |= area
				doors_to_break--

			if(doors_to_break <= 0)
				return

/datum/event2/event/airlock_failure/announce()
	if(prob(announce_odds))
		command_announcement.Announce("An electrical issue has been detected in the airlock grid at [english_list(affected_areas)]. \
		Some airlocks may require servicing by a qualified technician.", "Electrical Alert")


/datum/event2/event/airlock_failure/proc/can_break_door(obj/machinery/door/airlock/door)
	if(istype(door, /obj/machinery/door/airlock/lift))
		return FALSE
	return door.arePowerSystemsOn()

// Override this for door busting.
/datum/event2/event/airlock_failure/proc/break_door(obj/machinery/door/airlock/door)

/datum/event2/event/airlock_failure/emag/break_door(obj/machinery/door/airlock/door)
	door.emag_act(1)

/datum/event2/event/airlock_failure/door_crush/break_door(obj/machinery/door/airlock/door)
	door.normalspeed = FALSE
	door.safe = FALSE

/datum/event2/event/airlock_failure/shock/break_door(obj/machinery/door/airlock/door)
	door.electrify(-1)



/*
/datum/gm_action/electrified_door
	name = "airlock short-circuit"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL)
	chaotic = 10
	var/obj/machinery/door/airlock/chosen_door
	var/area/target_area
	var/list/area/excluded = list(
		/area/submap,
		/area/shuttle,
		/area/crew_quarters
	)

/datum/gm_action/electrified_door/set_up()
	var/list/area/grand_list_of_areas = get_station_areas(excluded)

	severity = pickweight(EVENT_LEVEL_MUNDANE = 10,
		EVENT_LEVEL_MODERATE = 5,
		EVENT_LEVEL_MAJOR = 1
		)

	//try 10 times
	for(var/i in 1 to 10)
		target_area = pick(grand_list_of_areas)
		var/list/obj/machinery/door/airlock/target_doors = list()
		for(var/obj/machinery/door/airlock/target_door in target_area.contents)
			target_doors += target_door
		target_doors = shuffle(target_doors)

		for(var/obj/machinery/door/airlock/target_door in target_doors)
			if(!target_door.isElectrified() && target_door.arePowerSystemsOn() && target_door.maxhealth == target_door.health)
				chosen_door = target_door
				return

/datum/gm_action/electrified_door/start()
	..()
	if(!chosen_door)
		return
	command_announcement.Announce("An electrical issue has been detected in your area, please repair potential electronic overloads.", "Electrical Alert")
	chosen_door.visible_message("<span class='danger'>\The [chosen_door]'s panel sparks!</span>")
	chosen_door.set_safeties(0)
	playsound(get_turf(chosen_door), 'sound/machines/buzz-sigh.ogg', 50, 1)
	if(severity >= EVENT_LEVEL_MODERATE)
		chosen_door.electrify(-1)
		spawn(rand(10 SECONDS, 2 MINUTES))
			if(chosen_door && chosen_door.arePowerSystemsOn() && prob(25 + 25 * severity))
				command_announcement.Announce("Overload has been localized to \the [target_area].", "Electrical Alert")

	if(severity >= EVENT_LEVEL_MAJOR)	// New Major effect. Hydraulic boom.
		spawn()
			chosen_door.visible_message("<span class='warning'>\The [chosen_door] buzzes.</span>")
			playsound(get_turf(chosen_door), 'sound/machines/buzz-sigh.ogg', 50, 1)
			sleep(rand(10 SECONDS, 3 MINUTES))
			if(!chosen_door || !chosen_door.arePowerSystemsOn())
				return
			chosen_door.visible_message("<span class='warning'>\The [chosen_door]'s hydraulics creak.</span>")
			playsound(get_turf(chosen_door), 'sound/machines/airlock_creaking.ogg', 50, 1)
			sleep(rand(30 SECONDS, 10 MINUTES))
			if(!chosen_door || !chosen_door.arePowerSystemsOn())
				return
			chosen_door.visible_message("<span class='danger'>\The [chosen_door] emits a hydraulic shriek!</span>")
			playsound(get_turf(chosen_door), 'sound/machines/airlock.ogg', 80, 1)
			spawn(rand(5 SECONDS, 30 SECONDS))
			if(!chosen_door || !chosen_door.arePowerSystemsOn())
				return
			chosen_door.visible_message("<span class='critical'>\The [chosen_door]'s hydraulics detonate!</span>")
			chosen_door.fragmentate(get_turf(chosen_door), rand(5, 10), rand(3, 5), list(/obj/item/projectile/bullet/pellet/fragment/tank/small))
			explosion(get_turf(chosen_door),-1,-1,2,3)

	chosen_door.lock()
	chosen_door.health = chosen_door.maxhealth / 6
	chosen_door.aiControlDisabled = 1
	chosen_door.update_icon()

/datum/gm_action/electrified_door/get_weight()
	return 10 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 5 + metric.count_people_in_department(DEPARTMENT_MEDICAL) * 10)

*/