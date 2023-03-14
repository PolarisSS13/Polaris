/obj/item/paper/talisman/deafen
	talisman_name = "Deafen"
	talisman_desc = "Induces deafness in all nearby nonbelievers."
	tome_desc = "Shorter range."
	invocation = "Sti'kaliedir!"

/obj/item/paper/talisman/deafen/invoke(mob/living/user)
	user.visible_message(
		SPAN_WARNING("Dust flows from \the [user]'s hands, and the world goes quiet..."),
		SPAN_WARNING("The talisman in your hands turns to gray dust, deafening nearby nonbelievers."),
		range = 1
	)
	var/list/affected = list()
	for (var/mob/living/L in hearers(7, src))
		if (iscultist(L) || findNullRod(L))
			continue
		affected.Add(L)
		L.ear_deaf = max(30, L.ear_deaf)
		to_chat(L, SPAN_DANGER("Your ears pop and the world goes quiet."))
	add_attack_logs(user, affected, "deafness talisman")
