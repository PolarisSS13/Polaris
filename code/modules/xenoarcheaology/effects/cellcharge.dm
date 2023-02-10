/datum/artifact_effect/uncommon/cellcharge
	name = "cell charge"
	effect_type = EFFECT_ELECTRO
	effect_color = "#ffee06"
	var/last_message


/datum/artifact_effect/uncommon/cellcharge/DoEffectTouch(mob/living/user)
	if(!user)
		return
	var/atom/holder = get_master_holder()
	if (!holder)
		return
	var/turf/turf = get_turf(user)
	if (!turf)
		return

	var/messaged_robots
	for(var/mob/living/L in range(effectrange, turf))
		var/obj/item/cell/C = L.get_cell()

		if(C)
			if(istype(L, /mob/living/silicon/robot) && ((last_message + (1 MINUTE)) < world.time))
				messaged_robots = TRUE
				to_chat(L, "<font color='blue'>SYSTEM ALERT: Large energy boost detected!</font>")
			C.charge = min(C.maxcharge, C.charge + 100)

	if(messaged_robots)
		last_message = world.time

	for(var/obj/item/I in range(effectrange,turf))
		var/obj/item/cell/C = I.get_cell()

		if(C)
			C.charge = min(C.maxcharge, C.charge + 100)

/datum/artifact_effect/uncommon/cellcharge/DoEffectAura()
	var/atom/holder = get_master_holder()
	if (!holder)
		return
	var/turf/turf = get_turf(holder)
	if (!turf)
		return

	var/messaged_robots
	for(var/mob/living/L in range(effectrange, turf))
		var/obj/item/cell/C = L.get_cell()

		if(C)
			if(istype(L, /mob/living/silicon/robot) && ((last_message + (1 MINUTE)) < world.time))
				messaged_robots = TRUE
				to_chat(L, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
			C.charge = min(C.maxcharge, C.charge + 25)

	if(messaged_robots)
		last_message = world.time

	for(var/obj/item/I in range(effectrange,turf))
		var/obj/item/cell/C = I.get_cell()

		if(C)
			C.charge = min(C.maxcharge, C.charge + 25)

/datum/artifact_effect/uncommon/cellcharge/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (!holder)
		return
	var/turf/turf = get_turf(holder)
	if (!turf)
		return

	var/messaged_robots
	for(var/mob/living/L in range(effectrange, turf))
		var/obj/item/cell/C = L.get_cell()

		if(C)
			if(istype(L, /mob/living/silicon/robot) && ((last_message + (1 MINUTE)) < world.time))
				messaged_robots = TRUE
				to_chat(L, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
			C.charge = min(C.maxcharge, C.charge + 25)

	if(messaged_robots)
		last_message = world.time

	for(var/obj/item/I in range(effectrange,turf))
		var/obj/item/cell/C = I.get_cell()

		if(C)
			C.charge = min(C.maxcharge, C.charge + 25)
