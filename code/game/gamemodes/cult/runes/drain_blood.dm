/obj/effect/newrune/drain_blood
	rune_name = "Drain Blood"
	circle_words = list(CULT_WORD_TRAVEL, CULT_WORD_BLOOD, CULT_WORD_SELF)
	invocation = "Yu'gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!"
	var/remaining_blood = 0
	var/mob/living/carbon/human/cultist

/obj/effect/newrune/drain_blood/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/newrune/drain_blood/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	if (cultist)
		to_chat(L, SPAN_WARNING("Another person is already drawing blood from this rune."))
		return
	var/total_blood = 0
	for (var/obj/effect/newrune/drain_blood/DB in world) // todo: replace this with something not horrendous
		for (var/mob/living/carbon/human/H in get_turf(DB))
			if (H.stat == DEAD)
				continue
			to_chat(H, SPAN_DANGER("You feel a heavy sense of weakness."))
			var/drain = rand(1, 25)
			H.take_overall_damage(drain)
			total_blood += drain
	if (!total_blood)
		return fizzle()
	var/datum/gender/G = gender_datums[L.get_visible_gender()]
	L.visible_message(
		SPAN_WARNING("\The [src] glows a sullen red as \the [L] presses [G.himself] against it. Blood seeps through the scrawlings."),
		SPAN_DANGER("Blood flows from \the [src] into your frail moral body. You feel... empowered.")
	)
	L.heal_organ_damage(total_blood % 5)
	total_blood -= total_blood % 5
	if (ishuman(L))
		cultist = L
		remaining_blood = total_blood / 5
		START_PROCESSING(SSfastprocess, src)

/obj/effect/newrune/drain_blood/process()
	if (!remaining_blood || !cultist)
		cultist = null
		STOP_PROCESSING(SSfastprocess, src)
		return
	remaining_blood--
	cultist.heal_organ_damage(5, 0)
	for (var/obj/item/organ/I in cultist.internal_organs)
		if (I.damage > 0)
			I.damage = max(I.damage - 5, 0)
		if (I.damage <= 5 && I.organ_tag == O_EYES)
			cultist.sdisabilities &= ~BLIND
	for (var/obj/item/organ/E in cultist.bad_external_organs)
		var/obj/item/organ/external/affected = E
		if ((affected.damage < affected.min_broken_damage * config.organ_health_multiplier) && (affected.status & ORGAN_BROKEN))
			affected.status &= ~ORGAN_BROKEN
		for(var/datum/wound/W in affected.wounds)
			if (istype(W, /datum/wound/internal_bleeding))
				affected.wounds -= W
				affected.update_damages()
