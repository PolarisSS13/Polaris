/obj/effect/newrune/astral_journey
	rune_name = "Astral Journey"
	rune_desc = "Gently rips your life from your body, allowing you to observe your surroundings as a ghost. Your body wll continuously take damage while you remain in this state, so ensure your journey does not remain overlong or you may never return from it."
	rune_shorthand = "Explore your surroundings in ghost form while your body remains atop the rune."
	circle_words = list(CULT_WORD_HELL, CULT_WORD_TRAVEL, CULT_WORD_SELF)
	invocation = "Fwe'sh mah erl nyag r'ya!"
	var/mob/living/traveler
	var/mob/observer/dead/ghost

/obj/effect/newrune/astral_journey/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/newrune/astral_journey/can_invoke(mob/living/invoker)
	if (traveler)
		to_chat(invoker, SPAN_WARNING("\The [traveler] is already using this rune."))
		return
	if (get_turf(invoker) != get_turf(src))
		to_chat(invoker, SPAN_WARNING("You must stand on top of this rune to use it."))
		return
	return TRUE

/obj/effect/newrune/astral_journey/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	var/datum/gender/TU = gender_datums[L.get_visible_gender()]
	L.visible_message(
		SPAN_WARNING("\The [L]'s eyes glow blue as [TU.he] freeze[TU.s] in place, absolutely motionless."),
		SPAN_WARNING("The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry..."),
		SPAN_WARNING("For a moment, you hear nothing but complete silence.")
	)
	set_traveler(L)

/obj/effect/newrune/astral_journey/proc/set_traveler(mob/living/L, return_to_body)
	if (!L)
		if (traveler)
			traveler.ajourn = FALSE
			if (return_to_body && ghost)
				if (ghost.reenter_corpse())
					to_chat(ghost, SPAN_DANGER("You are painfully jerked back to reality as the binding sigils force you back into your body."))
				else
					to_chat(ghost, SPAN_DANGER(FONT_LARGE("You are unable to return to your body. You are doomed to wander here forever, unless it is returned to life.")))
					ghost.mind.current.key = ghost.key
					ghost.timeofdeath = world.time
					ghost.set_respawn_timer()
					announce_ghost_joinleave(ghost, TRUE, "They were trapped here after a failed astral journey.")
		traveler = null
		STOP_PROCESSING(SSprocessing, src)
	else
		traveler = L
		traveler.ajourn = TRUE
		ghost = traveler.ghostize(TRUE)
		ghost.forbid_seeing_deadchat = TRUE
		ghost.name = "???"
		ghost.color = COLOR_LIGHT_RED
		announce_ghost_joinleave(ghost, TRUE, "You feel that they had to use some [pick("dark", "black", "blood", "forgotten", "forbidden")] magic to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place!")
		START_PROCESSING(SSprocessing, src)

/obj/effect/newrune/astral_journey/process()
	if (!traveler || traveler.stat == DEAD)
		if (ghost)
			to_chat(ghost, SPAN_DANGER(FONT_LARGE("Your body has [!traveler ? "been destroyed. You are doomed to wander here forever" : "died. You are doomed to wander here forever, unless it is returned to life."]")))
			ghost.name = ghost.real_name
			ghost.forbid_seeing_deadchat = FALSE
			announce_ghost_joinleave(ghost, TRUE, "Their body [traveler ? "died" : "was destroyed"] during an astral journey.")
		set_traveler(null)
		return
	if (traveler.loc != get_turf(src) || !ghost)
		set_traveler(null, TRUE)
		return
	traveler.take_organ_damage(0.3, 0)
