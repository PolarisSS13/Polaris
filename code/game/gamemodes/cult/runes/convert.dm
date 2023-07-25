/obj/effect/rune/convert
	rune_name = "Convert"
	rune_desc = "A ubiquitous incantation, necessary to educate the innocent. Exposing a nonbeliever's mind to Nar-Sie will typically convert them, but stubborn or resilient individuals may be able to resist Its influence until they succumb or are overwhelmed by the revelation. Some people - typically those possessed of high authority - are able to resist Nar-Sie's influence and will entirely refuse to abandon their old beliefs."
	rune_shorthand = "Attempts to convert a nonbeliever to the fold."
	circle_words = list(CULT_WORD_JOIN, CULT_WORD_BLOOD, CULT_WORD_SELF)
	invocation = "Mah'weyh pleggh at e'ntrath!"
	var/mob/living/converting
	var/waiting_for_input
	var/impudence = 0
	var/impudence_timer = 0

/obj/effect/rune/convert/proc/can_convert(mob/living/victim)
	return victim && !iscultist(victim) && victim.client && victim.stat != DEAD && victim.mind

/obj/effect/rune/convert/can_invoke(mob/living/invoker)
	for (var/mob/living/L in get_turf(src))
		if (can_convert(L))
			return TRUE
	return

/obj/effect/rune/convert/invoke(list/invokers)
	var/mob/living/user = invokers[1]
	if (converting)
		to_chat(user, SPAN_WARNING("You sense that the Dark One's power is already working away at [converting]."))
		return
	for (var/mob/living/L in get_turf(src))
		if (can_convert(L))
			converting = L
			break
	var/datum/gender/G = gender_datums[converting.get_visible_gender()]
	converting.visible_message(
		SPAN_DANGER("[converting] writhes as the markings below [G.him] glow a sullen, bloody red."),
		SPAN_DANGER("AAAAAAHHHH-")
	)
	converting.emote("scream")
	to_chat(converting, SPAN_OCCULT(FONT_LARGE("Agony invades every corner of your body. Your senses dim, brighten, and dim again. The air swims as if on fire. And as boiling scarlet light bathes your face, you discover that you are not alone in your head.")))
	if (!cult.can_become_antag(converting.mind)) // We check this in here instead of can_convert() so that they can be shown to visibly resist the rune's influence
		converting = null
		converting.visible_message(
			SPAN_DANGER("[converting] seems to push away the rune's influence!"),
			SPAN_DANGER(FONT_LARGE("...and you're able to force it out of your mind. You need to get away from here as fast as you can!"))
		)
		return
	else
		to_chat(user, SPAN_NOTICE("The ritual is begun. You must keep [converting] atop the rune until [G.he] succumb[G.s] to the Geometer's influence - or die[G.s] from the revelation."))
	impudence = 1
	START_PROCESSING(SSprocessing, src)
	process()

/obj/effect/rune/convert/process()
	if (!can_convert(converting) || !cult.can_become_antag(converting.mind) || get_turf(converting) != get_turf(src))
		if (converting)
			to_chat(converting, SPAN_DANGER("And then, just like that, it was gone. The blackness slowly recedes, and you are yourself again. Are you still whole?"))
		converting = null
		waiting_for_input = FALSE
		STOP_PROCESSING(SSprocessing, src)
		return
	if (impudence_timer)
		impudence_timer--
		return
	if (!waiting_for_input)
		spawn()
			waiting_for_input = TRUE
			var/choice = alert(converting, "Submit to the presence invading your head?", "Submit to Nar-Sie", "Submit!", "Resist!")
			waiting_for_input = FALSE
			if (choice == "Submit!")
				to_chat(converting, SPAN_OCCULT("Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root."))
				to_chat(converting, SPAN_OCCULT("Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back."))
				cult.add_antagonist(converting.mind)
				converting.hallucination = 0
				converting = null
				STOP_PROCESSING(SSprocessing, src)
	if (impudence)
		converting.take_overall_damage(0, min(5 * impudence, 20))
		converting.apply_effect(min(5 * impudence, 20), AGONY)
		switch (converting.getFireLoss())
			if (0 to 25)
				to_chat(converting, SPAN_DANGER("You feel like every part of you is on fire as you force yourself to resist the corruption invading every corner of your mind."))
			if (45 to 75)
				to_chat(converting, SPAN_DANGER("Flickering images of a vast, vast, dark thing engulf your vision. Everything is so, so hot."))
				converting.apply_effect(rand(1, 10), STUTTER)
			if (75 to 100)
				to_chat(converting, SPAN_DANGER("You feel like you're being cremated. Images of unspeakable horror flicker through your senses like a slideshow."))
				converting.hallucination = min(converting.hallucination + 100, 500)
				converting.apply_effect(10, STUTTER)
				converting.adjustBrainLoss(1)
			if (100 to INFINITY)
				to_chat(converting, SPAN_DANGER("Everything is on fire. You feel yourself coming apart, drawn towards inexorable nothingness."))
				converting.hallucination = min(converting.hallucination + 100, 500)
				converting.apply_effect(15, STUTTER)
				converting.adjustBrainLoss(1)
		impudence++
	impudence_timer = 10
