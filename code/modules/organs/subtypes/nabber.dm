
/obj/item/organ/external/head/insectoid/nabber
	name = "head"
	vital = 0
	cannot_gib = FALSE

	eye_icon_location = 'icons/mob/human_races/nabber/eyes.dmi'

/obj/item/organ/external/head/insectoid/nabber/monarch
	eye_icon_location = 'icons/mob/human_races/nabber/monarch/eyes.dmi'

/obj/item/organ/external/chest/insectoid/nabber
	name = "thorax"
	encased = "carapace"

/obj/item/organ/external/groin/insectoid/nabber
	name = "abdomen"
	icon_position = UNDER
	encased = "carapace"

/obj/item/organ/external/leg/insectoid/nabber
	name = "left tail side"
	icon_position = LEFT
	encased = "carapace"

	cannot_amputate = TRUE

/obj/item/organ/external/leg/right/insectoid/nabber
	name = "right tail side"
	encased = "carapace"

	cannot_amputate = TRUE

/obj/item/organ/external/foot/insectoid/nabber
	name = "left tail tip"
	icon_position = LEFT
	encased = "carapace"

	cannot_amputate = TRUE

/obj/item/organ/external/foot/right/insectoid/nabber
	name = "right tail tip"
	icon_position = RIGHT
	encased = "carapace"

	cannot_amputate = TRUE

/*
 * Internal
 */

// Voice

/obj/item/organ/internal/voicebox/nabber
	name = "vocal synthesiser"
	assists_languages = list(LANGUAGE_SOL_COMMON, LANGUAGE_GUTTER, LANGUAGE_TRADEBAND, LANGUAGE_EAL, LANGUAGE_GALCOM, LANGUAGE_SIVIAN)

/obj/item/organ/internal/voicebox/nabber/Initialize()
	. = ..()
	robotize()

// Eyes and the 'glasses' associated with them.

/obj/item/organ/internal/eyes/insectoid/nabber
	name = "compound eyes"
	innate_flash_protection = FLASH_PROTECTION_VULNERABLE
	action_button_name = "Toggle Eye Shields"

	var/obj/item/clothing/glasses/my_deploy = /obj/item/clothing/glasses/organic_lenses

/obj/item/organ/internal/eyes/insectoid/nabber/attack_self(mob/living/carbon/human/user)
	if(!owner || owner != user)
		return ..()
	if(user.glasses)
		if(user.glasses == my_deploy)
			user.drop_from_inventory(user.glasses, src)
			my_deploy.forceMove(src)
		else
			to_chat(user, SPAN_WARNING("\The [user.glasses] are in the way of your lenses."))

	else
		user.equip_to_slot(my_deploy, slot_glasses)
	return

/obj/item/organ/internal/eyes/insectoid/nabber/additional_flash_effects(intensity)
	if(intensity > 0)
		take_damage(max(0, 4 * (intensity)))
	return 1

/obj/item/organ/internal/eyes/insectoid/nabber/Initialize(mob/living/carbon/holder)
	. = ..()
	if(dna)
		color = rgb(dna.GetUIValue(DNA_UI_EYES_R), dna.GetUIValue(DNA_UI_EYES_G), dna.GetUIValue(DNA_UI_EYES_B))

	if(ispath(my_deploy))
		my_deploy = new my_deploy(src)

/obj/item/organ/internal/eyes/insectoid/nabber/set_dna(datum/dna/new_dna)
	. = ..()
	color = rgb(new_dna.GetUIValue(DNA_UI_EYES_R), new_dna.GetUIValue(DNA_UI_EYES_G), new_dna.GetUIValue(DNA_UI_EYES_B))

/obj/item/clothing/glasses/organic_lenses
	name = "hard lenses"
	desc = "Hard, glasslike eye-coverings."
	icon_state = "jensenshades"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	item_state = "eyes_s"

	canremove = FALSE

	alpha = 100
	tint = TINT_HEAVY
	flash_protection = FLASH_PROTECTION_MAJOR

	sprite_sheets = list(
		SPECIES_NABBER = 'icons/mob/species/nabber/glasses.dmi',
		SPECIES_NABBER_MONARCH = 'icons/mob/species/nabber/monarch/glasses.dmi'
	)

// Phoron Handler

/obj/item/organ/internal/phoron
	name = "phoron storage"
	icon_state = "stomach"
	color = "#ed81f1"
	organ_tag = O_PHORON
	parent_organ = BP_TORSO
	var/phoron_level = 10
	var/raw_amount = 0.1

/obj/item/organ/internal/phoron/handle_organ_proc_special()
	if(owner)
		var/amount = raw_amount
		if(is_broken())
			amount *= 0.5
		else if(is_bruised())
			amount *= 0.8

		var/phoron_volume_raw = owner.reagents.get_reagent_amount("phoron")

		if((phoron_volume_raw < phoron_level || !phoron_volume_raw) && owner.reagents.get_reagent_amount("acetone"))
			var/acetone_amount = owner.reagents.get_reagent_amount("acetone")
			amount = max(phoron_level - phoron_volume_raw, 0)	// Make sure we don't go over the cap, 'producing' phoron without very exotic (xeno) biology is expensive.
			amount = min(acetone_amount / 4, amount)	// Make sure we have enough acetone to conclude the reaction. 4 to 1 ratio.
			owner.reagents.remove_reagent("acetone", amount * 4)
			owner.reagents.add_reagent("phoron", amount)
	..()

// Liver

/obj/item/organ/internal/liver/insectoid/nabber
	name = "toxin filter"
	color = "#66ff99"
	organ_tag = O_LIVER
	parent_organ = BP_TORSO

// Acetone handler.

/obj/item/organ/internal/acetone
	name = "acetone reactor"
	icon_state = "vox lung"
	color = "#ff6699"
	organ_tag = O_ACETONE
	parent_organ = BP_GROIN
	var/efficiency = 0
	var/dexalin_level = 12
	var/acetone_level = 10
	var/raw_production = 0.8

/obj/item/organ/internal/acetone/handle_organ_proc_special()
	..()
	if(!owner)
		return

	var/obj/item/organ/internal/heart/Pump = owner.internal_organs_by_name[O_HEART]
	if(!is_broken())
		if(!Pump)
			efficiency = 0.5
		else
			efficiency = max(0.1, (1 - 0.5 * Pump.is_bruised()) * !Pump.is_broken())

		if(is_bruised())
			efficiency *= 0.5
	else
		efficiency = 0.1

	var/acetone_in_stream = owner.reagents.get_reagent_amount("acetone")

	if(acetone_in_stream < acetone_level)
		owner.reagents.add_reagent("acetone", efficiency * raw_production)

	acetone_in_stream = owner.reagents.get_reagent_amount("acetone")
	var/phoron_in_stream = owner.reagents.get_reagent_amount("phoron")
	var/dexalin_in_stream = owner.reagents.get_reagent_amount("dexalin")

	if((owner.nutrition > 0) && (acetone_in_stream > 2) && (phoron_in_stream > 1) && (dexalin_in_stream < (dexalin_level * (owner.losebreath / 25))))	// If acetone is high enough, we have Phoron stored, and we're losing breath.
		var/nutrition_modifier = owner.nutrition / MAX_NUTRITION
		owner.reagents.remove_reagent("phoron", 1)
		owner.reagents.remove_reagent("acetone", 2 * nutrition_modifier)
		owner.reagents.add_reagent("dexalin", 2 * nutrition_modifier)

// Not-Lungs-But-Actually-Lungs

/obj/item/organ/internal/lungs/insectoid/nabber
	name = "tracheae"
	gender = PLURAL
	parent_organ = BP_GROIN

/obj/item/organ/internal/lungs/insectoid/nabber/Initialize()
	..()

	if(istype(owner))
		owner.reagents.add_reagent("phoron", 5)

/obj/item/organ/internal/lungs/insectoid/nabber/handle_organ_proc_special()
	if(!owner)
		return

	if(owner.reagents.get_reagent_amount("phoron") < 5)	// Phoron is a chemical component of the species' respiration, but not the gas they use. 10 is the 'optimal' circulating amount.
		if(prob(4))
			spawn owner?.custom_emote(VISIBLE_MESSAGE, "hyperventilates!")
			owner.AdjustLosebreath(rand(2,8))

/obj/item/organ/internal/lungs/insectoid/nabber/rupture()
	if(owner)
		to_chat(owner, SPAN_DANGER("You feel air rushing through your trachea!"))

	bruise()

// Thinkpan

/obj/item/organ/internal/brain/insectoid/nabber
	var/lowblood_tally = 0
	name = "distributed nervous system"
	parent_organ = BP_TORSO

/obj/item/organ/internal/brain/insectoid/nabber/process()
	if(!owner || !owner.should_have_organ(O_HEART))
		return

	lowblood_tally = 0

	var/bloodmax = species.blood_volume	// Species blood level maximum.
	var/bloodcurrent = owner.vessel.total_volume	// Owner's current blood level. If implanted into a species with *less blood*, it will count as being lower.

	var/blood_volume = bloodcurrent / bloodmax * 100

	//Effects of bloodloss
	switch(blood_volume)
		if (85 to 100)
			lowblood_tally = 0
		if(70 to 85)
			lowblood_tally = 2
			if(prob(1))
				to_chat(owner, SPAN_WARNING("You're finding it difficult to move."))
		if(60 to 70)
			lowblood_tally = 4
			if(prob(1))
				to_chat(owner, SPAN_WARNING("Moving has become very difficult."))
		if(30 to 60)
			lowblood_tally = 6
			if(prob(15))
				to_chat(owner, SPAN_WARNING("You're almost unable to move!"))
				if(!owner.pulling_punches)
					var/datum/species/nabber/nab = species
					nab.arm_swap(owner, TRUE)
		if(-(INFINITY) to 30)
			lowblood_tally = 10
			if(prob(30) && !owner.pulling_punches)
				var/datum/species/nabber/nab = species
				nab.arm_swap(owner, TRUE)
			if(prob(10))
				to_chat(owner, SPAN_WARNING("Your body is barely functioning and is starting to shut down."))
				owner.Paralyse(1)
				var/obj/item/organ/internal/I = pick(owner.internal_organs)
				I.take_damage(5)
	..()
