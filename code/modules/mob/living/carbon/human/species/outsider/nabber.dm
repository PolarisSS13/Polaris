/*
 * Main Species
 */


/datum/species/nabber
	name = SPECIES_NABBER
	name_plural = "Serpentids"
	blurb = "A species of large invertebrates."

	antaghud_offset_y = 8

	default_language = LANGUAGE_ROOTLOCAL
	language = LANGUAGE_GALCOM
	species_language = LANGUAGE_ROOTLOCAL

	num_alternate_languages = 2

	assisted_langs = list(LANGUAGE_GALCOM, LANGUAGE_SIVIAN, LANGUAGE_TRADEBAND, LANGUAGE_GUTTER, LANGUAGE_UNATHI, LANGUAGE_SKRELLIAN, LANGUAGE_SKRELLIANFAR, LANGUAGE_EAL, LANGUAGE_TERMINUS, LANGUAGE_ROOTGLOBAL)
	min_age = 8
	max_age = 40

	speech_sounds = list('sound/voice/bug.ogg')
	speech_chance = 2

	warning_low_pressure = 50
	hazard_low_pressure = -1

	minimum_breath_pressure = 20

	body_temperature = null

	blood_color = "#525252"
	flesh_color = "#525252"

	icon_template = 'icons/mob/human_races/template_tall.dmi'
	icobase = 'icons/mob/human_races/nabber/body.dmi'
	deform = 'icons/mob/human_races/nabber/body.dmi'
	blood_mask = 'icons/mob/human_races/nabber/blood_mask.dmi'

	icon_height = 40

	limb_blend = ICON_MULTIPLY

	rarity_value = 5
	hud_type = /datum/hud_data/nabber

	total_health = 200
	brute_mod = 0.9
	burn_mod =  1.35
	radiation_mod = 0.5
	pain_mod = 0.5
	flash_mod = 1.5

	darksight = 5
	nocturnal_sight = TRUE

	reagent_tag =	IS_INSECTOID

	natural_armour_values = list(
		melee = 15,
		bullet = 10,
		bomb = 30,
		bio = 100,
		rad = 2.5
		)

	gluttonous = GLUT_SMALLER
	taste_sensitivity = TASTE_SENSITIVE
	mob_size = MOB_LARGE
	blood_volume = 840

	heat_level_1 = 410 //Default 360 - Higher is better
	heat_level_2 = 440 //Default 400
	heat_level_3 = 800 //Default 1000

	heat_discomfort_strings = list(
		"Your limbs flush.",
		"You feel uncomfortably warm.",
		"Your carapace creaks in the heat."
		)

	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your carapace tightens in the cold."
		)

	flags = NO_SCAN | NO_SLIP | NO_MINOR_CUT
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_POSIBRAIN

	bump_flag = HEAVY
	push_flags = ALLMOBS
	swap_flags = ALLMOBS

	move_trail = /obj/effect/decal/cleanable/blood/tracks/snake

	has_organ = list(
		O_BRAIN =    /obj/item/organ/internal/brain/insectoid/nabber,
		O_EYES =     /obj/item/organ/internal/eyes/insectoid/nabber,
		O_LUNGS =    /obj/item/organ/internal/lungs/insectoid/nabber,
		O_LIVER =    /obj/item/organ/internal/liver/insectoid/nabber,
		O_HEART =    /obj/item/organ/internal/heart/insectoid,
		O_STOMACH =  /obj/item/organ/internal/stomach/insectoid,
		O_INTESTINE = /obj/item/organ/internal/intestine/insectoid,
		O_PHORON =   /obj/item/organ/internal/phoron,
		O_ACETONE =  /obj/item/organ/internal/acetone,
		O_VOICE =    /obj/item/organ/internal/voicebox/nabber
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/insectoid/nabber),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/nabber),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid/nabber),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid/nabber),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid/nabber),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid/nabber),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid/nabber)
		)

	unarmed_types = list(/datum/unarmed_attack/nabber)

	ambiguous_genders = TRUE

	descriptors = list(
		/datum/mob_descriptor/height = 3,
		/datum/mob_descriptor/build = 3,
		/datum/mob_descriptor/body_length = 0
		)

/datum/species/nabber/New()
	equip_adjust = list(
		slot_wear_suit_str = list("[NORTH]" = list("x" = 0, "y" = 9), "[EAST]" = list("x" = 0, "y" = 9), "[SOUTH]" = list("x" = 0, "y" = 9), "[WEST]" = list("x" = 0, "y" = 9)),
		slot_head_str =    list("[NORTH]" = list("x" = 0, "y" = 8),  "[EAST]" = list("x" = 0, "y" = 9),  "[SOUTH]" = list("x" = 0, "y" = 9),  "[WEST]" = list("x" = 0, "y" = 9)),
		slot_back_str =    list("[NORTH]" = list("x" = 0, "y" = 7),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" = 0, "y" = 8),  "[WEST]" = list("x" = 0, "y" = 8)),
		slot_belt_str =    list("[NORTH]" = list("x" = 0, "y" = 0),  "[EAST]" = list("x" = 8, "y" = 0),  "[SOUTH]" = list("x" = 0, "y" = 0),  "[WEST]" = list("x" = -8, "y" = 0)),
		slot_glasses_str = list("[NORTH]" = list("x" = 0, "y" = 10), "[EAST]" = list("x" = 3, "y" = 10), "[SOUTH]" = list("x" = 0, "y" = 9), "[WEST]" = list("x" = -3, "y" = 10)),
		slot_l_ear_str = list("[NORTH]" = list("x" = 0, "y" = 10), "[EAST]" = list("x" = 3, "y" = 10), "[SOUTH]" = list("x" = 0, "y" = 9), "[WEST]" = list("x" = -3, "y" = 10)),
		slot_wear_mask_str = list("[NORTH]" = list("x" = 0, "y" = 10), "[EAST]" = list("x" = 3, "y" = 9), "[SOUTH]" = list("x" = 0, "y" = 9), "[WEST]" = list("x" = -3, "y" = 9))
	)
	..()

/datum/species/nabber/get_blood_name()
	return "haemolymph"

/datum/species/nabber/can_overcome_gravity(mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS && !H.back)	// Must be awake, and not wearing anything over their back.
		var/obj/item/organ/external/chest/Torso = H.organs_by_name[BP_TORSO]
		if(!Torso.is_broken() || !(Torso.is_bruised() && prob(5)))
			var/datum/gas_mixture/mixture = H.loc.return_air()

			if(mixture)
				var/pressure = mixture.return_pressure()
				if(pressure > 50)
					var/turf/below = GetBelow(H)
					var/turf/T = H.loc
					if(!T.CanZPass(H, DOWN) || !below.CanZPass(H, DOWN))
						return TRUE

	return ..(H)

/datum/species/nabber/handle_environment_special(mob/living/carbon/human/H)
	if(!H.on_fire && H.fire_stacks < 2)
		H.fire_stacks += 0.2
	return

// Nabbers will only fall when there isn't enough air pressure for them to keep themselves aloft.
/datum/species/nabber/can_fall(mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS && !H.back)	// Awake, and not wearing anything on the back.
		var/obj/item/organ/external/chest/Torso = H.organs_by_name[BP_TORSO]
		if(!Torso.is_broken() || !(Torso.is_bruised() && prob(5)))
			var/datum/gas_mixture/mixture = H.loc.return_air()

			//nabbers should not be trying to break their fall on stairs.
			var/turf/T = GetBelow(H.loc)
			for(var/obj/O in T)
				if(istype(O, /obj/structure/stairs))
					return TRUE
			if(mixture)
				var/pressure = mixture.return_pressure()
				if(pressure > 80)
					return FALSE

	return TRUE

// Even when nabbers do fall, if there's enough air pressure they won't hurt themselves.
/datum/species/nabber/handle_falling(mob/living/carbon/human/H, turf/landing, damage_min, damage_max, silent, planetary)
	if(H.stat == CONSCIOUS && !H.back)	// Awake, and not wearing anything on the back.
		var/datum/gas_mixture/mixture = H.loc.return_air()

		var/turf/T = GetBelow(H.loc)

		//Nabbers should not be trying to break their fall on stairs.
		for(var/obj/O in T)
			if(istype(O, /obj/structure/stairs))
				return FALSE

		if(mixture)
			var/pressure = mixture.return_pressure()
			if(pressure > 50)
				if(istype(landing, /turf/simulated/open))
					H.visible_message("\The [H] descends from the deck above through \the [landing]!", "Your wings slow your descent.")
				else
					H.visible_message("\The [H] buzzes down from \the [landing], wings slowing their descent!", "You land on \the [landing], folding your wings.")

				return TRUE

	return FALSE


/datum/species/nabber/can_shred(mob/living/carbon/human/H, ignore_intent, ignore_antag)
	if(!H.handcuffed || H.buckled)
		return ..(H, ignore_intent, TRUE)
	else
		return 0

/datum/species/nabber/get_slowdown(var/mob/living/carbon/human/H)
	var/tally = slowdown

	var/obj/item/organ/internal/B = H.internal_organs_by_name[O_BRAIN]
	if(istype(B,/obj/item/organ/internal/brain/insectoid/nabber))
		var/obj/item/organ/internal/brain/insectoid/nabber/N = B

		tally += N.lowblood_tally * 2
	return tally

/datum/species/nabber/update_skin(mob/living/carbon/human/H)

	if(H.stat)
		H.skin_state = SKIN_NORMAL

	switch(H.skin_state)
		if(SKIN_NORMAL)
			return
		if(SKIN_THREAT)

			var/image_key = "[H.species.get_race_key(src)]"

			for(var/organ_tag in H.species.has_limbs)
				var/obj/item/organ/external/part = H.organs_by_name[organ_tag]
				if(isnull(part) || part.is_stump())
					image_key += "0"
					continue
				if(part)
					image_key += "[part.species.get_race_key(part.owner)]"
					image_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
				if(part.is_robotic())
					image_key += "2[part.model ? "-[part.model]": ""]"
				else if(part.status & ORGAN_DEAD)
					image_key += "3"
				else
					image_key += "1"

			var/image/threat_image = skin_overlays[image_key]
			if(!threat_image)
				var/icon/base_icon = icon(H.icon)
				var/icon/I = new('icons/mob/human_races/nabber/threat.dmi', "threat")
				base_icon.Blend(COLOR_BLACK, ICON_MULTIPLY)
				base_icon.Blend(I, ICON_ADD)
				threat_image  = image(base_icon)
				skin_overlays[image_key] = threat_image

			return(threat_image)
	return

/datum/species/nabber/disarm_attackhand(mob/living/carbon/human/attacker, mob/living/carbon/human/target)
	if(attacker.pulling_punches || target.lying || attacker == target)
		return ..(attacker, target)
	if(world.time < attacker.last_attack + 20)
		to_chat(attacker, SPAN_NOTICE("You can't attack again so soon."))
		return 0
	attacker.last_attack = world.time

	var/turf/T = get_step(get_turf(target), get_dir(get_turf(attacker), get_turf(target)))
	playsound(target.loc, 'sound/weapons/pushhiss.ogg', 50, 1, -1)
	if(!T.density)
		step(target, get_dir(get_turf(attacker), get_turf(target)))
		target.visible_message(SPAN_DANGER("[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]"))
	else
		target.turf_collision(T, target.throw_speed / 2)
	if(prob(50))
		target.set_dir(GLOB.reverse_dir[target.dir])

/datum/species/nabber/get_additional_examine_text(mob/living/carbon/human/H)
	var/datum/gender/T = gender_datums[H.get_gender()]
	if(H.pulling_punches)
		return "\n[T.His] manipulation arms are out and [T.he] looks ready to use complex items."
	else
		return "\n[SPAN_WARNING("[T.His] deadly upper arms are raised and [T.he] looks ready to attack!")]"

/datum/species/nabber/handle_post_spawn(mob/living/carbon/human/H)
	..()
	return H.pulling_punches = TRUE

/datum/species/nabber/has_fine_manipulation(mob/living/carbon/human/H)
	return (..() && (H && H.pulling_punches))

/datum/species/nabber/toggle_stance(mob/living/carbon/human/H)
	if(H.incapacitated())
		return FALSE
	var/datum/gender/T = gender_datums[H.get_gender()]
	to_chat(H, SPAN_NOTICE("You begin to adjust the fluids in your arms, dropping everything and getting ready to swap which set you're using."))
	var/hidden = H.is_cloaked()
	if(!hidden) H.visible_message(SPAN_WARNING("\The [H] shifts [T.his] arms."))
	for (var/obj/item/item as anything in H.get_all_held_items())
		H.unEquip(item)
	if(do_after(H, 3 SECONDS, ignore_movement = TRUE))
		arm_swap(H)
	else
		to_chat(H, SPAN_NOTICE("You stop adjusting your arms and don't switch between them."))
	return TRUE

/datum/species/nabber/proc/arm_swap(mob/living/carbon/human/H, forced)
	for (var/obj/item/item as anything in H.get_all_held_items())
		H.unEquip(item)
	var/hidden = H.is_cloaked()
	var/datum/gender/T = gender_datums[H.get_gender()]
	H.pulling_punches = !H.pulling_punches
	if(H.pulling_punches)
		H.current_grab_type = GRAB_NORMAL
		if(forced)
			to_chat(H, SPAN_NOTICE("You can't keep your hunting arms prepared and they drop, forcing you to use your manipulation arms."))
			if(!hidden)
				H.visible_message(SPAN_NOTICE("[H] falters, [T.his] hunting arms failing."))
		else
			to_chat(H, SPAN_NOTICE("You relax your hunting arms, lowering the pressure and folding them tight to your thorax. \
			You reach out with your manipulation arms, ready to use complex items."))
			if(!hidden)
				H.visible_message(SPAN_NOTICE("[H] seems to relax as [T.he] folds [T.his] massive curved arms to [T.his] thorax and reaches out \
				with [T.his] small handlike limbs."))
	else
		H.current_grab_type = GRAB_NAB
		to_chat(H, SPAN_NOTICE("You pull in your manipulation arms, dropping any items and unfolding your massive hunting arms in preparation of grabbing prey."))
		if(!hidden)
			H.visible_message(SPAN_WARNING("[H] tenses as [T.he] brings [T.his] smaller arms in close to [T.his] body. [T.His] two massive spiked arms reach \
			out. [T.He] looks ready to attack."))

/obj/item/grab/nab
	name = GRAB_NAB
	state = GRAB_AGGRESSIVE

/obj/item/grab/nab/Initialize()
	. = ..()
	affecting.apply_damage(15, BRUTE, BP_TORSO, sharp = TRUE)
	affecting.visible_message(SPAN_DANGER("[assailant]'s spikes dig in painfully!"))
	affecting.Stun(10)

/datum/species/nabber/queen
	name = SPECIES_NABBER_MONARCH

	blood_color = "#4d3d50"
	flesh_color = "#4d3d50"

	icon_template = 'icons/mob/human_races/template.dmi'
	icobase = 'icons/mob/human_races/nabber/monarch/body.dmi'
	deform = 'icons/mob/human_races/nabber/monarch/body.dmi'
	blood_mask = 'icons/mob/human_races/nabber/monarch/blood_mask.dmi'

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/insectoid/nabber),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/nabber),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid/nabber/monarch),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid/nabber),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid/nabber),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid/nabber),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid/nabber)
		)

	descriptors = list(
		/datum/mob_descriptor/height = 0,
		/datum/mob_descriptor/build = -1,
		/datum/mob_descriptor/body_length = -2
		)

/datum/species/nabber/queen/New()
	..()
	equip_adjust = list(
		slot_head_str =    list("[NORTH]" = list("x" = 0, "y" = -6),  "[EAST]" = list("x" = 4, "y" = -6),  "[SOUTH]" = list("x" = 0, "y" = -6),  "[WEST]" = list("x" = -4, "y" = -6)),
		slot_back_str =    list("[NORTH]" = list("x" = 0, "y" = -4),  "[EAST]" = list("x" = 3, "y" = -4),  "[SOUTH]" = list("x" = 0, "y" = -4),  "[WEST]" = list("x" = -3, "y" = -4)),
		slot_belt_str =    list("[NORTH]" = list("x" = 0, "y" = -2),  "[EAST]" = list("x" = 8, "y" = -2),  "[SOUTH]" = list("x" = 0, "y" = -2),  "[WEST]" = list("x" = -8, "y" = -2)),
		slot_glasses_str = list("[NORTH]" = list("x" = 0, "y" = -3), "[EAST]" = list("x" = 3, "y" = -3), "[SOUTH]" = list("x" = 0, "y" = -3), "[WEST]" = list("x" = -3, "y" = -3)),
		slot_l_ear_str = list("[NORTH]" = list("x" = 0, "y" = -3), "[EAST]" = list("x" = 3, "y" = -3), "[SOUTH]" = list("x" = 0, "y" = -3), "[WEST]" = list("x" = -3, "y" = -3)),
		slot_wear_mask_str = list("[NORTH]" = list("x" = 0, "y" = -3), "[EAST]" = list("x" = 3, "y" = -3), "[SOUTH]" = list("x" = 0, "y" = -3), "[WEST]" = list("x" = -3, "y" = -3))
	)
