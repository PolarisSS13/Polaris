/obj/item/paper/talisman/emp
	talisman_name = "Disable Technology"
	talisman_desc = "Emits a strong electromagnetic pulse in a small radius, disabling or harming nearby electronics."
	tome_desc = "Shorter range."
	invocation = "Ta'gh fara'qha fel d'amar det!"

/obj/item/paper/talisman/emp/invoke(mob/living/user)
	var/turf/T = get_turf(user)
	to_chat(user, SPAN_WARNING("The talisman shudders in your hand as it swells with searing heat, then burns to dust."))
	playsound(user, 'sound/items/Welder.ogg', 50, TRUE)
	empulse(T, 1, 1, 2, 3)
	qdel(src)
