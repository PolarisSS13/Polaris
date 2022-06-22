/datum/species/mantid
	name = SPECIES_MANTID
	name_plural = "Mantids"
	icobase = 'icons/mob/human_races/r_mantid.dmi'
	deform = 'icons/mob/human_races/r_def_mantid.dmi'
	name_language = LANGUAGE_MANTID_SIGN
	default_language = LANGUAGE_MANTID_SIGN
	language = LANGUAGE_MANTID_SIGN
	species_language = LANGUAGE_MANTID_SIGN
	secondary_langs = list(
		LANGUAGE_MANTID_VOCAL,
		LANGUAGE_MANTID_BROADCAST
	)
	num_alternate_languages = 2
	limb_blend_mode = ICON_MULTIPLY

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/strong
	)

	rarity_value = 6
	gluttonous = 2
	slowdown = -1

	show_ssd = "in torpor"

	base_color = "#159abd"

	blurb = "murderbugs oh no"
	catalogue_data = list(
		/datum/category_item/catalogue/fauna/mantid
	)
	speech_volume = 20
	speech_chance = 100
	speech_sounds = list(
		'sound/voice/mantid/mantid1.ogg',
		'sound/voice/mantid/mantid2.ogg',
		'sound/voice/mantid/mantid3.ogg',
		'sound/voice/mantid/mantid4.ogg',
		'sound/voice/mantid/mantid5.ogg',
		'sound/voice/mantid/mantid6.ogg'
	)

	heat_discomfort_strings = list(
		"You feel brittle and overheated.",
		"Your overheated carapace flexes uneasily.",
		"Overheated ichor trickles from your eyes."
		)
	cold_discomfort_strings = list(
		"Frost forms along your carapace.",
		"You hear a faint crackle of ice as you shift your freezing body.",
		"Your movements become sluggish under the weight of the chilly conditions."
	)

	shock_vulnerability = 0.2 // Crystalline body.
	oxy_mod = 0.8 // Don't need as much breathable gas as humans.
	toxins_mod = 0.8 // Not as biologically fragile as meatboys.
	radiation_mod = 0.5 // Not as biologically fragile as meatboys.
	flash_mod = 2 // Highly photosensitive.
	brute_mod = 1.2
	burn_mod =  0.9

	flags = NO_SCAN | NO_DEFIB
	spawn_flags = SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR | HAS_SKIN_COLOR

	blood_color = COLOR_CYAN
	flesh_color = COLOR_INDIGO

	damage_overlays = 'icons/mob/human_races/masks/dam_mantid.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_mantid.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_mantid.dmi'

	genders = list(MALE)
	ambiguous_genders = TRUE

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/insectoid),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid)
	)

	has_organ = list(
		O_HEART =             /obj/item/organ/internal/heart/insectoid,
		O_LUNGS =             /obj/item/organ/internal/lungs/insectoid,
		O_LIVER =             /obj/item/organ/internal/liver/insectoid,
		O_KIDNEYS =           /obj/item/organ/internal/kidneys/insectoid,
		O_BRAIN =             /obj/item/organ/internal/brain/insectoid,
		O_EYES =              /obj/item/organ/internal/eyes/insectoid,
		O_STOMACH =           /obj/item/organ/internal/stomach/insectoid,
		O_SYSTEM_CONTROLLER = /obj/item/organ/internal/robotic/system_controller
	)

	descriptors = list(
		/datum/mob_descriptor/height = 2,
		/datum/mob_descriptor/build = -1,
		/datum/mob_descriptor/body_length = 1
	)

	default_emotes = list(
		/decl/emote/audible/mantid_purr,
		/decl/emote/audible/mantid_hiss,
		/decl/emote/audible/mantid_snarl,
		/decl/emote/visible/mantid_flicker,
		/decl/emote/visible/mantid_glint,
		/decl/emote/visible/mantid_glimmer,
		/decl/emote/visible/mantid_pulse,
		/decl/emote/visible/mantid_shine,
		/decl/emote/visible/mantid_dazzle
	)

/*
	pain_emotes_with_pain_level = list(
		list(/decl/emote/visible/mantid_shine, /decl/emote/visible/mantid_dazzle) = 80,
		list(/decl/emote/visible/mantid_glimmer, /decl/emote/visible/mantid_pulse) = 50,
		list(/decl/emote/visible/mantid_flicker, /decl/emote/visible/mantid_glint) = 20,
	)
*/

/datum/species/mantid/sanitize_name(var/name, var/robot = 0)
	return ..(name, TRUE)

/datum/category_item/catalogue/fauna/mantid

/decl/emote/audible/mantid_purr
	key = "mpurr"
	emote_message_3p = "purrs."
	emote_sound = 'sound/voice/mantid/mantid1.ogg'

/decl/emote/audible/mantid_hiss
	key = "mhiss"
	emote_message_3p = "hisses."
	emote_sound = 'sound/voice/mantid/razorweb.ogg'

/decl/emote/audible/mantid_snarl
	key = "msnarl"
	emote_message_3p = "snarls."
	emote_sound = 'sound/voice/mantid/razorweb_hiss.ogg'

/decl/emote/visible/mantid_flicker
	key = "mflicker"
	emote_message_3p = "flickers prismatically."

/decl/emote/visible/mantid_glint
	key = "mglint"
	emote_message_3p = "glints."

/decl/emote/visible/mantid_glimmer
	key = "mglimmer"
	emote_message_3p = "glimmers."

/decl/emote/visible/mantid_pulse
	key = "mpulse"
	emote_message_3p = "pulses with light."

/decl/emote/visible/mantid_shine
	key = "mshine"
	emote_message_3p = "shines brightly!"

/decl/emote/visible/mantid_dazzle
	key = "mdazzle"
	emote_message_3p = "dazzles!"
