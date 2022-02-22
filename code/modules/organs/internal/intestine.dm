/obj/item/organ/internal/intestine
	name = "intestine"
	icon_state = "intestine"
	organ_tag = O_INTESTINE
	parent_organ = BP_GROIN

	var/absorb_rate = 1	// Multiplier of how fast the intestines move reagents into the "ingested" metabolism.

	var/list/nullified_acids	// The reagents considered "stomach acid". If you have a stomach that produces ex: polyacid, you can drink all of it you want.

/obj/item/organ/internal/intestine/Initialize()
	. = ..()

	nullified_acids = list()

	if(!reagents)
		create_reagents(120)

/obj/item/organ/internal/intestine/handle_organ_proc_special()
	if(owner && istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		nullified_acids.Cut()
		for(var/obj/item/organ/internal/stomach/ST in H.internal_organs)
			nullified_acids |= ST.acidtype
		if(reagents?.total_volume)
			if(LAZYLEN(nullified_acids))
				for(var/acid in nullified_acids)
					reagents.remove_reagent(acid, reagents.maximum_volume)
			
			reagents.trans_to_holder(H.ingested, 3 * absorb_rate)
	return

/obj/item/organ/internal/intestine/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Viral Gastroenteritis
	if (. >= 1)
		if(prob(1))
			owner.custom_pain("There's a twisting pain in your abdomen!",1)
			owner.vomit()
	if (. >= 2)
		if(prob(1))
			owner.custom_pain("Your abdomen feels like it's tearing itself apart!",1)
			owner.m_intent = "walk"
			owner.hud_used.move_intent.icon_state = "walking"

/obj/item/organ/internal/intestine/machine
	name = "osmotic compressor"
	icon_state = "osmotic"

	can_reject = FALSE
	decays = FALSE

	robotic = ORGAN_ROBOT
	butcherable = FALSE

/obj/item/organ/internal/intestine/xeno
	color = "#555555"
