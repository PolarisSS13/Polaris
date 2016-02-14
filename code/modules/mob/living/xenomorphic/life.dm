
/mob/living/xenomorphic/Life()
	..()

	//Revival of the mob
	if(stat == DEAD)
		if(health > 0 && revivable == 1)
			icon_state = icon_living
			dead_mob_list -= src
			living_mob_list += src
			stat = CONSCIOUS
		return 0
		
	//The xeno's dead
	if(health <= 0)
		icon_state = icon_dead
		dead_mob_list += src
		living_mob_list -= src
		stat = DEAD
		if(colored)
			color = colorVar
		return
		
	if(health > maxHealth)
		health = maxHealth
		
	//Movement handling
	if(!anchored && !(pullFreeze && pulledby))
		if(isturf(src.loc) && !resting && !buckled && canmove)
			sinceLastMove++
			if(sinceLastMove >= moveTiming)
				var/move_direction
				move_direction = pick(cardinal)
				dir = move_direction
				Move(get_step(src,move_direction))
				sinceLastMove = 0
	
	handle_reagents()
			
//Copied from simple_animal.dm

	//Atmos
	var/atmos_suitable = 1

	var/atom/A = src.loc

	if(istype(A,/turf))
		var/turf/T = A

		var/datum/gas_mixture/Environment = T.return_air()

		if(Environment)

			if( abs(Environment.temperature - bodytemperature) > 40 )
				bodytemperature += ((Environment.temperature - bodytemperature) / 5)

			if(min_oxy)
				if(Environment.gas["oxygen"] < min_oxy)
					atmos_suitable = 0
			if(max_oxy)
				if(Environment.gas["oxygen"] > max_oxy)
					atmos_suitable = 0
			if(min_tox)
				if(Environment.gas["phoron"] < min_tox)
					atmos_suitable = 0
			if(max_tox)
				if(Environment.gas["phoron"] > max_tox)
					atmos_suitable = 0
			if(min_n2)
				if(Environment.gas["nitrogen"] < min_n2)
					atmos_suitable = 0
			if(max_n2)
				if(Environment.gas["nitrogen"] > max_n2)
					atmos_suitable = 0
			if(min_co2)
				if(Environment.gas["carbon_dioxide"] < min_co2)
					atmos_suitable = 0
			if(max_co2)
				if(Environment.gas["carbon_dioxide"] > max_co2)
					atmos_suitable = 0

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		adjustBruteLoss(cold_damage_per_tick)
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		adjustBruteLoss(heat_damage_per_tick)
	else
		fire_alert = 0

	if(!atmos_suitable)
		adjustBruteLoss(unsuitable_atoms_damage)
	return 1
