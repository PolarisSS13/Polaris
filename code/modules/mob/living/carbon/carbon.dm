/mob/living/carbon/Initialize()
	. = ..()
	if (!default_language && species_language)
		default_language = GLOB.all_languages[species_language]

/mob/living/carbon/Life()
	..()

	adjust_nutrition(DEFAULT_HUNGER_FACTOR)

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

/mob/living/carbon/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	// Walking is handled by regular life, but if you're running, you burn more calories.
	if(src.nutrition > 0 && !(src.stat) && src.m_intent == "run")
		adjust_nutrition(DEFAULT_HUNGER_FACTOR)

	// Moving around increases germ_level faster
	if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
		germ_level++

/mob/living/carbon/gib()
	for(var/mob/M in src)
		M.loc = src.loc
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(SPAN_DANGER("[M] bursts out of [src]!"), 2)
	..()

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null, var/stun = 1)
	if(def_zone == "l_hand" || def_zone == "r_hand") //Diona (And any other potential plant people) hands don't get shocked.
		if(species.flags & IS_PLANT)
			return 0
	shock_damage *= siemens_coeff
	if (shock_damage < 1)
		return 0

	src.apply_damage(0.2 * shock_damage, BURN, def_zone, used_weapon="Electrocution") //shock the target organ
	src.apply_damage(0.4 * shock_damage, BURN, BP_TORSO, used_weapon="Electrocution") //shock the torso more
	src.apply_damage(0.2 * shock_damage, BURN, null, used_weapon="Electrocution") //shock a random part!
	src.apply_damage(0.2 * shock_damage, BURN, null, used_weapon="Electrocution") //shock a random part!

	playsound(src, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			"<span class='warning'>[src] was electrocuted[source ? " by the [source]" : ""]!</span>", \
			"<span class='danger'>You feel a powerful shock course through your body!</span>", \
			"<span class='warning'>You hear a heavy electrical crack.</span>" \
		)
	else
		src.visible_message(
			"<span class='warning'>[src] was shocked[source ? " by the [source]" : ""].</span>", \
			"<span class='warning'>You feel a shock course through your body.</span>", \
			"<span class='warning'>You hear a zapping sound.</span>" \
		)

	if(stun)
		switch(shock_damage)
			if(16 to 20)
				Stun(2)
			if(21 to 25)
				Weaken(2)
			if(26 to 30)
				Weaken(5)
			if(31 to INFINITY)
				Weaken(10) //This should work for now, more is really silly and makes you lay there forever

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage


/mob/living/carbon/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(eyecheck() < intensity || override_blindness_check)
		return ..()

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(var/datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return FALSE
	if(buckled && istype(buckled, /obj/structure/bed/nest)) // buckling does not restrict hands
		return FALSE
	return TRUE

/mob/living/carbon/get_default_language()
	if(default_language && can_speak(default_language))
		return default_language

	if(!species)
		return GLOB.all_languages[LANGUAGE_GIBBERISH]

	return species.default_language ? GLOB.all_languages[species.default_language] : GLOB.all_languages[LANGUAGE_GIBBERISH]

/mob/living/carbon/can_feel_pain(var/check_organ)
	return !(species.flags & NO_PAIN) || ..()

/mob/living/carbon/needs_to_breathe()
	return !does_not_breathe || ..()

/mob/living/carbon/proc/update_handcuffed()
	if(handcuffed)
		drop_l_hand()
		drop_r_hand()
		stop_pulling()
		throw_alert("handcuffed", /obj/screen/alert/restrained/handcuffed, new_master = handcuffed)
	else
		clear_alert("handcuffed")
	update_action_buttons() //Some of our action buttons might be unusable when we're handcuffed.
	update_inv_handcuffed()
