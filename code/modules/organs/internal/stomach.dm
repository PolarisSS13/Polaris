/obj/item/organ/internal/stomach
	name = "stomach"
	icon_state = "stomach"
	organ_tag = O_STOMACH
	parent_organ = BP_GROIN

	unacidable = TRUE	// Don't melt when holding your acid, dangit.

	var/acidtype = "stomacid"	// Incase you want some stomach organ with, say, polyacid instead, or sulphuric.
	var/max_acid_volume = 30

	var/deadly_hold = TRUE	// Does the stomach do damage to mobs eaten by its owner? Xenos should probably have this FALSE.

/obj/item/organ/internal/stomach/Initialize()
	. = ..()
	if(reagents)
		reagents.maximum_volume = max_acid_volume * 3
	else
		create_reagents(max_acid_volume * 3)

/obj/item/organ/internal/stomach/handle_organ_proc_special()
	if(owner && istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		if(reagents)
			if(reagents.total_volume + 2 < max_acid_volume && prob(20))
				reagents.add_reagent(acidtype, rand(1,2))

			for(var/mob/living/L in owner.stomach_contents) // Splashes mobs inside with acid. Twice as effective as being splashed with the same acid outside the body.
				reagents.trans_to(L, 2, 2, 0)

			if(reagents.has_any_other_reagent(list(acidtype)))
				var/obj/item/organ/internal/intestine/IN = H.internal_organs_by_name[O_INTESTINE]
				if(IN)
					reagents.trans_to_holder(IN.reagents, rand(5,10))

		if(is_broken() && prob(1))
			owner.custom_pain("There's a twisting pain in your abdomen!",1)
			owner.vomit(FALSE, TRUE)

/obj/item/organ/internal/stomach/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Bacterial Gastroenteritis
	if (. >= 1)
		if(prob(1))
			owner.custom_pain("There's a twisting pain in your abdomen!",1)
			owner.apply_effect(2, AGONY, 0)
	if (. >= 2)
		if(prob(1) && owner.getToxLoss() < owner.getMaxHealth()*0.2)
			owner.adjustToxLoss(3)
			owner.vomit(FALSE, TRUE)

/obj/item/organ/internal/stomach/xeno
	color = "#555555"
	acidtype = "pacid"

/obj/item/organ/internal/stomach/machine
	name = "reagent cycler"
	icon_state = "cycler"
	organ_tag = O_CYCLER

	can_reject = FALSE
	decays = FALSE

	robotic = ORGAN_ROBOT
	butcherable = FALSE

	acidtype = "sacid"

/obj/item/organ/internal/stomach/machine/handle_organ_proc_special()	// Acts as a normal stomach, but additionally, will move ingested reagents to the bloodstream.
	..()
	if(owner && owner.stat != DEAD)
		owner.bodytemperature += round(owner.robobody_count * 0.25, 0.1)

		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner

			if(H.ingested?.total_volume && H.bloodstr)
				H.ingested.trans_to_holder(H.bloodstr, rand(2,5))

	return
