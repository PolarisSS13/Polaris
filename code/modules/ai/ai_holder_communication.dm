// Contains code for speaking and emoting.

/datum/ai_holder
	var/threaten = FALSE				// If hostile and sees a valid target, gives a 'warning' to the target before beginning the attack.
	var/threatening = FALSE				// If the mob actually gave the warning, checked so it doesn't constantly yell every tick.
	var/threaten_delay = 3 SECONDS		// How long a 'threat' lasts, until actual fighting starts. If null, the mob never starts the fight but still does the threat.
	var/threaten_timeout = 1 MINUTE		// If the mob threatens someone, they leave, and then come back before this timeout period, the mob escalates to fighting immediately.
	var/last_conflict_time = null		// Last occurance of threatening or fighting being used, in world.time.

	var/threaten_sound = null			// Sound file played when the mob calls threaten_target() for the first time.
	var/stand_down_sound = null			// Sound file played when the mob loses sight of the threatened target.

	var/speak_chance = 0				// Probability that the mob talks (this is 'X in 200' chance since even 1/100 is pretty noisy)
	var/reacts = 0						// Reacts to some things being said.
	var/datum/say_list/say_list = null	// Datum containing all of our lines.
	var/say_list_type = /datum/say_list	// Type to give us on initialization. Default has empty lists, so the mob will be silent.

/datum/ai_holder/New()
	..()
	say_list = new say_list_type()

/datum/ai_holder/proc/should_threaten()
	if(!threaten)
		return FALSE // We don't negotiate.
	if(!will_threaten(target))
		return FALSE // Pointless to threaten an animal, a mindless drone, or an object.
	if(stance in STANCES_COMBAT)
		return FALSE // We're probably already fighting or recently fought if not in these stances.
	if(last_conflict_time && threaten_delay && last_conflict_time + threaten_timeout > world.time)
		return FALSE // We threatened someone recently, so lets show them we mean business.
	return TRUE // Lets give them a chance to choose wisely and walk away.

/datum/ai_holder/proc/threaten_target()
	holder.face_atom(target) // Constantly face the target.

	if(!threatening) // First tick.
		threatening = TRUE
		last_conflict_time = world.time

		holder.say(safepick(say_list.say_threaten))
		playsound(holder.loc, threaten_sound, 75, 1) // We do this twice to make the sound -very- noticable to the target.
		playsound(target.loc, threaten_sound, 75, 1) // Actual aim-mode also does that so at least it's consistant.
	else // Otherwise we are waiting for them to go away or to wait long enough for escalate.
		if(target in list_targets()) // Are they still visible?

			if(threaten_delay && last_conflict_time + threaten_delay < world.time) // Waited too long.
				threatening = FALSE
				set_stance(STANCE_APPROACH)
				holder.say(safepick(say_list.say_escalate))
			else
				return // Wait a bit.

		else // They left, or so we think.
			threatening = FALSE
			set_stance(STANCE_IDLE)
			holder.say(safepick(say_list.say_stand_down))
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

// Temp defines to make the below code a bit more readable.
#define COMM_SAY				"say"
#define COMM_AUDIBLE_EMOTE		"audible emote"
#define COMM_VISUAL_EMOTE		"visual emote"

/datum/ai_holder/proc/handle_idle_speaking()
	if(rand(0,200) < speak_chance)
		var/list/comm_types = list() // What kinds of things can we do?

		if(say_list.speak.len)
			comm_types += COMM_SAY
		if(say_list.emote_hear.len)
			comm_types += COMM_AUDIBLE_EMOTE
		if(say_list.emote_see.len)
			comm_types += COMM_VISUAL_EMOTE

		if(!comm_types.len)
			return // All the relevant lists are empty, so do nothing.

		switch(pick(comm_types))
			if(COMM_SAY)
				holder.say(safepick(say_list.speak))
			if(COMM_AUDIBLE_EMOTE)
				holder.audible_emote(safepick(say_list.emote_hear))
			if(COMM_VISUAL_EMOTE)
				holder.visible_emote(safepick(say_list.emote_see))

#undef COMM_SAY
#undef COMM_AUDIBLE_EMOTE
#undef COMM_VISUAL_EMOTE
