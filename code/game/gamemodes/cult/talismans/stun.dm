/obj/item/paper/newtalisman/stun
	talisman_name = "Stun"
	talisman_desc = "Forces the concentrated energy of a stun rune into a struck target, immediately knocking them to the ground. Humans will be prevented from speaking for a time."
	invocation = "Dream sign 'Evil Sealing Talisman'!" // I think this is a touhou reference

/obj/item/paper/newtalisman/stun/invoke(mob/living/user, mob/living/target)
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
