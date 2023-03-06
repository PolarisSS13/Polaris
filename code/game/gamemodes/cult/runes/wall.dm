/obj/effect/newrune/wall
	rune_name = "Wall"
	rune_desc = "Invoking this rune solidifies the air above it, creating an an invisible wall. Invoke the rune again to bring the barrier down."
	rune_shorthand = "Forms a reversible solid barrier when invoked."
	circle_words = list(CULT_WORD_DESTROY, CULT_WORD_TRAVEL, CULT_WORD_SELF)
	invocation = "Khari'd! Eske'te tannin!"

/obj/effect/newrune/wall/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	density = !density
	L.take_organ_damage(2, 0)
	to_chat(L, SPAN_DANGER("Your blood flows into the rune, and you feel [density ? "the very space above it thicken" : "it release its grasp on space"]."))
