/datum/species/vox
	name = SPECIES_VOX
	name_plural = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	default_language = LANGUAGE_VOX
	language = LANGUAGE_GALCOM
	species_language = LANGUAGE_VOX
	num_alternate_languages = 1
	assisted_langs = list(LANGUAGE_ROOTGLOBAL)
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/strong
	)

	// Vox are resistant to chems in general
	chem_strength_heal =    0.35
	chem_strength_tox =     0.35
	chem_strength_alcohol = 0.35
	chem_strength_pain =    0.35

	taste_sensitivity = TASTE_DULL // it would have to be, wouldn't it

	rarity_value = 5
	blurb = "The Vox are the broken remnants of a once-proud race, now reduced to little more than \
	scavenging vermin who prey on isolated stations, ships or planets to keep their own ancient arkships \
	alive. They are four to five feet tall, reptillian, beaked, tailed and quilled; human crews often \
	refer to them as 'shitbirds' for their violent and offensive nature, as well as their reputation for \
	foul personal hygiene and a horrible smell.<br/><br/>Most humans will never meet a Vox, instead learning \
	of this insular species through dealing with their traders and merchants; those that do rarely enjoy the \
	experience."
	catalogue_data = list(/datum/category_item/catalogue/fauna/vox)

	slowdown = -0.5

	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	scream_verb_1p = "shriek"
	scream_verb_3p = "shrieks"
	male_scream_sound = 'sound/voice/shriek1.ogg'
	female_scream_sound = 'sound/voice/shriek1.ogg'
	male_cough_sounds = list('sound/voice/shriekcough.ogg')
	female_cough_sounds = list('sound/voice/shriekcough.ogg')
	male_sneeze_sound = 'sound/voice/shrieksneeze.ogg'
	female_sneeze_sound = 'sound/voice/shrieksneeze.ogg'

	cold_level_1 = 210	//Default 260
	cold_level_2 = 150	//Default 200
	cold_level_3 = 90	//Default 120

	gluttonous = GLUT_TINY|GLUT_ITEM_NORMAL

	breath_type = "nitrogen"
	poison_type = "oxygen"
	shock_vulnerability = 0.2

	flags = NO_SCAN
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR
	limb_blend = ICON_MULTIPLY

	blood_color = "#9066BD"
	flesh_color = "#808D11"
	tail = "voxtail"
	tail_hair = "quills"
	tail_blend = ICON_MULTIPLY

	reagent_tag = IS_VOX

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/vox),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)


	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart/vox,
		O_LUNGS =    /obj/item/organ/internal/lungs/vox,
		O_VOICE =	 /obj/item/organ/internal/voicebox,
		O_LIVER =    /obj/item/organ/internal/liver/vox,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys/vox,
		O_BRAIN =    /obj/item/organ/internal/brain/vox,
		O_EYES =     /obj/item/organ/internal/eyes,
		O_STOMACH =  /obj/item/organ/internal/stomach/vox
		)

	genders = list(NEUTER)

	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/build = 1,
		/datum/mob_descriptor/vox_markings = 0
	)

	default_emotes = list(
		/decl/emote/audible/vox_shriek
	)
	inherent_verbs = list(/mob/living/carbon/human/proc/toggle_vox_pressure_seal)
	var/list/current_pressure_toggle = list()

/datum/species/vox/get_random_name(var/gender)
	var/datum/language/species_language = GLOB.all_languages[default_language]
	return species_language.get_random_name(gender)

/datum/species/vox/equip_survival_gear(var/mob/living/carbon/human/H, var/extendedtank = 0,var/comprehensive = 0)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vox(H), slot_wear_mask)

/datum/species/vox/get_slowdown(var/mob/living/carbon/human/H)
	if(current_pressure_toggle["\ref[H]"])
		return 1.5
	return ..()

/datum/species/vox/get_warning_low_pressure(var/mob/living/carbon/human/H)
	if(current_pressure_toggle["\ref[H]"])
		return 50
	return ..()

/datum/species/vox/get_hazard_low_pressure(var/mob/living/carbon/human/H)
	if(current_pressure_toggle["\ref[H]"])
		return 0
	return ..()

/mob/living/carbon/human/proc/toggle_vox_pressure_seal()
	set name = "Toggle Vox Pressure Seal"
	set category = "Abilities"
	set src = usr

	if(!istype(species, /datum/species/vox))
		verbs -= /mob/living/carbon/human/proc/toggle_vox_pressure_seal
		return

	if(incapacitated(INCAPACITATION_KNOCKOUT))
		to_chat(src, SPAN_WARNING("You are in no state to do that."))
		return

	var/datum/gender/G = gender_datums[get_visible_gender()]
	visible_message(SPAN_NOTICE("\The [src] begins flexing and realigning [G.his] scaling..."))
	if(!do_after(src, 2 SECONDS, src, FALSE))
		visible_message(
			SPAN_NOTICE("\The [src] ceases adjusting [G.his] scaling."),
			self_message = SPAN_WARNING("You must remain still to seal or unseal your scaling."))
		return

	if(incapacitated(INCAPACITATION_KNOCKOUT))
		to_chat(src, SPAN_WARNING("You are in no state to do that."))
		return

	// TODO: maybe add cold and heat thresholds to this.
	var/my_ref = "\ref[src]"
	var/datum/species/vox/kikiki = species
	if((kikiki.current_pressure_toggle[my_ref] = !kikiki.current_pressure_toggle[my_ref]))
		visible_message(
			SPAN_NOTICE("\The [src]'s scaling flattens and smooths out."),
			self_message = SPAN_NOTICE("You flatten your scaling and inflate internal bladders, protecting yourself against low pressure at the cost of dexterity.")
		)
	else
		visible_message(
			SPAN_NOTICE("\The [src]'s scaling bristles roughly."),
			self_message = SPAN_NOTICE("You bristle your scaling and deflate your internal bladders, restoring mobility but leaving yourself vulnerable to low pressure.")
		)

/datum/species/vox/apply_default_colours(var/mob/living/carbon/human/H)
	if(!H.h_style)
		H.h_style = "Short Vox Quills"
	var/hair_color = "#594219"
	H.r_hair = hex2num(copytext(hair_color,2,4))
	H.g_hair = hex2num(copytext(hair_color,4,6))
	H.b_hair = hex2num(copytext(hair_color,6,8))
	var/skin_color = "#526D29"
	H.r_skin = hex2num(copytext(skin_color,2,4))
	H.g_skin = hex2num(copytext(skin_color,4,6))
	H.b_skin = hex2num(copytext(skin_color,6,8))
	var/scutes_color = "#BC7D3E"
	var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
	if(head)
		head.markings = list(
			"Vox Beak" = list(
				"color" = scutes_color,
				"datum" = body_marking_styles_list["Vox Beak"]
			)
		)
	for(var/bp in list(BP_L_ARM, BP_L_HAND, BP_R_ARM, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/limb = H.get_organ(bp)
		if(limb)
			LAZYINITLIST(limb.markings)
			limb.markings["Vox Scutes"] = list(
				"color" = scutes_color,
				"datum" = body_marking_styles_list["Vox Scutes"]
			)
	var/claw_color = "#A0A654"
	for(var/bp in list(BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_TORSO))
		var/obj/item/organ/external/limb = H.get_organ(bp)
		if(limb)
			LAZYINITLIST(limb.markings)
			limb.markings["Vox Claws"] = list(
				"color" = claw_color,
				"datum" = body_marking_styles_list["Vox Claws"]
			)
	return TRUE

// Nerfs some vox aspects if you aren't an antag (ie. raider, merc)
// TODO: raider/non-raider voxforms, if there's some way to do that nicely...
/datum/species/vox/can_shred(mob/living/carbon/human/H, ignore_intent)
	if(H.mind && player_is_antag(H.mind))
		return ..()
	return FALSE

/datum/species/vox/get_siemens_coefficient(var/mob/living/carbon/human/H)
	if(H.mind && player_is_antag(H.mind))
		return ..()
	return 0.65 // resistant, but still able to be tased/shocked to an extent
