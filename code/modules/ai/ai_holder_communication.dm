/datum/ai_holder
	var/threaten = FALSE				// If hostile and sees a valid target, gives a 'warning' to the target before beginning the attack.
	var/threatened = FALSE				// If the mob actually gave the warning, checked so it doesn't constantly yell every tick.
	var/threaten_delay = 3 SECONDS		// How long a 'threat' lasts, until actual fighting starts. If null, the mob never starts the fight but still does the threat.
	var/threaten_timeout = 1 MINUTE		// If the mob threatens someone, they leave, and then come back before this timeout period, the mob escalates to fighting immediately.
	var/last_conflict_time = null		// Last occurance of threatening or fighting being used, in world.time.

	var/threaten_sound = null			// Sound file played when the mob calls threaten_target() for the first time.
	var/stand_down_sound = null			// Sound file played when the mob loses sight of the threatened target.


/datum/ai_holder/proc/should_threaten()
	if(!threaten)
		return FALSE // We don't negotiate.
	if(!will_threaten(target))
		return FALSE // Pointless to threaten an animal, a mindless drone, or an object.
	if(!(stance in list(STANCE_IDLE, STANCE_MOVE, STANCE_FOLLOW)))
		return FALSE // We're probably already fighting or recently fought if not in these stances.
	if(last_conflict_time && threaten_delay && last_conflict_time + threaten_timeout > world.time)
		return FALSE // We threatened someone recently, so lets show them we mean business.
	return TRUE // Lets give them a chance to choose wisely and walk away.

/datum/ai_holder/proc/threaten_target()
	holder.face_atom(target) // Constantly face the target.

	if(!threatened) // First tick.
		threatened = TRUE
		last_conflict_time = world.time
		//TODO: Actual speech.
		holder.say("Oi, fuck off mate.")
		playsound(holder.loc, threaten_sound, 75, 1) // We do this twice to make the sound -very- noticable to the target.
		playsound(target.loc, threaten_sound, 75, 1) // Actual aim-mode also does that so at least it's consistant.
	else // Otherwise we are waiting for them to go away or to wait long enough for escalate.
		if(target in list_targets()) // Are they still visible?

			if(threaten_delay && last_conflict_time + threaten_delay < world.time) // Waited too long.
				threatened = FALSE
				set_stance(STANCE_ATTACK)
				holder.say("Fine, now you die!") //WIP
			else
				return // Wait a bit.

		else // They left, or so we think.
			threatened = FALSE
			set_stance(STANCE_IDLE)
			holder.say("Good riddence.") //WIP
			playsound(holder.loc, stand_down_sound, 50, 1) // We do this twice to make the sound -very- noticable to the target.
			playsound(target.loc, stand_down_sound, 50, 1) // Actual aim-mode also does that so at least it's consistant.

// Determines what is deserving of a warning when STANCE_ALERT is active.
/datum/ai_holder/proc/will_threaten(mob/living/the_target)
	if(!isliving(the_target))
		return FALSE // Turrets don't give a fuck so neither will we.
	if(istype(the_target, /mob/living/simple_animal) && istype(holder, /mob/living/simple_animal))
		var/mob/living/simple_animal/us = holder
		var/mob/living/simple_animal/them = target
		if(them.intelligence_level < us.intelligence_level) // Todo: Bitflag these.
			return FALSE // Humanoids don't care about drones/animals/etc. Drones don't care about animals, and so on.
	return TRUE