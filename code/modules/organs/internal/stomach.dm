/obj/item/organ/internal/stomach
	name = "stomach"
	icon_state = "stomach"
	organ_tag = O_STOMACH
	parent_organ = BP_GROIN

	unacidable = TRUE	// Don't melt when holding your acid, dangit.

	var/acidtype = "stomacid"	// Incase you want some stomach organ with, say, polyacid instead, or sulphuric.
	var/max_acid_volume = 30

	var/deadly_hold = TRUE	// Does the stomach do damage to mobs eaten by its owner? Xenos should probably have this FALSE.

	var/list/pills

/obj/item/organ/internal/stomach/Initialize()
	. = ..()
	if(reagents)
		reagents.maximum_volume = max_acid_volume * 2
	else
		create_reagents(max_acid_volume * 2)

/obj/item/organ/internal/stomach/handle_organ_proc_special()
	if(owner && istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		if(reagents)
			if(reagents.total_volume + 2 < max_acid_volume && prob(20))
				reagents.add_reagent(acidtype, rand(1,2))

			for(var/mob/living/L in owner.stomach_contents) // Splashes mobs inside with acid. Twice as effective as being splashed with the same acid outside the body.
				reagents.trans_to(L, 2, 2, 0)

			if(reagents.has_reagent(acidtype, 5) && LAZYLEN(pills))
				var/datum/reagent/acid/acid = reagents.get_reagent(acidtype)
				for(var/obj/item/weapon/reagent_containers/pill/pill in pills)	// Bigger pill, more likely to crack before breakdown.
					var/pill_integrity = pills[pill]
					if((pill_integrity < (pill.reagents.total_volume / 4) && prob(pill.reagents.total_volume)) || pill_integrity <= 0)
						var/obj/item/organ/internal/intestine/IN = H.internal_organs_by_name[O_INTESTINE]
						if(IN)	// Transfer what of the pill you can to the intestine directly.
							pill.reagents.trans_to_holder(IN.reagents, pill.reagents.total_volume)
						
						if(pill.reagents.total_volume > 0)	// Still pill left? Try putting it in the stomach.
							pill.reagents.trans_to_holder(reagents, pill.reagents.total_volume)
						
						if(pill.reagents.total_volume <= 0)	// If the pill is "empty", forget about it and delete it.
							pills.Remove(pill)
							qdel(pill)
							continue

					pills[pill] = max(pill_integrity - acid.power, 0)	// Melt pill. Stronger stomach acid, faster melt.
					reagents.remove_reagent(acidtype, rand(2,5))

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

/obj/item/organ/internal/stomach/proc/handle_pill(var/obj/item/weapon/reagent_containers/pill/pill)
	if(!istype(pill))	// ..Not a pill.
		return FALSE

	if(!LAZYLEN(pills))
		pills = list()

	pill.forceMove(src)

	var/pill_volume = pill.reagents.total_volume	// How big is the pill?
	pills[pill] = pill_volume * (rand(7,12) / 10)

	return TRUE

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
