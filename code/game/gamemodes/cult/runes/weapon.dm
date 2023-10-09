/obj/effect/rune/weapon
	rune_name = "Weapon"
	rune_desc = "Creates a deadly blade, adept at maiming and dismemberment. Use sparingly, for the Geometer disdains bloodshed not executed at Its request."
	circle_words = list(CULT_WORD_HELL, CULT_WORD_DESTROY, CULT_WORD_OTHER)
	invocation = "Sa tatha rajin!"

/obj/effect/rune/weapon/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	var/obj/item/melee/cultblade/C = new (get_turf(src))
	L.put_in_active_hand(C)
	L.visible_message(
		SPAN_DANGER("The runes coalesce into a long and cruel blade, which [L.get_active_hand() == C ? "\the [L] picks up" : "settles on the floor"]."),
		SPAN_DANGER("The runes coalesce into a long and cruel blade[L.get_active_hand() == C ? ", which you pick up" : ""].")
	)
	qdel(src)
