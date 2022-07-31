//todo
/datum/artifact_effect/uncommon/cellcharge
	name = "cell charge"
	effect_type = EFFECT_ELECTRO
	var/last_message

	effect_color = "#ffee06"

/datum/artifact_effect/uncommon/cellcharge/DoEffectTouch(var/mob/user)
	if(user)
		if(istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/cell/D in R.contents)
				D.charge += rand() * 100 + 50
				to_chat(R, "<font color='blue'>SYSTEM ALERT: Large energy boost detected!</font>")
			return 1

/datum/artifact_effect/uncommon/cellcharge/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in GLOB.apcs)
			if(get_dist(holder, C) <= 200)
				for (var/obj/item/cell/B in C.contents)
					B.charge += 25
		for (var/obj/machinery/power/smes/S in GLOB.smeses)
			if(get_dist(holder, S) <= src.effectrange)
				S.charge += 25
		for (var/mob/living/silicon/robot/M in global.silicon_mob_list)
			if(get_dist(holder, M) < 50)
				for (var/obj/item/cell/D in M.contents)
					D.charge += 25
					if(world.time - last_message > 200)
						to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
						last_message = world.time
		return 1

/datum/artifact_effect/uncommon/cellcharge/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(200, T))
			for (var/obj/item/cell/B in C.contents)
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 250
		for (var/mob/living/silicon/robot/M in range(100, T))
			for (var/obj/item/cell/D in M.contents)
				D.charge += rand() * 100
				if(world.time - last_message > 200)
					to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
					last_message = world.time
		return 1
