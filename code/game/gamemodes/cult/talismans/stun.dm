/obj/item/paper/newtalisman/stun
	talisman_name = "Stun"
	talisman_desc = "Forces the concentrated energy of a stun rune into a struck target, immediately knocking them to the ground. Humans will be prevented from speaking for a time."
	invocation = "Dream sign 'Evil Sealing Talisman'!" // I think this is a touhou reference

/obj/item/paper/newtalisman/stun/attack_self(mob/living/user)
	if (iscultist(user))
		to_chat(user, SPAN_NOTICE("To use this talisman, attack someone with it."))
	return

/obj/item/paper/newtalisman/stun/attack(mob/living/carbon/T, mob/living/user)
	if (iscultist(user) && user.a_intent == I_HURT)
		if (invocation)
			!whispered ? user.say(invocation) : user.whisper(invocation)
		add_attack_logs(user, T, "stun talisman")
		stun(user, T)
		qdel(src)
		return
	return ..()

/obj/item/paper/newtalisman/stun/proc/stun(mob/living/user, mob/living/target)
	user.visible_message(
		SPAN_DANGER("\The [user] thrusts \the [src] into \the [target]'s face!"),
		SPAN_DANGER("You invoke the talisman at [target]!")
	)
	if (findNullRod(target))
		target.visible_message(
			SPAN_DANGER("\The [target] is unaffected!"),
			SPAN_DANGER("You feel a hot flash for a moment, but nothing else happens!")
		)
		return
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.visible_message(
			SPAN_DANGER("\The [H] crumples to the ground!"),
			SPAN_DANGER("An immense force overwhelms your senses as you fall to the ground!")
		)
		H.flash_eyes()
		H.Weaken(25)
		H.Stun(25)
		H.silent = max(15, H.silent)
	else
		target.visible_message(
			SPAN_DANGER("\The [target] freezes up!"),
			SPAN_DANGER("An immense force overwhelms your senses as you freeze up!")
		)
		target.Weaken(15)
		target.Stun(15)
