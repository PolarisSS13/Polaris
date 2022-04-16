//Verbs after this point.
/mob/living/carbon/diona_nymph/proc/merge()

	set category = "Abilities"
	set name = "Merge with gestalt"
	set desc = "Merge with another diona."

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(ishuman(src.loc)
		src.verbs -= /mob/living/carbon/diona_nymph/proc/merge
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1))
		if(!(Adjacent(H)) || !(H.client))
			continue

		var/mob/living/carbon/human/D = C
		if(H?.species?.name == SPECIES_DIONA)
			choices += C

	var/mob/living/M = input(src,"Who do you wish to merge with?") in null|choices

	if(!M)
		to_chat(src, "There is nothing nearby to merge with.")
	else if(!do_merge(M))
		to_chat(src, "You fail to merge with \the [M]...")

/mob/living/carbon/diona_nymph/proc/do_merge(var/mob/living/carbon/human/H)
	if(!istype(H) || !src || !(src.Adjacent(H)))
		return FALSE
	to_chat(H, "You feel your being twine with that of \the [src] as it merges with your biomass.")
	to_chat(src, "You feel your being twine with that of \the [H] as you merge with its biomass.")
	loc = H
	verbs += /mob/living/carbon/diona_nymph/proc/split
	verbs -= /mob/living/carbon/diona_nymph/proc/merge
	return TRUE

/mob/living/carbon/diona_nymph/proc/split()

	set category = "Abilities"
	set name = "Split from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(!(ishuman(src.loc)))
		src.verbs -= /mob/living/carbon/diona_nymph/proc/split
		return

	var/mob/living/carbon/human/H = src.loc
	if(H.species?.name != SPECIES_DIONA)
		src.verbs -= /mob/living/carbon/diona_nymph/proc/split
		return

	to_chat(src.loc, "You feel a pang of loss as [src] splits away from your biomass.")
	to_chat(src, "You wiggle out of the depths of [src.loc]'s biomass and plop to the ground.")

	src.forceMove(get_turf(src))
	src.verbs -= /mob/living/carbon/diona_nymph/proc/split
	src.verbs += /mob/living/carbon/diona_nymph/proc/merge

/mob/living/carbon/diona_nymph/confirm_evolution()

	if(!is_alien_whitelisted(src, GLOB.all_species[SPECIES_DIONA]))
		alert(src, "You are currently not whitelisted to play as a full diona.")
		return null

	if(amount_grown < max_grown)
		to_chat(src, "You are not yet ready for your growth...")
		return null

	src.split()

	if(istype(loc,/obj/item/weapon/holder/diona))
		var/obj/item/weapon/holder/diona/L = loc
		src.loc = L.loc
		qdel(L)

	src.visible_message("<font color='red'>[src] begins to shift and quiver, and erupts in a shower of shed bark as it splits into a tangle of nearly a dozen new dionaea.</font>","<font color='red'>You begin to shift and quiver, feeling your awareness splinter. All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of at least a dozen new dionaea. We have attained our gestalt form.</font>")
	return SPECIES_DIONA
