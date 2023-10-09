/obj/effect/rune/sacrifice
	rune_name = "Sacrifice"
	rune_desc = "Offer a living thing or a body to the Geometer of Blood. Living beings require three invokers to sacrifice, while dead beings require only one."
	rune_shorthand = "Offers a creature to the Geometer for consumption. Living beings require three invokers; dead being require only one."
	circle_words = list(CULT_WORD_HELL, CULT_WORD_BLOOD, CULT_WORD_JOIN)
	invocation = "Barhah hra zar'garis!"
	invokers_text = "1 or 3"
	var/mob/living/sacrificing

/// Fetches a sacrifice on top of this rune, aiming for the most "valuable" one (by way of species rarity, role, objective, and so on).
/obj/effect/rune/sacrifice/proc/get_sacrifical_lamb()
	var/list/sacrifices
	for (var/mob/living/L in get_turf(src))
		var/datum/mind/M = L.mind
		if (!iscultist(L) || cult?.sacrifice_target == M)
			var/worth = 0
			if (ishuman(L))
				var/mob/living/carbon/human/H = L
				if (H.species.rarity_value > 3)
					worth++
			if (M)
				if (M.assigned_role == "Chaplain")
					worth++
				if (cult?.sacrifice_target == M)
					worth = 99 // humgry.....
			LAZYSET(sacrifices, L, worth)
	if (LAZYLEN(sacrifices))
		var/mob/living/worthiest_sacrifice
		var/highest_value = -1
		for (var/mob/living/L in shuffle(sacrifices))
			if (sacrifices[L] > highest_value)
				worthiest_sacrifice = L
				highest_value = sacrifices[L]
		return worthiest_sacrifice
	return

/obj/effect/rune/sacrifice/get_required_invokers(mob/living/invoker)
	var/mob/living/L = get_sacrifical_lamb()
	if (!L)
		return required_invokers
	if (L.mind && cult.sacrifice_target == L.mind)
		to_chat(invoker, SPAN_NOTICE("This sacrifice's earthly bonds necessitates multiple invokers."))
		return 3
	else if (L.stat != DEAD)
		to_chat(invoker, SPAN_NOTICE("This sacrifice yet lives, necessitating multiple invokers."))
		return 3

/obj/effect/rune/sacrifice/can_invoke(mob/living/invoker)
	if (sacrificing)
		to_chat(invoker, SPAN_WARNING("The Geometer is already receiving a sacrifice."))
	return sacrificing == null

/obj/effect/rune/sacrifice/invoke(list/invokers)
	var/mob/living/L = get_sacrifical_lamb()
	if (!L)
		return fizzle()
	var/datum/gender/G = gender_datums[L.get_visible_gender()]
	L.visible_message(
		SPAN_DANGER("The runes beneath [L] widen into a gaping void. Something yanks [G.him] in before they snap shut."),
		!iscultist(L) ? SPAN_DANGER("You are dragged into the runes as they widen into a gaping maw!") : SPAN_OCCULT("Yes! Yes! The Geometer accepts you!")
	)
	sacrificing = L
	if (sacrificing.mind && cult.sacrifice_target == sacrificing.mind)
		for (var/mob/living/C in invokers)
			to_chat(C, SPAN_OCCULT("The Geometer of Blood is sated. Your objective is now complete."))
		LAZYADD(cult.sacrificed, sacrificing)
	else
		for (var/mob/living/C in invokers)
			to_chat(C, SPAN_OCCULT("The Geometer of Blood feasts on your sacrifice. You have pleased It."))
	if (isrobot(sacrificing)) // Prevent the MMI from surviving
		sacrificing.dust()
	else
		sacrificing.gib()



	/*// let's get proper ghoulish
	sacrificing.forceMove(src)
	for (var/i = 0; i < 10; i++)
		if (!sacrificing)
			break
		sacrificing.take_overall_damage(rand(30, 40), used_weapon = "massive bite marks")
		for (var/obj/item/organ/external/E in sacrificing.organs)
			if (prob(5))
				E.droplimb(FALSE, pick(DROPLIMB_BLUNT))
		playsound(src, 'sound/effects/squelch1.ogg', 50, TRUE)
		sleep (0.5 SECONDS)
	if (sacrificing)
		var/turf/T = get_turf(src)
		if (destroy_body)
			visible_message(SPAN_WARNING("Ragged remains and fluids seep from the sigils. There is no sign of a body."))
			sacrificing.gib()
			for (var/obj/O in src)
				if (isorgan(O))
					var/obj/item/organ/OR = O
					if (OR.vital)
						qdel(OR)
						continue
					else
						OR.take_damage(round(rand(OR.health / 1.5, OR.health)), TRUE)
				O.forceMove(T)
				if (prob(75))
					step(O, pick(cardinal))
		else
			sacrificing.forceMove(get_turf(src))
			sacrificing.set_dir(NORTH) // facedown
			sacrificing.adjustBruteLoss(666)
			gibs(T, sacrificing.dna)
			visible_message(SPAN_WARNING("[sacrificing] is slowly pushed through the sigils. There is little left of [G.his] body."))
			for (var/obj/item/organ/O in sacrificing.organs)
				if (prob(25) || O == sacrificing.get_organ(BP_HEAD))
					if (istype(O, /obj/item/organ/external))
						var/obj/item/organ/external/E = O
						E.droplimb(FALSE, DROPLIMB_EDGE)
					else
						sacrificing.rip_out_internal_organ(O)
					if (prob(50))
						qdel(O)
					else if (prob(75))
						step(O, pick(cardinal))
	playsound(src, 'sound/effects/splat.ogg', 75, TRUE, frequency = 20000)
	for (var/mob/M in view(src))
		shake_camera(M, 3, 1)
	sacrificing = null
	qdel(src)*/
