

/*
/datum/species/human/gravworlder
	name = "grav-adapted Human"
	name_plural = "grav-adapted Humans"
	blurb = "Heavier and stronger than a baseline human, gravity-adapted people have \
	thick radiation-resistant skin with a high lead content, denser bones, and recessed \
	eyes beneath a prominent brow in order to shield them from the glare of a dangerously \
	bright, alien sun. This comes at the cost of mobility, flexibility, and increased \
	oxygen requirements to support their robust metabolism."
	icobase = 'icons/mob/human_races/subspecies/r_gravworlder.dmi'

	flash_mod =     0.9
	oxy_mod =       1.1
	radiation_mod = 0.5
	brute_mod =     0.85
	slowdown =      1



/datum/species/human/spacer
	name = "space-adapted Human"
	name_plural = "space-adapted Humans"
	blurb = "Lithe and frail, these sickly folk were engineered for work in environments that \
	lack both light and atmosphere. As such, they're quite resistant to asphyxiation as well as \
	toxins, but they suffer from weakened bone structure and a marked vulnerability to bright lights."
	icobase = 'icons/mob/human_races/subspecies/r_spacer.dmi'

	oxy_mod =   0.8
	toxins_mod =   0.9
	flash_mod = 1.2
	brute_mod = 1.1
	burn_mod =  1.1
*/

/datum/species/human/vatgrown
	name = SPECIES_HUMAN_VATBORN
	name_plural = "Vatborn"
	blurb = "With cloning on the forefront of human scientific advancement, cheap mass production \
	of bodies is a very real and rather ethically grey industry. Vat-grown or Vatborn humans tend to be \
	paler than baseline, with no appendix and fewer inherited genetic disabilities, but a more aggressive metabolism."
	icobase = 'icons/mob/human_races/subspecies/r_vatgrown.dmi'

	toxins_mod =   1.1
	metabolic_rate = 1.15
	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_VOICE =    /obj/item/organ/internal/voicebox,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_SPLEEN =   /obj/item/organ/internal/spleen/minor,
		O_EYES =     /obj/item/organ/internal/eyes,
		O_STOMACH =	 /obj/item/organ/internal/stomach,
		O_INTESTINE =/obj/item/organ/internal/intestine
		)

/*
// These guys are going to need full resprites of all the suits/etc so I'm going to
// define them and commit the sprites, but leave the clothing for another day.
/datum/species/human/chimpanzee
	name = "uplifted Chimpanzee"
	name_plural = "uplifted Chimpanzees"
	blurb = "Ook ook."
	icobase = 'icons/mob/human_races/subspecies/r_upliftedchimp.dmi'
*/

/datum/species/human/teen
	name = "Human Adolescent"
	name_plural = "Humans Adolescents"
	name = SPECIES_HUMAN_TEEN
	spawn_flags = SPECIES_IS_WHITELISTED | SPECIES_CAN_JOIN
	blurb = "A young human which is currently too young to participate in civil powers such as voting or official positions but can legally work in many fields on a reduced wage."
	metabolic_rate = 1.15 // You know, puberty. Hormones. Growing.
	blood_volume = 480
	min_age = 13
	max_age = 17
	bandages_icon = 'icons/mob/bandage.dmi'
	total_health = 85
	additional_wage = 20
	icon_scale = 0.9
	icon_width = 1
	brute_mod = 0.5
	male_scream_sound	= 'sound/voice/human/boy_scream.ogg'
	female_scream_sound	= 'sound/voice/human/girl_scream.ogg'


	max_calories = TEEN_WEIGHT_MAX // Above this, heart attacks will happen
	min_calories = TEEN_WEIGHT_MIN //Below this, this species will die

	normal_calories =  TEEN_WEIGHT_NORMAL
	thinner_calories = TEEN_WEIGHT_THINNER
	thin_calories = TEEN_WEIGHT_THIN
	fat_calories = TEEN_WEIGHT_FAT
	obese_calories = TEEN_WEIGHT_OBESE


/datum/species/human/child
	name = "Human Child"
	name_plural = "Human Children"
	name = SPECIES_HUMAN_CHILD
	spawn_flags = SPECIES_IS_WHITELISTED | SPECIES_CAN_JOIN
	metabolic_rate = 1.10
	blurb = "A younger version of a human. Much weaker and smaller - cannot participate in paid job roles, but faster and more agile."
	mob_size = MOB_SMALL
	has_fine_manipulation = 0
	blood_volume = 300
	min_age = 8
	max_age = 12
	bandages_icon = 'icons/mob/bandage.dmi'
	total_health = 50
	brute_mod = 0.2
	additional_wage = 10
	icon_scale = 0.75
	icon_width = 0.75
	male_scream_sound		= 'sound/voice/human/boy_scream.ogg'
	female_scream_sound	= 'sound/voice/human/girl_scream.ogg'
	can_drive = 0

	max_calories = KID_WEIGHT_MAX // Above this, heart attacks will happen
	min_calories = KID_WEIGHT_MIN //Below this, this species will die

	normal_calories = KID_WEIGHT_NORMAL
	thinner_calories = KID_WEIGHT_THINNER
	thin_calories = KID_WEIGHT_THIN
	fat_calories = KID_WEIGHT_FAT
	obese_calories = KID_WEIGHT_OBESE
