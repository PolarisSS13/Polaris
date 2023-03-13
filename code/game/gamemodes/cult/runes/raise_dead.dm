/obj/effect/rune/raise_dead
	rune_name = "Raise Dead"
	rune_desc = "This rune allows for the resurrection of any dead person. You will need a dead human body and a living human sacrifice. Make 2 raise dead runes. Put a living, awake human on top of one, and a dead body on the other one. When you invoke the rune, the life force of the living human will be transferred into the dead body, allowing a ghost standing on top of the dead body to enter it, instantly and fully healing it. Use other runes to ensure there is a ghost ready to be resurrected."
	rune_shorthand = "Brings a dead body to life using the sacrifice of a living human on another copy of the rune. If the dead body is not a cultist, they will become one."
	circle_words = list(CULT_WORD_BLOOD, CULT_WORD_JOIN, CULT_WORD_SELF)
	invocation = "Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!"

/obj/effect/rune/raise_dead/proc/get_targets()
	var/to_raise = null
	var/to_sacrifice = null
	for (var/mob/living/carbon/human/H in get_turf(src))
		if (H.stat == DEAD)
			to_raise = H
			break
	for (var/obj/effect/rune/raise_dead/R in orange(1, src))
		for (var/mob/living/carbon/human/H in get_turf(R))
			if (H.stat != DEAD)
				to_sacrifice = H
				break
	return list(to_raise, to_sacrifice)

/obj/effect/rune/raise_dead/can_invoke(mob/living/invoker)
	var/list/targets = get_targets()
	if (!targets[1])
		return
	else if (!targets[2])
		to_chat(invoker, SPAN_WARNING("You must position a living human sacrifice on an adjacent copy of the rune."))
		return
	var/mob/living/L = targets[1]
	if (!L.mind)
		to_chat(invoker, SPAN_WARNING("This body is mindless and cannot hold life."))
		return
	else if (cult.sacrifice_target == L.mind)
		to_chat(invoker, SPAN_WARNING("This body cannot be raised, for the Geometer requires it as sacrifice."))
		return
	else if (!cult.can_become_antag(L.mind))
		to_chat(invoker, SPAN_WARNING("The Geometer refuses to touch this body."))
		return
	return TRUE

/obj/effect/rune/raise_dead/invoke(list/invokers)
	var/list/targets = get_targets()
	var/mob/living/L = invokers[1]
	var/mob/living/carbon/human/shears = targets[1]
	var/mob/living/carbon/human/lamb = targets[2]
	to_chat(L, SPAN_NOTICE("The ritual is begun. Both bodies must remain in place..."))
	shears.visible_message(SPAN_WARNING("\The [shears] is yanked upwards by invisible strings, dangling in the air like a puppet."))
	lamb.visible_message(
		SPAN_WARNING("\The [lamb] is yanked upwards by invisible strings, dangling in the air like a puppet."),
		SPAN_DANGER("An invisible force yanks you in the air and holds you there!")
	)
	var/mob/observer/dead/ghost = shears.get_ghost()
	if (ghost)
		ghost.notify_revive("The cultist [L.real_name] is attempting to raise you from the dead. Return to your body if you wish to be risen into the service of Nar-Sie!", 'sound/effects/genetics.ogg', source = src)
	if (do_after(shears, 5 SECONDS, lamb, FALSE, incapacitation_flags = INCAPACITATION_NONE))
		resurrect(shears, lamb)
		return
	to_chat(L, SPAN_NOTICE("The ritual's participants must remain stationary!"))
	if (shears)
		shears.visible_message(SPAN_WARNING("\The [shears] drops unceremoniously to the ground."))
		playsound(shears, "bodyfall", 50, TRUE)
		if (lamb)
			lamb.visible_message(
				SPAN_WARNING("\The [lamb] drops unceremoniously to the ground."),
				SPAN_DANGER("The force releases its hold on you, and you fall back to the ground!")
			)
		playsound(lamb, "bodyfall", 50, TRUE)

/obj/effect/rune/raise_dead/proc/resurrect(mob/living/carbon/human/shears, mob/living/carbon/human/lamb, mob/living/invoker)
	var/list/targets = get_targets()
	if (targets[1] != shears || targets[2] != lamb)
		to_chat(invoker, SPAN_WARNING("The ritual's subjects were moved before it could complete."))
		return
	if (!shears.client || !shears.mind)
		shears.visible_message(SPAN_WARNING("\The [shears] drops unceremoniously to the ground."))
		lamb.visible_message(
			SPAN_WARNING("\The [lamb] drops unceremoniously to the ground."),
			SPAN_DANGER("THe force releases its hold on you, and you fall back to the ground!")
		)
		playsound(shears, "bodyfall", 50, TRUE)
		playsound(lamb, "bodyfall", 50, TRUE)
		to_chat(invoker, SPAN_WARNING("The deceased's spirit did not return to its body. It may if you try again, or it may not."))
		return
	var/datum/gender/GS = gender_datums[shears.get_visible_gender()]
	lamb.visible_message(
		SPAN_DANGER(FONT_LARGE("[lamb]'s body is violently wrenched apart into bloody pieces!")),
		SPAN_DANGER(FONT_LARGE("A vast, dark thing reaches inside you and plucks out something precious. Your body ripped into bloody pieces like wet paper."))
	)
	playsound(lamb, 'sound/effects/splat.ogg', 80, TRUE)
	for (var/obj/item/organ/external/E in lamb.organs)
		E.droplimb(FALSE, DROPLIMB_EDGE)
	shears.revive()
	shears.visible_message(
		SPAN_DANGER("\The [shears] convulses violently as [GS.he] suddenly comes back to life!"),
		SPAN_DANGER("Life... you're alive again...")
	)
	if (!iscultist(shears))
		cult.add_antagonist(shears.mind)
		to_chat(shears, SPAN_OCCULT("Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root."))
		to_chat(shears, SPAN_OCCULT("Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back."))
	shears.flash_eyes(override_blindness_check = TRUE)
	shears.Paralyse(10)
