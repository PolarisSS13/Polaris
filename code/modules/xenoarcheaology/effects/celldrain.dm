/datum/artifact_effect/uncommon/celldrain
	name = "cell drain"
	effect_type = EFFECT_ELECTRO
	effect_state = "pulsing"
	effect_color = "#fbff02"
	var/last_message


/datum/artifact_effect/uncommon/celldrain/DoEffectTouch(mob/living/user)
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
				to_chat(L, "<font color='blue'>SYSTEM ALERT: Large energy drain detected!</font>")
			C.charge = max(C.maxcharge, C.charge - 100)

	if(messaged_robots)
		last_message = world.time

	for(var/obj/item/I in range(effectrange,turf))
		var/obj/item/cell/C = I.get_cell()

		if(C)
			C.charge = max(C.maxcharge, C.charge - 100)

/datum/artifact_effect/uncommon/celldrain/DoEffectAura()
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
				to_chat(L, "<font color='blue'>SYSTEM ALERT: Energy drain detected!</font>")
			C.charge = max(C.maxcharge, C.charge - 25)

	if(messaged_robots)
		last_message = world.time

	for(var/obj/item/I in range(effectrange,turf))
		var/obj/item/cell/C = I.get_cell()

		if(C)
			C.charge = max(C.maxcharge, C.charge - 25)

/datum/artifact_effect/uncommon/celldrain/DoEffectPulse()
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
				to_chat(L, "<font color='blue'>SYSTEM ALERT: Energy drain detected!</font>")
			C.charge = max(C.maxcharge, C.charge - 25)

	if(messaged_robots)
		last_message = world.time

	for(var/obj/item/I in range(effectrange,turf))
		var/obj/item/cell/C = I.get_cell()

		if(C)
			C.charge = max(C.maxcharge, C.charge - 25)
